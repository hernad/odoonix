# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

# Author: Ernad Husremovic
# mail:   hernad@bring.out.ba
{
    "name": "Odoo materijalno",
    "description": """
odoo materijalno
""",
    "version": "16.0.0",
    "author": "bring.out",
    'category': 'Localization',
    "website": "https://github.com/hernad/odoo",
    'depends': [
        "l10n_bs",
        "account",
        "product",
        "om_account_accountant",
        ##"l10n_generic_coa",
        "analytic",
        "mrp",
        "mrp_account",
        "mrp_landed_costs",

        ##"mrp_subcontracting",
        ##"mrp_subcontracting_account",
        ##"mrp_subcontracting_purchase",
        ##"mrp_subonctracting_landed_costs",
        "stock",
        "barcodes",
        "barcodes_gs1_nomenclature",
        "stock_account",
        "stock_landed_costs",
        
        ##"stock_picking_batch",
        "purchase",
        
        "purchase_mrp",
        "sale",
        
        "sale_mrp",
        
        #"sale_project",
        #"sale_project_stock",
        "uom",
        
        "product_print_zpl_barcode",
        "product_multiple_barcodes",
        
        ##"project",
        ##"project_mrp",
        ##"project_purchase",
        ##"project_sale_expense",
        ##"maintenance"
    ],
    'data': [
    ],
    "active": False,
    'license': 'LGPL-3',
}
