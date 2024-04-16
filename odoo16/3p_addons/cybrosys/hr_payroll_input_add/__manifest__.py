# -*- coding: utf-8 -*-
###################################################################################
#    A part of OpenHRMS Project <https://www.openhrms.com>
#
#    Cybrosys Technologies Pvt. Ltd.
#    Copyright (C) 2022-TODAY Cybrosys Technologies (<https://www.cybrosys.com>).
#
#    This program is free software: you can modify
#    it under the terms of the GNU Affero General Public License (AGPL) as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
###################################################################################
{
    'name': 'Payroll input add STIMUL',
    'version': '16.0.1.0.0',
    'summary': 'Manage Payroll ADD Requests',
    'description': """
        Helps you to manage add salary requests.
        """,
    'category': 'Generic Modules/Human Resources',
    'author': "bring.out doo Sarajevo",
    'company': 'bring.out doo Sarajevo',
    'maintainer': 'bring.out doo Sarajevo',
    'depends': [
        'base', 'hr', 'payroll',
    ],
    'data': [
        'security/ir.model.access.csv',
        'security/security.xml',
        'views/hr_payroll_input_add_seq.xml',
        'data/salary_rule_payroll_add.xml',
        'views/hr_payroll_input_add.xml',
        'views/hr_payroll.xml',
    ],
    'images': ['static/description/banner.png'],
    'license': 'AGPL-3',
    'installable': True,
    'auto_install': False,
    'application': False,
}
