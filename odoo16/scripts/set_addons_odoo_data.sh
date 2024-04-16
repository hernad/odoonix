#!/usr/bin/env bash

ADDONS=odoo-data/addons/16.0

[ -d $ADDONS ] || mkdir -p $ADDONS

sudo chmod -R +w odoo-data

for dir in akretion bringout cybrosys OCA bringout_p odoomates ventor
do 
   ln -sf `pwd`/3p_addons/${dir}/* $ADDONS/
done

echo " "
echo ====================== installed addons ===========================
rm ./$ADDONS/'*'
ls -1 ./$ADDONS