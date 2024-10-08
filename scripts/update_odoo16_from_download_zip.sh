#!/usr/bin/env bash

ODOO16=odoo16
ODOO16_ZIP=odoo-16-bosnian-20240613

URL=https://download.cloud.out.ba/${ODOO16_ZIP}.zip

if [ ! -f "${ODOO16_ZIP}.zip" ]; then
   curl -LO $URL
else
   echo "postoji ${ODOO16_ZIP}.zip"
fi

DIR_ZIP=$ODOO16_ZIP
[ -d "$DIR_ZIP" ] && echo rm "$DIR_ZIP" && rm -rf $DIR_ZIP

rm -rf tmp-odoo-data/*
mkdir -p tmp-odoo-data
cp -av $ODOO16/odoo-data tmp-odoo-data/

DIR=$ODOO16
[ -d "$DIR" ] && echo "rm $DIR" & rm -rf $DIR



unzip ${ODOO16_ZIP}.zip

echo "mv $ODOO16_ZIP => $ODOO16"
mv $ODOO16_ZIP $ODOO16

echo "get from git $ODOO16"
git checkout -- $ODOO16

scripts/remove_unused_prevodi.sh

echo vrati postojeci $ODOO16/odoo-data
cp -av tmp-odoo-data/odoo-data $ODOO16/

ls $ODOO16/odoo/addons/base/i18n/

ls -l $ODOO16

cd $ODOO16
cp -vs ../odoo.conf .
cp -vs ../python311 .


scripts/set_addons_odoo_data.sh
