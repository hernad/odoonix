{ stdenv, pkgs }:

stdenv.mkDerivation {
  name = "postgresql-start";
  
  src = ./postgresql;

  buildPhase = ''
  mkdir -p $out/bin
  #mkdir -p $out/conf
  echo "#!/usr/bin/env bash" > $out/bin/postgresql-start
  echo '[ -z $PGDATA ] && echo "PGDATA - envar lokacija postgresql podataka mora biti definisana" && exit 1' >> $out/bin/postgresql-start 
  echo "echo 'step-1: initdb (ako ne postoji PGDATA direktorij)'" >> $out/bin/postgresql-start
  echo '[ ! -d $PGDATA ] && ${pkgs.postgresql}/bin/pg_ctl -o "-U postgres -k $PGDATA" initdb  && cat $(dirname $(which postgresql-start))/../conf/postgresql.conf >> $PGDATA/postgresql.conf' >> $out/bin/postgresql-start
  echo "echo 'step-2: start'" >> $out/bin/postgresql-start 
  echo '${pkgs.postgresql}/bin/pg_ctl -o "-p 15432 -k $PGDATA" start' >>  $out/bin/postgresql-start
  chmod +x $out/bin/postgresql-start
  '';

  installPhase = ''
  mkdir -p $out/conf
  cp postgresql.conf $out/conf
  '';
  
}