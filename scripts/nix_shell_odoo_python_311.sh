#!/usr/bin/env bash

export GEVENT_SUPPORT=True
export PYDEVD_DISABLE_FILE_VALIDATION=1
export PYTHONUNBUFFERED=1

export PYTHONPATH=
echo cleanup PYTHONPATH= baznog environmenta
echo " "

echo - run ngnix server with:
echo "nginx-start&"

nix shell .#nginx-start \
          .#postgresql-start \
          .#odoo-python-311 \
          .#my-wkhtmltopdf \
          nixpkgs#pkgs.unzip nixpkgs#pkgs.zip \
          nixpkgs#pkgs.bashInteractive

