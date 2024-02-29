# -*- coding: utf-8 -*-
import time
import babel
from odoo import models, fields, api, tools, _
from datetime import datetime


class HrPayslipInput(models.Model):
    _inherit = 'hr.payslip.input'

    payroll_add_id = fields.Many2one('hr.payroll.input.add', string="Payroll add", help="Payroll add")


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

        contract_for_add = None
        for contract in contract_ids:
            if not ('INO' in contract.struct_id.code):
                contract_for_add = contract
                break

        if not contract_for_add:
            return res

        emp_id = contract_obj.browse(contract_for_add.id).employee_id
        db_payroll_add = self.env['hr.payroll.input.add'].search([('employee_id', '=', emp_id.id), ('state', '=', 'approve')])
        for payroll_add in db_payroll_add:

            if date_from <= payroll_add.payment_date <= date_to:
                    for result in res:
                        if result.get('code') == 'ADD':
                            result['amount_qty'] = 1
                            result['amount'] = payroll_add.add_amount
                            result['payroll_add_id'] = payroll_add.id
        return res

    
    def action_payslip_done(self):
        # set input_line payslip_id for payroll add 
        for line in self.input_line_ids:
            if line.payroll_add_id:
                line.payroll_add_id.payslip_id = self.id
        return super(HrPayslip, self).action_payslip_done()
