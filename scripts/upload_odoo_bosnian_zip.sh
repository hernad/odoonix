#!/usr/bin/env bash

ODOO=odoo-16-bosnian

ssh root@download.svc.bring.out.ba mv /data/download/$ODOO.zip /data/download/$ODOO-old.zip 

scp $ODOO.zip root@download.svc.bring.out.ba:/data/download/

ssh root@download.svc.bring.out.ba ls -lh /data/download/

