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
        'data/country_enforce_cities.xml',
        'data/res.country.state.csv',
        'data/res.city.csv',
        'views/enforce_cities.xml',
    ],
    "active": False,
    'license': 'GPL-3',
}
