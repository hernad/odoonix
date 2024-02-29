# -*- coding: utf-8 -*-
import time
import babel
from odoo import models, fields, api, tools, _
from datetime import datetime


class HrPayslipInput(models.Model):
    _inherit = 'hr.payslip.input'

    loan_line_id = fields.Many2one('hr.loan.line', string="Loan Installment", help="Loan installment")


class HrPayslip(models.Model):
    _inherit = 'hr.payslip'

    #@api.onchange('employee_id', 'date_from', 'date_to')
    #def onchange_employee(self):
    #    if (not self.employee_id) or (not self.date_from) or (not self.date_to):
    #        return

    #    employee = self.employee_id
    #    date_from = self.date_from
    #    date_to = self.date_to
    #    contract_ids = []

    #    ttyme = datetime.fromtimestamp(time.mktime(time.strptime(str(date_from), "%Y-%m-%d")))
    #    locale = self.env.context.get('lang') or 'en_US'
    #    self.name = _('Salary Slip of %s for %s') % (
    #        employee.name, tools.ustr(babel.dates.format_date(date=ttyme, format='MMMM-y', locale=locale)))
    #    self.company_id = employee.company_id
    #
    #    if not self.env.context.get('contract') or not self.contract_id:
    #        contract_ids = self.get_contract(employee, date_from, date_to)
    #        if not contract_ids:
    #            return
    #        self.contract_id = self.env['hr.contract'].browse(contract_ids[0])
    #
    #    if not self.contract_id.struct_id:
    #        return
    #    self.struct_id = self.contract_id.struct_id
    #
    #    # computation of the salary input
    #    contracts = self.env['hr.contract'].browse(contract_ids)
    #    worked_days_line_ids = self.get_worked_day_lines(contracts, date_from, date_to)
    #    worked_days_lines = self.worked_days_line_ids.browse([])
    #    for r in worked_days_line_ids:
    #        worked_days_lines += worked_days_lines.new(r)
    #    self.worked_days_line_ids = worked_days_lines
    #    if contracts:
    #        input_line_ids = self.get_inputs(contracts, date_from, date_to)
    #        input_lines = self.input_line_ids.browse([])
    #        for r in input_line_ids:
    #            input_lines += input_lines.new(r)
    #        self.input_line_ids = input_lines
    #    return

    def get_inputs(self, contract_ids, date_from, date_to):
        """This Compute the other inputs to employee payslip.
                           """
        res = super(HrPayslip, self).get_inputs(contract_ids, date_from, date_to)
        contract_obj = self.env['hr.contract']

        contract_for_loan = None
        for contract in contract_ids:
            if not ('INO' in contract.struct_id.code):
                contract_for_loan = contract
                break

        if not contract_for_loan:
            return res

        emp_id = contract_obj.browse(contract_for_loan.id).employee_id
        lon_obj = self.env['hr.loan'].search([('employee_id', '=', emp_id.id), ('state', '=', 'approve')])
        for loan in lon_obj:
            for loan_line in loan.loan_lines:
                # pick unpaid lines
                if date_from <= loan_line.date <= date_to and not loan_line.paid:
                    for result in res:
                        if result.get('code') == 'LOAN':
                            result['amount_qty'] = 1
                            result['amount'] = loan_line.amount
                            result['loan_line_id'] = loan_line.id
        return res

    
    def action_payslip_done(self):
        # + calculate loan amount
        for line in self.input_line_ids:
            if line.loan_line_id:
                line.loan_line_id.paid = True
                line.loan_line_id.payslip_id = self.id
                line.loan_line_id.loan_id._compute_loan_amount()
        return super(HrPayslip, self).action_payslip_done()
