#!/usr/bin/env bash

ZIP_NAME=odoo-16-bosnian-`date +"%Y%m%d"`

echo $ZIP_NAME

zip -r ${ZIP_NAME}.zip --exclude="./.git/*/*" --exclude="./3p_addons/*/*" \
       --exclude="./odoo-data/*/*" --exclude="./scripts/*/*"  *

rsync -avz ${ZIP_NAME}.zip root@download.svc.bring.out.ba:/data/download/

ssh root@download.svc.bring.out.ba ls -lh /data/download