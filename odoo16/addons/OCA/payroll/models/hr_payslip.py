# Part of Odoo. See LICENSE file for full copyright and licensing details.

from datetime import date, datetime, time

import babel
from dateutil.relativedelta import relativedelta
from pytz import timezone

from odoo import _, api, fields, models, tools
from odoo.exceptions import UserError, ValidationError
from odoo.tools.safe_eval import safe_eval

from .base_browsable import (
    BaseBrowsableObject,
    BrowsableObject,
    InputLine,
    Payslips,
    WorkedDays,
)


class HrPayslip(models.Model):
    _name = "hr.payslip"
    _inherit = ["mail.thread", "mail.activity.mixin"]
    _description = "Payslip"
    _order = "id desc"

    #struct_id = fields.Many2one(
    #    "hr.payroll.structure",
    #    string="Structure",
    #    readonly=True,
    #    states={"draft": [("readonly", False)]},
    #    help="Defines the rules that have to be applied to this payslip, "
    #    "accordingly to the contract chosen. If you let empty the field "
    #    "contract, this field isn't mandatory anymore and thus the rules "
    #    "applied will be all the rules set on the structure of all contracts "
    #    "of the employee valid for the chosen period",
    #)

    name = fields.Char(
        string="Payslip Name", readonly=True, states={"draft": [("readonly", False)]}
    )
    number = fields.Char(
        string="Reference",
        readonly=True,
        copy=False,
        states={"draft": [("readonly", False)]},
    )
    employee_id = fields.Many2one(
        "hr.employee",
        string="Employee",
        required=True,
        readonly=True,
        states={"draft": [("readonly", False)]},
    )
    date_from = fields.Date(
        string="Date From",
        readonly=True,
        required=True,
        default=lambda self: fields.Date.to_string(date.today().replace(day=1)),
        states={"draft": [("readonly", False)]},
        tracking=True,
    )
    date_to = fields.Date(
        string="Date To",
        readonly=True,
        required=True,
        default=lambda self: fields.Date.to_string(
            (datetime.now() + relativedelta(months=+1, day=1, days=-1)).date()
        ),
        states={"draft": [("readonly", False)]},
        tracking=True,
    )
    state = fields.Selection(
        [
            ("draft", "Draft"),
            ("verify", "Waiting"),
            ("done", "Done"),
            ("cancel", "Rejected"),
        ],
        string="Status",
        index=True,
        readonly=True,
        copy=False,
        default="draft",
        tracking=True,
        help="""* When the payslip is created the status is \'Draft\'
        \n* If the payslip is under verification, the status is \'Waiting\'.
        \n* If the payslip is confirmed then status is set to \'Done\'.
        \n* When user cancel payslip the status is \'Rejected\'.""",
    )
    line_ids = fields.One2many(
        "hr.payslip.line",
        "slip_id",
        string="Payslip Lines",
        readonly=True,
        states={"draft": [("readonly", False)]},
    )
    company_id = fields.Many2one(
        "res.company",
        string="Company",
        readonly=True,
        copy=False,
        default=lambda self: self.env.company,
        states={"draft": [("readonly", False)]},
    )
    worked_days_line_ids = fields.One2many(
        "hr.payslip.worked_days",
        "payslip_id",
        string="Payslip Worked Days",
        copy=True,
        readonly=True,
        states={"draft": [("readonly", False)]},
    )
    input_line_ids = fields.One2many(
        "hr.payslip.input",
        "payslip_id",
        string="Payslip Inputs",
        readonly=True,
        states={"draft": [("readonly", False)]},
    )
    paid = fields.Boolean(
        string="Made Payment Order ? ",
        readonly=True,
        copy=False,
        states={"draft": [("readonly", False)]},
    )
    note = fields.Text(
        string="Internal Note",
        readonly=True,
        states={"draft": [("readonly", False)]},
        tracking=True,
    )
    #contract_id = fields.Many2one(
    #    "hr.contract",
    #    string="Contract",
    #    readonly=True,
    #    tracking=True,
    #    states={"draft": [("readonly", False)]},
    #)
    details_by_salary_rule_category = fields.One2many(
        "hr.payslip.line",
        compute="_compute_details_by_salary_rule_category",
        string="Details by Salary Rule Category",
    )
    details_by_salary_rule_category_all = fields.One2many(
        "hr.payslip.line",
        compute="_compute_details_by_salary_rule_category_all",
        string="Details by Salary Rule Category All",
    )
    dynamic_filtered_payslip_lines = fields.One2many(
        "hr.payslip.line",
        compute="_compute_dynamic_filtered_payslip_lines",
        string="Dynamic Filtered Payslip Lines",
    )
    credit_note = fields.Boolean(
        string="Credit Note",
        readonly=True,
        states={"draft": [("readonly", False)]},
        help="Indicates this payslip has a refund of another",
    )
    payslip_run_id = fields.Many2one(
        "hr.payslip.run",
        string="Payslip Batches",
        readonly=True,
        copy=False,
        tracking=True,
        states={"draft": [("readonly", False)]},
    )
    payslip_count = fields.Integer(
        compute="_compute_payslip_count", string="Payslip Computation Details"
    )
    hide_child_lines = fields.Boolean(string="Hide Child Lines", default=False)
    compute_date = fields.Date("Compute Date")
    refunded_id = fields.Many2one(
        "hr.payslip", string="Refunded Payslip", readonly=True
    )
    allow_cancel_payslips = fields.Boolean(
        "Allow Cancel Payslips", compute="_compute_allow_cancel_payslips"
    )


    __slots__ = ('analytic_line_spent',)

    #@api.constrains('contract_id')
    #def validate_contract_id(self):
    #    for record in self:
    #        if not record.contract_id:
    #            raise ValidateError(_("Please set contract for payslip!"))


    def _compute_allow_cancel_payslips(self):
        self.allow_cancel_payslips = (
            self.env["ir.config_parameter"]
            .sudo()
            .get_param("payroll.allow_cancel_payslips")
        )

    @api.depends("line_ids", "hide_child_lines")
    def _compute_dynamic_filtered_payslip_lines(self):
        for payslip in self:
            if payslip.hide_child_lines:
                payslip.dynamic_filtered_payslip_lines = payslip.mapped(
                    "line_ids"
                ).filtered(lambda line: not line.parent_rule_id)
            else:
                payslip.dynamic_filtered_payslip_lines = payslip.line_ids

    @api.depends("line_ids")
    def _compute_details_by_salary_rule_category(self):
        for payslip in self:
            payslip.details_by_salary_rule_category = payslip.mapped(
                "line_ids"
            ).filtered(lambda line: line.category_id and line.appears_on_payslip)

    @api.depends("line_ids")
    def _compute_details_by_salary_rule_category_all(self):
        for payslip in self:
            payslip.details_by_salary_rule_category_all = payslip.mapped(
                "line_ids"
            ).filtered(lambda line: line.category_id)

    def _compute_payslip_count(self):
        for payslip in self:
            payslip.payslip_count = len(payslip.line_ids)

    @api.constrains("date_from", "date_to")
    def _check_dates(self):
        if any(self.filtered(lambda payslip: payslip.date_from > payslip.date_to)):
            raise ValidationError(
                _("Payslip 'Date From' must be earlier than 'Date To'.")
            )

    def copy(self, default=None):
        rec = super().copy(default)
        for line in self.input_line_ids:
            line.copy({"payslip_id": rec.id})
        for line in self.line_ids:
            line.copy({"slip_id": rec.id, "input_ids": []})
        return rec

    def action_payslip_draft(self):
        return self.write({"state": "draft"})

    def action_payslip_done(self):
        if not self.env.context.get("without_compute_sheet"):
            self.compute_sheet()
        return self.write({"state": "done"})

    def action_payslip_cancel(self):
        for payslip in self:
            if payslip.allow_cancel_payslips:
                if payslip.refunded_id and payslip.refunded_id.state != "cancel":
                    raise ValidationError(
                        _(
                            """To cancel the Original Payslip the
                        Refunded Payslip needs to be canceled first!"""
                        )
                    )
            else:
                if self.filtered(lambda slip: slip.state == "done"):
                    raise UserError(_("Cannot cancel a payslip that is done."))
        return self.write({"state": "cancel"})

    def refund_sheet(self):
        for payslip in self:
            copied_payslip = payslip.copy(
                {"credit_note": True, "name": _("Refund: %s") % payslip.name}
            )
            number = copied_payslip.number or self.env["ir.sequence"].next_by_code(
                "salary.slip"
            )
            copied_payslip.write({"number": number})
            copied_payslip.with_context(
                without_compute_sheet=True
            ).action_payslip_done()
        formview_ref = self.env.ref("payroll.hr_payslip_view_form", False)
        treeview_ref = self.env.ref("payroll.hr_payslip_view_tree", False)
        res = {
            "name": _("Refund Payslip"),
            "view_mode": "tree, form",
            "view_id": False,
            "res_model": "hr.payslip",
            "type": "ir.actions.act_window",
            "target": "current",
            "domain": "[('id', 'in', %s)]" % copied_payslip.ids,
            "views": [
                (treeview_ref and treeview_ref.id or False, "tree"),
                (formview_ref and formview_ref.id or False, "form"),
            ],
            "context": {},
        }
        payslip.write({"refunded_id": safe_eval(res["domain"])[0][2][0] or False})
        return res

    def unlink(self):
        if any(self.filtered(lambda payslip: payslip.state not in ("draft", "cancel"))):
            raise UserError(
                _("You cannot delete a payslip which is not draft or cancelled")
            )
        return super(HrPayslip, self).unlink()


    def compute_selected_sheets(self):

        for payslip_id in self._context['active_ids']:
            payslip = self.env['hr.payslip'].browse(payslip_id)
            payslip.compute_sheet()


    def compute_sheet(self):
        for payslip in self:
            # delete old payslip lines
            payslip.line_ids.unlink()
            # set the list of contract for which the rules have to be applied
            # if we don't give the contract, then the rules to apply should be
            # for all current contracts of the employee
            contract_ids = (
                #hernad ne gledaj payslip.contract
                #payslip.contract_id.ids
                #or
                payslip.employee_id._get_contracts(
                    date_from=payslip.date_from, date_to=payslip.date_to
                ).ids
            )
            # write payslip lines
            number = payslip.number or self.env["ir.sequence"].next_by_code(
                "salary.slip"
            )
            lines = [
                (0, 0, line)
                for line in list(
                    self._get_payslip_lines(contract_ids, payslip.id).values()
                )
            ]
            payslip.write(
                {
                    "line_ids": lines,
                    "number": number,
                    "state": "verify",
                    "compute_date": fields.Date.today(),
                }
            )
        return True

    @api.model
    def get_worked_day_lines(self, contracts, date_from, date_to):
        """
        @param contracts: Browse record of contracts
        @return: returns a list of dict containing the input that should be
        applied for the given contract between date_from and date_to
        """
        res = []
        self.worked_days_line_ids.unlink()
        self.env.cr.commit()

        self.analytic_line_spent = []

        # contract must have resource_calendar_id
        for contract in contracts.filtered(
            lambda contract: contract.resource_calendar_id
        ).sorted(
            lambda contract: contract.date_start
        ):
            day_from = datetime.combine(date_from, time.min)
            day_to = datetime.combine(date_to, time.max)
            day_contract_start = datetime.combine(contract.date_start, time.min)
            day_contract_end = day_to
            if contract.date_end:
               day_contract_end = datetime.combine(contract.date_end, time.max)
            # Support for the hr_public_holidays module.
            contract = contract.with_context(
                employee_id=self.employee_id.id, exclude_public_holidays=True
            )
            # only use payslip day_from if it's greather than contract start date
            if day_from < day_contract_start:
                day_from = day_contract_start
            if day_to > day_contract_end:
                day_to = day_contract_end

            # if contract < end of month, full month > worked days: FWORK100
            full_month_att = self._compute_full_month_worked_days(contract, day_from, day_to)
            res.append(full_month_att)

            # == compute worked days: WORK100
            attendances = self._compute_worked_days(contract, day_from, day_to)
            res.append(attendances)
            hours_fond = attendances["number_of_hours"]
            food_max_days = attendances["number_of_days"]

            # INO contracts have no timesheet and leave days
            if not ('INO' in contract.struct_id.code):
                # == compute leave days == #
                leaves = self._compute_leave_days(contract, day_from, day_to)
                for leave in leaves:
                    hours_fond -= abs(leave["number_of_hours"])
                    # umanji fond TO dana za odsustva
                    food_max_days -= abs(leave["number_of_days"])
                #  extend() method adds multiple items.
                res.extend(leaves)

                # == compute timesheet hours-days == #
                timesheets = self._compute_timesheet_hours(hours_fond, food_max_days, contract, day_to)
                for timesheet in timesheets:
                    # timesheet["number_of_days"] == 0 for work on holiday
                    if timesheet["code"] != "FOOD" and timesheet["number_of_days"] != 0:
                        hours_fond -= timesheet["number_of_hours"]
                res.extend(timesheets)
                # hours fond is not completely spent
                if hours_fond > 0:
                    rest_time = self._generate_rest(contract, hours_fond)
                    res.append(rest_time)

        return res

    def _compute_leave_days(self, contract, day_from, day_to):
        """
        Leave days computation
        @return: returns a list containing the leave inputs for the period
        of the payslip. One record per leave type.
        """
        leaves_positive = (
            self.env["ir.config_parameter"].sudo().get_param("payroll.leaves_positive")
        )
        leaves = {}
        calendar = contract.resource_calendar_id
        tz = timezone(calendar.tz)
        domain = [('time_type', 'in', ['leave', 'other'])]
        day_leave_intervals = contract.employee_id.list_leaves(
            day_from, day_to, calendar=contract.resource_calendar_id, domain=domain)

        for day, hours, leaves_list in day_leave_intervals:
            #if len(leaves_list) == 1:
            #    holiday_name = leaves_list[0].holiday_id.holiday_status_id.name
            #else:
            #    # only one leave has analytic.line items (leave.timesheet_ids)
            #    holiday_name = list(filter(lambda leave: len(leave.timesheet_ids) > 0, leaves_list))[0].name
            holiday = leaves_list[:1].holiday_id
            name = "Leaves"
            code = "LEAVE_"
            #if holiday.holiday_status_id.unpaid:
            #    name = "Unapid Leaves"
            #    code = "LEAVE_U"

            code = None
            if holiday:
                code = holiday.holiday_status_id.name.replace(' ', '_').upper()
                for d, e in [('Č', 'C'), ('Ć', 'C'), ('Ž', 'Z'), ('Đ', 'DJ'), ('Š', 'S')]:
                    code = code.replace(d, e)

            current_leave_struct = leaves.setdefault(
                holiday.holiday_status_id,
                {
                    "name": holiday.holiday_status_id.name or _("Global Leaves"),
                    "sequence": 5,
                    "code": code or "GLOBAL",
                    "number_of_days": 0.0,
                    "number_of_hours": 0.0,
                    "contract_id": contract.id,
                },
            )
            if leaves_positive:
                current_leave_struct["number_of_hours"] += hours
            else:
                current_leave_struct["number_of_hours"] -= hours
            work_hours = calendar.get_work_hours_count(
                tz.localize(datetime.combine(day, time.min)),
                tz.localize(datetime.combine(day, time.max)),
                compute_leaves=False,
            )
            if work_hours:
                if leaves_positive:
                    current_leave_struct["number_of_days"] += hours / work_hours
                else:
                    current_leave_struct["number_of_days"] -= hours / work_hours
        return leaves.values()


    # na osnovu opisa odsustva preko 42d, POS_PLATA_SAT=5.75 se obracunava bolovanje preko
    def get_bol_preko_pos_puna_sat_inputs(self, inputs, contract_ids, date_from, date_to):

        contract_input = None
        for contract in contract_ids:
            if not ('INO' in contract.struct_id.code):
                contract_input = contract
                break

        if not contract_input:
            return inputs

        contract_obj = self.env['hr.contract']
        emp_id = contract_obj.browse(contract_input.id).employee_id

        leave_bolov_preko_id = self.env.ref("l10n_bs_hr_payroll_fuelboss.leave_bolov_preko").id
        #uzmi ovo iz opisa odsustva preko 42d
        db_bol_preko_pos_plata_sat = self.env['hr.leave'].search(
            [
              ('employee_id', '=', emp_id.id),
              ('holiday_status_id', '=', leave_bolov_preko_id),
              ('private_name', 'like', '%POS_PLATA_SAT%'),
              ('date_to', '>=', date_from)
            ],
            limit=1, order='request_date_to desc')
        for line_pos_plata_sat in db_bol_preko_pos_plata_sat:
            for input in inputs:
                if input.get('code') == 'POS_PLATA_SAT':
                    amnt_str = line_pos_plata_sat.private_name.replace('POS_PLATA_SAT', '')
                    amnt_str = amnt_str.replace('=','')
                    # ako je unos 3,35 => 3.35
                    amnt_str = amnt_str.replace(',', '.')
                    input['amount_qty'] = 1
                    input['amount'] = float(amnt_str)

        return inputs
    def _compute_worked_days(self, contract, day_from, day_to):

        """
        Worked days computation
        @return: returns a list containing the total worked_days for the period
        of the payslip. This returns the FULL work days expected for the resource
        calendar selected for the employee (it don't substract leaves by default).
        """
        work_data = contract.employee_id._get_work_days_data_batch(
            day_from,
            day_to,
            calendar=contract.resource_calendar_id,
            compute_leaves=False,
            domain=None,
        )

        #import pdb; pdb.set_trace()

        #if self.employee_id.id:
        #    work_data_item = work_data.get(self.employee_id.id)
        # work_data = { 27: { 'days': 21, 'hours': 168 }}
        work_data_item = list(work_data.items())[0][1]

        return {
                "name": _("Normal Working Days paid at 100%"),
                "sequence": 1,
                "code": "WORK100",
                "number_of_days": work_data_item["days"],
                "number_of_hours": work_data_item["hours"],
                "contract_id": contract.id,
            }

    def _compute_full_month_worked_days(self, contract, day_from, day_to):

        # full worked hours for this month
        #self.env.company.resource_calendar_id.get_work_hours_count(
        # datetime.strptime('2022-11-1', '%Y-%m-%d'), datetime.strptime('2022-11-30', '%Y-%m-%d')) / 8

        # if contract ends before there is difference we need to know in payroll calculations
        day_from = day_from + relativedelta(months=-1, day=1)  # month-1, first in month
        day_from = day_from + relativedelta(months=+1) # back to month, first in month

        day_to = day_to + relativedelta(months=+1, day=1, days=-1)
        full_hours = self.env.company.resource_calendar_id.get_work_hours_count(day_from, day_to)
        return {
            "name": _("Full month working days"),
            "sequence": 2,
            "code": "FWORK100",
            "number_of_days": full_hours / 8,
            "number_of_hours": full_hours,
            "contract_id": contract.id,
        }



    def _compute_timesheet_hours(self, hours_to_spend, food_max_days, contract, date_to):

        def sort_crit_0(line):
            if '#P#' in line.name: # potrošiti obavezno ovaj obračun
                return "9"
            elif '#R#' in line.name:  # stavke koje su na drugi način već isplaćene (npr. data roba)
                return "8"
            elif line.work_type_id.code in ['30_WF', '31_W', '40_XF', '41_X', '60_G']:
                # rad na drzavni praznik, godišnji odmor neiskorišten
                return "7"
            elif line.work_type_id.code in ['20_NF', '21_N']:
                # nocni rad
                return "6"
            elif line.work_type_id.code in ['10_SF', '70_T']:
                # redovan rad sa TO, topli obrok "only"
                return "5"
            elif line.work_type_id.code in ['11_S']:
                # redovan rad bez TO
                return "4"
            else:
                return "0"

        # datumi opadajuci kriterij
        def sort_crit_1(line):
            return line.date

        # stavke sa toplim obrokom
        #def sort_crit_2(line):
        #    # prvo potroshi stavke sa TO
        #    if line.work_type_id.food_included:
        #        return "B"
        #    else:
        #        return "A"

        env = self.env

        # get timesheets for employee
        employee_id = contract.employee_id

        work_type_object = env['hr.timesheet.work_type']
        work_types = work_type_object.search([])

        timesheet_data = []
        # brojač potrošenih TO
        food_included_days = 0
        timesheet_hours = {}
        # initialize timesheet_hours dict
        for work_type in work_types:
            timesheet_hours[work_type.code] = 0
            timesheet_hours[work_type.code + '_P'] = 0
            timesheet_hours[work_type.code + '_R'] = 0

        analytic_line_object = env['account.analytic.line']
        # order date desc, code = 10_SF, 11_S, 20_NF, 21_N ...
        # ovakvim poretkom su za stavke sa istim datumom u vrhu one koje sadrze FOOD (TO) 10_SF ispred 11_S itd
        lines = analytic_line_object.search([
            ('employee_id', '=', employee_id.id),
            # ('date', '>=', date_from),
            ('date', '<=', date_to),
            ('work_type_id', '!=', False),
            ('global_leave_id', '=', False),
            ('holiday_id', '=', False),
            ('worked_days_ids', '=', False)
            # timesheet not spent (False) or this worked_days_ids exist in current worked_days_line_ids
            #'|', ('worked_days_ids', '=', False),
            #     ('worked_days_ids', 'in', [line.id for line in self.worked_days_line_ids])
        ], order="date desc")

        # https://stackoverflow.com/questions/4233476/sort-a-list-by-multiple-attributes

        timesheet_item_ids = []
        for line in sorted(lines, key=lambda line: (sort_crit_0(line), sort_crit_1(line)), reverse=True):
            if line in self.analytic_line_spent:
                # already spent
                continue

            # ostalo iz fonda dana za TO
            food_days_rest = food_max_days - food_included_days

            # nothing left to spend - ni sati ni dana TO
            if hours_to_spend <= 0 and food_days_rest <= 0:
                break

            splited = line.split_as_needed(hours_to_spend=hours_to_spend, food_days_rest=food_days_rest)

            if line.work_type_id.code == '70_T' and food_days_rest == 0:
                if not '#P#' in line.name:
                    continue
            elif (hours_to_spend > 0) or ((hours_to_spend <= 0) and (food_days_rest > 0) and splited):
                # ova linija se uzima u obzir samo ako nismo potrosili sate ili smo u slucaju da imamo
                # samo TO za raspodjelu napravili split - generisali 70_T stavku
                self.analytic_line_spent.append(line)
            else:
                # linija se ne moze uzeti, pokusaj sljedecu
                continue

            # TODO: use product_uom_id
            # TODO: day = timesheet_hours / 8?  use _get_work_hours?

            # imamo sati za potrositi "potrositi"
            if (hours_to_spend > 0) and (hours_to_spend >= line.unit_amount):
                # this timesheet item has food included
                if line.work_type_id.food_included:
                    food_included_days += 1
                    if '#P#' in line.name:
                        # ove stavke idu preko limita fonda dana za TO
                        food_max_days += 1
                if not ('#P#' in line.name) and not ('#R#' in line.name) and not (line.work_type_id.code == '70_T'):
                   # 10_SF - standard work with food
                   timesheet_hours[line.work_type_id.code] += line.unit_amount
                else:
                   # line.work_type_id.code == '70_T' samo dodaje food, bez sati realizacije
                   if ('#P#' in line.name):
                     # 10_SF_P - standard work with food force pay
                     timesheet_hours[line.work_type_id.code + '_P'] += line.unit_amount
                   elif ('#R#' in line.name):
                     # 10_SF_R - standard work already realized
                     timesheet_hours[line.work_type_id.code + '_R'] += line.unit_amount

                # work on holiday is not included in monthly hours fond,
                # so work_type.hours_fond_included = False
                if line.work_type_id.hours_fond_included:
                    if not ('#P#' in line.name) and not ('#R#' in line.name) and not (line.work_type_id.code == '70_T'):
                      hours_to_spend -= line.unit_amount
                timesheet_item_ids.append(line.id)

            # nemamo sati za potrositi ali imamo dana TO, ova stavka je sa TO
            elif ((hours_to_spend <= 0) and (food_days_rest > 0) and splited):
                # samo dodajemo dane TO
                food_included_days += 1
                timesheet_item_ids.append(line.id)


        for work_type in work_types:
            # force pay stavke
            if (work_type.code + '_P') in timesheet_hours.keys() and timesheet_hours[work_type.code + '_P'] > 0:
                timesheet_data.append({
                    "name": _(work_type.name) + ' #P#',
                    "sequence": 99,
                    "code": "TSH_P_" + work_type.code.upper(),
                    "number_of_hours": timesheet_hours[work_type.code + '_P'],
                    "number_of_days": (timesheet_hours[work_type.code + '_P'] / 8),
                    "contract_id": contract.id,
                    # https://www.odoo.com/forum/help-1/overwrite-write-method-many2many-102545
                    "timesheet_item_ids": [(6, 0, timesheet_item_ids)]
                })
            # already realized stavke
            if (work_type.code + '_R') in timesheet_hours.keys() and timesheet_hours[work_type.code + '_R'] > 0:
                timesheet_data.append({
                    "name": _(work_type.name) + ' #R#',
                    "sequence": 99,
                    "code": "TSH_R_" + work_type.code.upper(),
                    "number_of_hours": timesheet_hours[work_type.code + '_R'],
                    "number_of_days": (timesheet_hours[work_type.code + '_R'] / 8),
                    "contract_id": contract.id,
                    "timesheet_item_ids": [(6, 0, timesheet_item_ids)]
                })
            if timesheet_hours[work_type.code] > 0:
                timesheet_data.append({
                    "name": _(work_type.name),
                    "sequence": 90,
                    "code": "TSH_" + work_type.code.upper(),
                    "number_of_hours": timesheet_hours[work_type.code],
                    # number_of_days 0, if this work_type is not included in hours fond
                    "number_of_days": (timesheet_hours[work_type.code] / 8 if work_type.hours_fond_included else 0),
                    "contract_id": contract.id,
                    # https://www.odoo.com/forum/help-1/overwrite-write-method-many2many-102545
                    "timesheet_item_ids": [(6, 0, timesheet_item_ids)]
                })

        timesheet_data.append({
            "name": _("Food included"),
            "code": "FOOD",
            "sequence": 100,
            "number_of_days": food_included_days,
            "number_of_hours": food_included_days * 8,
            "contract_id": contract.id
        })
        return timesheet_data

    def _generate_rest(self, contract, rest_hours):

        return {
            "name": _("Rest time"),
            "sequence": 200,
            "code": "REST",
            "number_of_hours": rest_hours,
            "number_of_days": rest_hours / 8,
            "contract_id": contract.id,
        }
    @api.model
    def get_inputs(self, contracts, date_from, date_to):
        # TODO: We leave date_from and date_to params here for backwards
        # compatibility reasons for the ones who inherit this function
        # in another modules, but they are not used.
        # Will be removed in next versions.
        """
        Inputs computation.
        @returns: Returns a dict with the inputs that are fetched from the salary_structure
        associated rules for the given contracts.
        """
        res = []
        structure_ids = contracts.get_all_structures()
        rule_ids = (
            self.env["hr.payroll.structure"].browse(structure_ids).get_all_rules()
        )
        sorted_rule_ids = [id for id, sequence in sorted(rule_ids, key=lambda x: x[1])]
        payslip_inputs = (
            self.env["hr.salary.rule"].browse(sorted_rule_ids).mapped("input_ids")
        )

        for contract in contracts:
            for payslip_input in payslip_inputs:
                # detashirani skip inputs
                if not ('INO' in contract.struct_id.code):
                    res.append(
                        {
                            "name": payslip_input.name,
                            "code": payslip_input.code,
                            "contract_id": contract.id,
                        }
                    )
        return res

    #def _init_payroll_dict_contracts(self):
    #    return {
    #        "count": 0,
    #    }

    def get_payroll_dict(self, contract):
        """Setup miscellaneous dictionary values.
        Other modules may overload this method to inject discreet values into
        the salary rules. Such values will be available to the salary rule
        under the `payroll.` prefix.

        This method is evaluated once per payslip.
        :param contract: hr.contract record
        :return: a dictionary of discreet values and/or Browsable Objects
        """
        self.ensure_one()

        #res = {
        #    # In salary rules refer to this as: payroll.contracts.count
        #    "contracts": BaseBrowsableObject(self._init_payroll_dict_contracts()),
        #}
        #res["contracts"].count = len(contract)

        #return res
        return {
            "contract": contract
        }

    def get_current_contract_dict(self, contract, contracts):
        """Contract dependent dictionary values.
        This method is called just before the salary rules are evaluated for
        contract.

        This method is evaluated once for every contract in the payslip.

        :param contract: The current hr.contract being processed
        :param contracts: Recordset of all hr.contract records in this payslip
        :return: a dictionary of discreet values and/or Browsable Objects
        """
        self.ensure_one()

        # res = super().get_contract_dict(contract, contracts)
        # res.update({
        #     # In salary rules refer to these as:
        #     #     current_contract.foo
        #     #     current_contract.foo.bar.baz
        #     "foo": 0,
        #     "bar": BaseBrowsableObject(
        #         {
        #             "baz": 0
        #         }
        #     )
        # })
        # <do something to update values in res>
        # return res

        return {}

    def _get_baselocaldict(self, contract):
        self.ensure_one()
        worked_days_dict = {
            line.code: line for line in self.worked_days_line_ids if line.code and line.contract_id == contract
        }
        input_lines_dict = {
            line.code: line for line in self.input_line_ids if line.code
        }
        localdict = {
            "payslip": Payslips(self.employee_id.id, self, self.env),
            "worked_days": WorkedDays(self.employee_id.id, worked_days_dict, self.env),
            "inputs": InputLine(self.employee_id.id, input_lines_dict, self.env),
            "payroll": BrowsableObject(
                self.employee_id.id, self.get_payroll_dict(contract), self.env
            ),
            "current_contract": BrowsableObject(self.employee_id.id, {}, self.env),
            "categories": BrowsableObject(self.employee_id.id, {}, self.env),
            "rules": BrowsableObject(self.employee_id.id, {}, self.env),
            "result_rules": BrowsableObject(self.employee_id.id, {}, self.env),
        }
        return localdict

    def _get_salary_rules(self, contract): #, payslip):
        #if len(contracts) == 1 and payslip.struct_id:
        #    structure_ids = list(set(payslip.struct_id._get_parent_structure().ids))
        #else:
        structure_ids = contract.get_all_structures()

        rule_ids = (
            self.env["hr.payroll.structure"].browse(structure_ids).get_all_rules()
        )
        sorted_rule_ids = [id for id, sequence in sorted(rule_ids, key=lambda x: x[1])]
        sorted_rules = self.env["hr.salary.rule"].browse(sorted_rule_ids)
        return sorted_rules


    def _compute_payslip_line(self, rule, localdict, lines_dict):
        self.ensure_one()
        # check if there is already a rule computed with that code
        previous_amount = rule.code in localdict and localdict[rule.code] or 0.0
        # compute the amount of the rule
        amount, qty, rate, computed_name = rule._compute_rule(localdict)
        rule_total = amount * qty * rate / 100.0
        # set/overwrite the amount computed for this rule in the localdict
        localdict[rule.code] = rule_total
        localdict["rules"].dict[rule.code] = rule
        localdict["result_rules"].dict[rule.code] = BaseBrowsableObject(
            {
             "quantity": qty, "rate": rate,
             "amount": amount, "total": rule_total
            }
        )
        # sum the amount for its salary category
        localdict = self._sum_salary_rule_category(
            localdict, rule.category_id, rule_total - previous_amount
        )
        # create/overwrite the rule in the temporary results
        key = rule.code + "-" + str(localdict["contract"].id)
        lines_dict[key] = {
            "salary_rule_id": rule.id,
            "contract_id": localdict["contract"].id,
            "name": computed_name and str(computed_name) or rule.name,
            "code": rule.code,
            "category_id": rule.category_id.id,
            "sequence": rule.sequence,
            "appears_on_payslip": rule.appears_on_payslip,
            "parent_rule_id": rule.parent_rule_id.id,
            "condition_select": rule.condition_select,
            "condition_python": rule.condition_python,
            "condition_range": rule.condition_range,
            "condition_range_min": rule.condition_range_min,
            "condition_range_max": rule.condition_range_max,
            "amount_select": rule.amount_select,
            "amount_fix": rule.amount_fix,
            "amount_python_compute": rule.amount_python_compute,
            "amount_percentage": rule.amount_percentage,
            "amount_percentage_base": rule.amount_percentage_base,
            "register_id": rule.register_id.id,
            "amount": amount,
            "employee_id": localdict["employee"].id,
            "quantity": qty,
            "rate": rate,
        }
        return localdict, lines_dict

    @api.model
    def _get_payslip_lines(self, contract_ids, payslip_id):
        lines_dict = {}
        blacklist = []
        payslip = self.env["hr.payslip"].browse(payslip_id)
        contracts = self.env["hr.contract"].browse(contract_ids)

        for contract in contracts:
            # baselocaldict for every contract
            baselocaldict = payslip._get_baselocaldict(contract)
            # assign "current_contract" dict
            baselocaldict["current_contract"] = BrowsableObject(
                payslip.employee_id.id,
                payslip.get_current_contract_dict(contract, contracts),
                self.env,
            )
            # set up localdict with current contract and employee values
            localdict = dict(
                baselocaldict, employee=contract.employee_id, contract=contract
            )
            for rule in self._get_salary_rules(contract):
                localdict["result"] = None
                localdict["result_qty"] = 1.0
                localdict["result_rate"] = 100
                localdict["result_name"] = None
                # check if the rule can be applied
                if rule._satisfy_condition(localdict) and rule.id not in blacklist:
                    localdict, lines_dict = payslip._compute_payslip_line(
                        rule, localdict, lines_dict
                    )
                else:
                    # blacklist this rule and its children
                    blacklist += [id for id, seq in rule._recursive_search_of_rules()]
            # call localdict_hook
            localdict = self.localdict_hook(localdict, payslip)
            # reset "current_contract" dict
            baselocaldict["current_contract"] = {}
        return lines_dict

    def localdict_hook(self, localdict, payslip):
        # This hook is called when the function _get_payslip_lines ends the loop
        # and before its returns. This method by itself don't add any functionality
        # and is intedend to be inherited to access localdict from other functions.
        return localdict

    # used in payslips_by_employees (batch payroll computation)
    def get_payslip_vals(
        self, date_from, date_to, employee_id=False  #, contract_ids=False, struct_id=False
    ):
        # Initial default values for generated payslips
        employee = self.env["hr.employee"].browse(employee_id)
        res = {
            "value": {
                "line_ids": [],
                "input_line_ids": [(2, x) for x in self.input_line_ids.ids],
                "worked_days_line_ids": [(2, x) for x in self.worked_days_line_ids.ids],
                "name": "",
            }
        }
        # If we don't have employee or date data, we return.
        if (not employee_id) or (not date_from) or (not date_to):
            return res
        # We check if contract_id is present, if not we fill with the
        # ------------ hernad: bug samo jedan contract se uzima !!!!!!!!!!!!!!!!!!!!!!!!!--------------------------
        # first contract of the employee. If not contract present, we return.
        #if not self.env.context.get("contract"):
        #    contract_ids = employee.contract_id.ids
        #else:
        #    if contract_id:
        #        contract_ids = [contract_id]
        #    else:

        contract_ids = employee._get_contracts(date_from=date_from, date_to=date_to).ids
        if not contract_ids:
            return res

        #contract = self.env["hr.contract"].browse(contract_ids[0])
        #res["value"].update({"contract_id": contract.id})
        # We check if struct_id is already filled, otherwise we assign the contract struct.
        # If contract don't have a struct, we return.
        #if struct_id:
        #    res["value"].update({"struct_id": struct_id[0]})
        #else:
        #    struct = contract.struct_id
        #    if not struct:
        #        return res
        #    res["value"].update({"struct_id": struct.id})
        # Computation of the salary input and worked_day_lines

        # ?hernad ovo se ne koristi
        #contracts = self.env["hr.contract"].browse(contract_ids)
        #worked_days_line_ids = self.get_worked_day_lines(contracts, date_from, date_to)
        #input_line_ids = self.get_rule_inputs(contracts, date_from, date_to)

        #res["value"].update(
        #    {
        #        #"contract_ids": contract_ids,
        #        "worked_days_line_ids": worked_days_line_ids,
        #        "input_line_ids": input_line_ids,
        #    }
        #)

        res = {
            "value": {
                "line_ids": [],
                "input_line_ids": [(2, x) for x in self.input_line_ids.ids],
                "worked_days_line_ids": [(2, x) for x in self.worked_days_line_ids.ids],
                "name": "",
            }
        }

        return res

    def _sum_salary_rule_category(self, localdict, category, amount):
        self.ensure_one()
        if category.parent_id:
            localdict = self._sum_salary_rule_category(
                localdict, category.parent_id, amount
            )
        localdict["categories"].dict[category.code] = (
            localdict["categories"].dict.get(category.code, 0) + amount
        )
        return localdict

    def _get_employee_contracts(self):
        return self.env["hr.contract"].browse(
            self.employee_id._get_contracts(
                date_from=self.date_from, date_to=self.date_to
            ).ids
        )

    #@api.onchange("struct_id")
    #def onchange_struct_id(self):
    #    if not self.struct_id:
    #        self.input_line_ids.unlink()
    #        return

    def change_input_lines(self):
        #input_lines = self.input_line_ids.browse([])
        #rule_input_line_ids = self.get_rule_inputs(
        #    self._get_employee_contracts(), self.date_from, self.date_to
        #)
        #for r in rule_input_line_ids:
        #    input_lines += input_lines.new(r)
        #self.input_line_ids = input_lines
        #? input_lines se unose direktno
        return

    @api.onchange("date_from", "date_to")
    def onchange_dates(self):
        if not self.date_from or not self.date_to:
            return
        #self.worked_days_line_ids[5].id = 103
        #self.worked_days_line_ids[5].timesheet_item_ids[0].worked_days_ids[0].id = 103
        worked_days_lines = self.worked_days_line_ids.browse([])
        worked_days_line_ids = self.get_worked_day_lines(
            self._get_employee_contracts(), self.date_from, self.date_to
        )
        # worked_days_line_ids is list
        # worked_days_lines is db object hr.payslip.worked_days
        for line in worked_days_line_ids:
            worked_days_lines += worked_days_lines.new(line)
        # self.worked_days_lines_ids je db object hr.payslip.worked_days
        self.worked_days_line_ids = worked_days_lines

        input_lines = self.input_line_ids.browse([])
        input_line_ids = self.get_inputs(self._get_employee_contracts(), self.date_from, self.date_to)
        input_line_ids = self.get_bol_preko_pos_puna_sat_inputs(input_line_ids, self._get_employee_contracts(), self.date_from, self.date_to)

        for line in input_line_ids:
            if 'amount' in line.keys():
                input_lines += input_lines.new(line)

        self.input_line_ids = input_lines

    def refetch_compute_selected_payslips(self):
        for payslip_id in self._context['active_ids']:
            payslip = self.env['hr.payslip'].browse(payslip_id)
            payslip.onchange_employee()
            payslip.compute_sheet()

    def refetch_selected_payslips(self):
        for payslip_id in self._context['active_ids']:
            payslip = self.env['hr.payslip'].browse(payslip_id)
            payslip.onchange_employee()

    @api.onchange("employee_id", "date_from", "date_to")
    def onchange_employee(self):

        #breakpoint()
        # Return if required values are not present.
        if (not self.employee_id) or (not self.date_from) or (not self.date_to):
            return
        # Assign contract_id automatically when the user don't selected one.
        if not self.env.context.get("contract") or not self.contract_id:
            contract_ids = self._get_employee_contracts().ids
            if not contract_ids:
                return

        # Compute payslip name
        self._compute_name()
        # Call worked_days_lines computation when employee is changed.
        self.onchange_dates()

        # Call input_lines computation when employee is changed.
        #self.onchange_struct_id()
        self.change_input_lines()

        # Assign company_id automatically based on employee selected.
        self.company_id = self.employee_id.company_id

    def _compute_name(self):
        for record in self:
            record.name = _("Salary Slip of %s for %s") % (
                record.employee_id.name,
                tools.ustr(
                    babel.dates.format_date(
                        date=datetime.combine(record.date_from, time.min),
                        format="MMMM-y",
                        locale=record.env.context.get("lang") or "en_US",
                    )
                ),
            )

    #@api.onchange("contract_id")
    #def onchange_contract(self):
    #    if not self.contract_id:
    #        self.struct_id = False
    #    self.with_context(contract=True).onchange_employee()
    #    return

    def get_salary_line_total(self, code):
        self.ensure_one()
        line = self.line_ids.filtered(lambda line: line.code == code)
        if line:
            return line[0].total
        else:
            return 0.0


