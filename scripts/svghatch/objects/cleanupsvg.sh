#!/bin/bash

# REMOVE SODIPODI IMAGE LINKS

 for SVG in `find . -name  "*.svg"`
  do
     echo $SVG
     sed -i 's/sodipodi:absref=".*"//g' $SVG
     sed -i 's/inkscape:export-filename=".*"//g' $SVG
     inkscape --vacuum-defs $SVG
 done

exit 0;

