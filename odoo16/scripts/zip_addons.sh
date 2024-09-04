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

  zip -r ../${ZIP_NAME}.zip --exclude="./.git/*/*" --exclude="./3p_addons/*/*" \
       --exclude="./odoo-data/*/*" --exclude="./*.zip"  --exclude="./scripts/*/*"  $ADDON/*


done

cd ..

ls -l $ZIP_NAME.zip
echo "pokreni komandu:"
echo "rsync -avz ${ZIP_NAME}.zip root@download.svc.bring.out.ba:/data/download/"

#ssh root@download.svc.bring.out.ba ls -lh /data/download
