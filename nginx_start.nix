{ stdenv, pkgs }:

stdenv.mkDerivation {
  name = "nginx-start";
  
  src = ./nginx;

  buildPhase = ''
  mkdir -p $out/bin
  echo "#!/usr/bin/env bash" > $out/bin/nginx-start
  echo "${pkgs.nginx}/bin/nginx -c $out/conf/nginx.conf" >>  $out/bin/nginx-start
  chmod +x $out/bin/nginx-start
  '';

  installPhase = ''
  mkdir -p $out/conf
  cp nginx.conf $out/conf/
  cp fastcgi.conf $out/conf/
  cp mime.types $out/conf/
  cp proxy.conf $out/conf/
  cp uwsgi_params.conf $out/conf/
  cp nginx-recommended-proxy-headers.conf $out/conf/
  '';
  
}