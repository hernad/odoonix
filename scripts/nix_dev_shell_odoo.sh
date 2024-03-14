#!/usr/bin/env bash

export GEVENT_SUPPORT=True
export PYDEVD_DISABLE_FILE_VALIDATION=1
export PYTHONUNBUFFERED=1

export PYTHONPATH=
echo cleanup PYTHONPATH= baznog environmenta
echo " "

#echo - run ngnix server with:
#echo "nginx-start&"

# https://github.com/NixOS/nix/issues/6091

XDG_DATA_DIRS_SAVED=$XDG_DATA_DIRS

echo "NOTICE:"
echo "running nix develop ..."
echo "after entering into nix develop shell, type exit to continue"
echo "------------------------------------------------------------------------"
nix develop

#echo "idem u odoo16 i pokrecem vscode"
#
#nix shell .#nginx-start \
#          .#postgresql-start .#postgresql-stop \
#          .#odoo-python-311 \
#          .#my-wkhtmltopdf \
#          nixpkgs#pkgs.unzip nixpkgs#pkgs.zip \
#          nixpkgs#pkgs.bashInteractive --command sh -c "cd odoo16 && code ."

XDG_DATA_DIRS=$XDG_DATA_DIRS_SAVED

#. <(nix print-dev-env)
