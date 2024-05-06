#!/usr/bin/env bash

cd 3p_addons

for ADDON in akretion bringout cybrosys OCA odoomates ventor
do

  ZIP_NAME=odoo_16_${ADDON}_`date +"%Y%m%d"`
  echo $ZIP_NAME

  
  zip -r ../${ZIP_NAME}.zip --exclude="./.git/*/*" --exclude="./3p_addons/*/*" \
       --exclude="./odoo-data/*/*" --exclude="./*.zip"  --exclude="./scripts/*/*"  $ADDON/*

  rsync -avz ../${ZIP_NAME}.zip root@download.svc.bring.out.ba:/data/download/
done

cd ..

ssh root@download.svc.bring.out.ba ls -lh /data/download