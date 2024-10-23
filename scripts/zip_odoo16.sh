#!/usr/bin/env bash

ZIP_NAME=odoo-16-bosnian-`date +"%Y%m%d"`

if [[ "$1" == "" ]]; then
   echo "usage:"
   echo "      zip only: $0 --zip"
   echo "zip and upload: $0 --upload"
   echo "   upload only: $0 --upload-only"
   exit 0
fi

if [[ "$1" != "--upload-only" ]] ; then
rm odoo-16-bosnian/python311
rm odoo-16-bosnian/odoo.conf

# third party addons
rm -rf odoo-16-bosnian/addons 
# odoo local data
rm -rf odoo-16-bosnian/odoo-data

rm $ZIP_NAME.zip

zip -r $ZIP_NAME.zip --exclude="./.git/*/*"  \
   --exclude="./scripts/*/*" \
   --exclude="*/*.zip"  \
   --exclude="*/__pycache__/*" \
   --exclude="./__pycache__/*" \
   --exclude="*/*/__pycache__/*" \
   --exclude="./*/odoo-data/*/*" \
   --exclude="./*/3p_addons/*/*" \
   --exclude="./*/python311" \
   --exclude="./*/odoo.conf" \
    odoo16
fi

if [[ "$1" =~ "--upload" ]] ; then

  rsync -avz ${ZIP_NAME}.zip root@download.svc.bring.out.ba:/data/download/
  ssh root@download.svc.bring.out.ba ls -lh /data/download

fi
