# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

{
    'name': 'OdooBotPayroll',
    'version': '1.0.1',
    'category': 'Productivity/Discuss',
    'summary': 'Payroll reporti',
    'website': 'https://www.bring.out.ba',
    'depends': ['mail'],
    'auto_install': True,
    'installable': True,
    #'data': [
    #    'views/res_users_views.xml',
    #    'data/mailbot_data.xml',
    #],
    #'demo': [
    #    'data/mailbot_demo.xml',
    #],
    #'assets': {
    #    'web.assets_backend': [
    #        'mail_bot/static/src/scss/odoobot_style.scss',
    #    ],
    #},
    "external_dependencies": {
        'python': [ 'pandas', 'openpyxl', 'numpy']
     },
    'license': 'LGPL-3',
}
