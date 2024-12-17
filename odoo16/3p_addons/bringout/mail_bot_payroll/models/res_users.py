# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

from odoo import models, fields, _

class Users(models.Model):
    _inherit = 'res.users'

    odoobot_state = fields.Selection(
        selection_add=[
            ("xlsx", "XLSX"), 
            ("xlsx_rpt1", "isplate"),
            ("xlsx_rpt2", "bruto_detasirani"),
            ("xlsx_rpt3", "bruto"),
            ("xlsx_rpt4", "ugovori"),
            ("xlsx_rpt5", "cekanje"),
            ("xlsx_rpt6", "stimulacije"),
            ("xlsx_svi", "svi izvjestaji"),
            ("period", "datumski period"),
        ]
    )

