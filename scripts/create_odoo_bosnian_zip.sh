#!/usr/bin/env bash

rm -rf odoo-16-bosnian

cp -av odoo16 odoo-16-bosnian
rm odoo-16-bosnian/python311
rm odoo-16-bosnian/odoo.conf

# third party addons
rm -rf odoo-16-bosnian/addons 
# odoo local data
rm -rf odoo-16-bosnian/odoo-data

rm odoo-16-bosnian.zip

zip -r odoo-16-bosnian.zip --exclude="./.git/*/*"  \
   --exclude="*/__pycache__/*" \
   --exclude="./__pycache__/*" \
   --exclude="*/*/__pycache__/*"  odoo-16-bosnian

