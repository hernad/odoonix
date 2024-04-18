# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

# Author: Ernad Husremovic
# mail:   hernad@bring.out.ba
{
    "name": "Bosnia and Herzegovina",
    "description": """
Bosnian localisation.
======================

Author: Ernad Husremovic bring.out doo Sarajevo

Description:

Bosnian cities


""",
    "version": "16.0.0",
    "author": "bring.out",
    'category': 'Localization',
    "website": "https://github.com/hernad/odoo",
    'depends': [
        "base_address_extended"
    ],
    'data': [
        "data/account_chart_template_data.xml",
        "data/account.account.template.csv",
        "data/l10n_bs_fbih_chart_data.xml",
        "data/account.group.template.csv",
        "data/account_tax_template_data.xml",
        'data/account_tax_report_data.xml',
        'data/country_enforce_cities.xml',
        'data/res.country.state.csv',
        'data/res.city.csv',
        'views/enforce_cities.xml',
        "data/account_chart_template_configure_data.xml",
        "data/menuitem_data.xml",
    ],
    "active": False,
    'license': 'GPL-3',
}
