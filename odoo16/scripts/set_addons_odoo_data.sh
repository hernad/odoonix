#!/usr/bin/env bash

ADDONS=odoo-data/addons/16.0

[ -d $ADDONS ] || mkdir -p $ADDONS

sudo chmod -R +w odoo-data

for dir in akretion bringout cybrosys OCA bringout_p
do 
   ln -sf `pwd`/$dir/* $ADDONS/
done

echo " "
echo ====================== installed addons ===========================
ls -1 ./$ADDONS