#!/usr/bin/env bash

LANGS="be ml ms no sw sr@latin en_AU af az gu hy is km lb lo ta ar tr pl ca es pt it fr de nl sv nb da ca lt es fi ro uk th zh id ki lv bg ja mk sl ru gl mn"
LANGS+=" vi et cs ko fa vi el eu he sk hu am en_GB fo hi ka kab ne sq te"

for lang in $LANGS; do find -type f -name "$lang*.po" -exec scripts/remove.sh \{\} \;; done
