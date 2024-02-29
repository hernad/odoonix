#!/usr/bin/env bash

ODOO16=odoo16
ODOO16_ZIP=odoo-16-hernad

URL=https://download.cloud.out.ba/${ODOO16_ZIP}.zip

curl -LO $URL

DIR_ZIP=$ODOO16_ZIP
[ -d "$DIR_ZIP" ] && echo rm "$DIR_ZIP" && rm -rf $DIR_ZIP

DIR=$ODOO16
[ -d "$DIR" ] && echo "rm $DIR" & rm -rf $DIR


unzip ${ODOO16_ZIP}.zip

echo "mv $ODOO16_ZIP => $ODOO16"
mv $ODOO16_ZIP $ODOO16

echo "get from git $ODOO16"
git checkout -- $ODOO16

scripts/remove_unused_prevodi.sh

ls $ODOO16/odoo/addons/base/i18n/

ls -l $ODOO16

cd $ODOO16
cp -vs ../odoo.conf .
cp -vs ../python311 .


scripts/set_bs_addons_odoo-data.sh
