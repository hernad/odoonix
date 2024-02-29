from odoo import fields, models

class HrPayslipRun(models.Model):
    _inherit = "hr.payslip.run"
  
    date_isplata = fields.Date(
        string="Datum isplate",
        required=False,
    )
