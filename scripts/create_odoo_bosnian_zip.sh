#!/usr/bin/env bash

rm -rf odoo-16-bosnian

cp -av odoo16 odoo-16-bosnian
rm odoo-16-bosnian/python311
rm odoo-16-bosnian/odoo.conf

zip -r odoo-16-bosnian.zip --exclude="./.git/*/*"  \
   --exclude="*/__pycache__/*" \
   --exclude="./__pycache__/*" \
   --exclude="*/*/__pycache__/*"  odoo-16-bosnian

