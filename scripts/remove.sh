#!/usr/bin/env bash

echo -- $1 ----

if [[ -z "$1" ]] ; then
   echo "nedostaje ime fajla" 
   exit 1
fi

if [ -f $1 ] || [ -d $1 ] ; then
   echo "--- removing $1 <<<<<<<<<<<<<<<<---"
#else
#   [ -f $1 ] || echo fajl $1 ne postoji
#   [ -d $1 ] || echo direktorij $1 ne postoji
fi

rm -rf $1
