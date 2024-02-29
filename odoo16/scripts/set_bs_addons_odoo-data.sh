#!/usr/bin/env bash

ADDONS=odoo-data/addons/16.0

[ -d $ADDONS ] || mkdir -p $ADDONS

sudo chmod -R +w odoo-data

ln -sf `pwd`/bs_addons/* $ADDONS/
ln -sf `pwd`/odoo_payroll_oca/payroll $ADDONS/

ls -ld ./$ADDONS/*