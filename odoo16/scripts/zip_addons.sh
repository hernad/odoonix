#!/usr/bin/env bash

if [[ -n "$1" ]] ; then
	ADDONS=$1
else
   ADDONS=akretion bringout cybrosys OCA odoomates ventor
fi

echo "ADDONS:  $ADDONS"

cd 3p_addons


for ADDON in $ADDONS 
do

  ZIP_NAME=odoo_16_${ADDON}_`date +"%Y%m%d"`
  echo $ZIP_NAME

done

cd ..

ssh root@download.svc.bring.out.ba ls -lh /data/download
