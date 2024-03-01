# odoonix

## flake

### Packages
* nginx-start
* postgresql-start
* postgresql-stop
* odoo-python-311
* odoo16-start
* odoo17-start
* my-wkhtmltopdf

## scripts

### nix develop

Nix develop pravi sve nix packages

## scripts/nix_shell_odoo.sh

Ubacuje u shell sve komande potrebne za razvoj

    .#nginx-start
    .#postgresql-start 
    .#postgresql-stop
    .#odoo-python-311
    .#my-wkhtmltopdf


## Postgresql

    psql -h 127.0.0.1 -p 15432 postgres


    CREATE ROLE odoo WITH LOGIN PASSWORD 'odoo' CREATEDB;

