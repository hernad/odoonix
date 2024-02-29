{ stdenv, pkgs }:

stdenv.mkDerivation {
  name = "postgresql-stop";
  
  src = ./postgresql;

  buildPhase = ''
  mkdir -p $out/bin
  #mkdir -p $out/conf
  echo "#!/usr/bin/env bash" > $out/bin/postgresql-stop
  echo '[ -z $PGDATA ] && echo "PGDATA - envar lokacija postgresql podataka mora biti definisana" && exit 1' >> $out/bin/postgresql-stop
  echo '${pkgs.postgresql}/bin/pg_ctl -o "-p 15432 -k $PGDATA" stop' >>  $out/bin/postgresql-stop
  chmod +x $out/bin/postgresql-stop
  '';

  installPhase = ''
  '';
  
}