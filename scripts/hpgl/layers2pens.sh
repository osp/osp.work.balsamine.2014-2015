#!/bin/bash

# A3 LANDSCAPE

#.-------------------------------------------------------------------------.#
#. svg2hpgl.sh                                                              #
#.                                                                          #
#. Copyright (C) 2014 LAFKON/Christoph Haag                                 #
#.                                                                          #
#. svg2hpgl.sh is free software: you can redistribute it and/or modify      #
#. it under the terms of the GNU General Public License as published by     #
#. the Free Software Foundation, either version 3 of the License, or        #
#. (at your option) any later version.                                      #
#.                                                                          #
#. svg2hpgl.sh is distributed in the hope that it will be useful,           #
#. but WITHOUT ANY WARRANTY; without even the implied warranty of           #
#. MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     #
#. See the GNU General Public License for more details.                     #
#.                                                                          #
#.-------------------------------------------------------------------------.#

  TMPDIR=tmp
  OUTDIR=o

  SVG=i/calibrate.svg
# SVG=i/elephant_traced_INKSCAPE-01_hatched-06.svg
# SVG=i/elephant_traced_INKSCAPE-01_hatched.svg
# SVG=i/graydient_hatched.svg
  SVG=i/elephant_traced_INKSCAPE-03_hatched-01.svg
 

  LAYERED=${SVG%%.*}_layered.svg
# --------------------------------------------------------------------------- #
# MODIFY SVG BODY FOR EASIER PARSING
# --------------------------------------------------------------------------- #

      sed 's/ / \n/g' $SVG | \
      sed '/^.$/d' | \
      sed 's/>/>\n/g'| \
      sed -n '/<\/metadata>/,/<\/svg>/p' | sed '1d;$d' | \
      sed ':a;N;$!ba;s/\n/ /g' | \
      sed 's/<\/g>/\n<\/g>/g' | \
      sed 's/\/>/\n\/>\n/g' | \
      sed 's/</4Fgt7RfjIoPg7/g' | \
      sed ':a;N;$!ba;s/\n/ /g' | \
      sed 's/4Fgt7RfjIoPg7/\n</g' | \
      sed 's/display:none/display:inline/g' > ${SVG%%.*}.tmp

  SVGHEADER=`cat $SVG | \
             sed ':a;N;$!ba;s/\n/ /g' | \
             sed 's/</\n</g' | \
             tac | \
             sed -n '/<\/metadata>/,$p' | \
             tac`

  echo $SVGHEADER           >  $LAYERED
  cat  ${SVG%%.*}.tmp | \
  sed '/inkscape:groupmode=\"layer\"/s/^/gD6cHzui91S/g' | \
  sed ':a;N;$!ba;s/\n/ /g' | \
  sed 's/gD6cHzui91S/\n/g'  >> $LAYERED
  echo "</svg>"             >> $LAYERED


# --------------------------------------------------------------------------- #
# MAKE HPGL FILE (ONE PEN PER LAYER)
# --------------------------------------------------------------------------- #

   PENSAVAILABLE=6
   SPEEDMIN=1
   SPEEDMAX=30

   HPGL=${SVG%%.*}.hpgl

   for STROKECOLOR in `cat $LAYERED | \
                       sed ':a;N;$!ba;s/\n/ /g' | \
                       sed 's/stroke/\nstroke/g' | \
                       grep "stroke:#" | \
                       cut -d "#" -f 2 | \
                       cut -d ";" -f 1 | cut -d "\"" -f 1 | \
                       sort | uniq`
    do
       RHEX=`echo $STROKECOLOR | cut -c 1-2 | tr '[:lower:]' '[:upper:]'`
       BRIGHTNESS=`echo "ibase=16;obase=A;$RHEX" | bc`
       ALLBRIGHTNESS=${BRIGHTNESS}-${ALLBRIGHTNESS}

   done

   BRIGHTMAX=`echo $ALLBRIGHTNESS | sed 's/-/\n/g' | sed '/^$/d' | head -n 1`
   BRIGHTMIN=`echo $ALLBRIGHTNESS | sed 's/-/\n/g' | sed '/^$/d' | tail -n 1`


   echo "IN;"                                       >  $HPGL

   # http://www.isoplotec.co.jp/HPGL/eHPGL.htm
   # IP p1x,p1y,p2x,p2y;
   echo "IP0,0,16158,11040;"                        >> $HPGL
   # http://www.isoplotec.co.jp/HPGL/eHPGL.htm
   # SC xmin,xmax,ymin,ymax;
   echo "SC1488,0,0,1052;"                          >> $HPGL

#  echo "SP1;"                                      >> $HPGL
#  echo "VS3;"                                      >> $HPGL


   PEN=1
 # -------------------------------------------------------------------------- #

   for LAYER in `grep "groupmode=\"layer\"" $LAYERED | sed "s/ /urh3DhrtWq8/g"`
    do
     
       LAYER=`echo $LAYER | sed "s/urh3DhrtWq8/ /g"`


     # DECIDE PEN AND SPEED BASED ON FIRST STROKE COLOR #

       HEXCOLOR=`echo $LAYER | sed 's/stroke/\nstroke/g' | \
                 grep "stroke:#" | head -1 | \
                 cut -d "#" -f 2 | cut -d ";" -f 1`

       RHEX=`echo $HEXCOLOR | cut -c 1-2 | tr '[:lower:]' '[:upper:]'`
       BRIGHTNESS=`echo "ibase=16;obase=A;$RHEX" | bc`

       echo "BRIGHTNESS = " $BRIGHTNESS

       # http://pzwart3.wdka.hro.nl/wiki/Mapping_a_value_in_BASH
       # map some value from inlo to inhi to a new range: outlow, outhi

      function map {
        I=$1
        INLO=$2
        INHI=$3
        OUTLO=$4
        OUTHI=$5
        P=$(( (I*100) / (INHI-INLO) ))
        O=$(( OUTLO + (P * (OUTHI-OUTLO) / 100) ))
        echo $O
      }
 
      PEN=`map $BRIGHTNESS $BRIGHTMIN $BRIGHTMAX 1 $PENSAVAILABLE`
      echo "PEN = " $PEN

      SPEED=`map $BRIGHTNESS $BRIGHTMIN $BRIGHTMAX $SPEEDMIN $SPEEDMAX`
      echo "SPEED = " $SPEED



      SVG4PROCESSING=$TMPDIR/`echo $LAYER | md5sum | cut -c 1-8`.svg

      echo ${SVGHEADER}${LAYER}"</svg>"            >  $SVG4PROCESSING 


      SRCSVG=$SVG4PROCESSING
      inkscape --export-pdf=${SRCSVG%%.*}.pdf $SVG4PROCESSING

    # FORTH-AND-BACK CONVERTING 
    # TO PREVENT GEOMERATIVE ERRORS

      pdf2ps ${SRCSVG%%.*}.pdf ${SRCSVG%%.*}.ps
      ps2pdf ${SRCSVG%%.*}.ps ${SRCSVG%%.*}.pdf
      pdf2svg ${SRCSVG%%.*}.pdf $SVG4PROCESSING

      rm ${SRCSVG%%.*}.ps ${SRCSVG%%.*}.pdf

    # REMOVE PATH CLOSURE = "Z M" (CAUSED PROBLEM WITH GEOMERATIVE)
      sed -i 's/Z M [^"]*"/"/g' $SVG4PROCESSING 

      echo ""                                      >> $HPGL
      echo "SP${PEN};"                             >> $HPGL
      echo "VS${SPEED};"                           >> $HPGL

      echo $SVG4PROCESSING > svg.i

     #SKETCHNAME=svg2hpgl_rnd
      SKETCHNAME=svg2hpgl

      APPDIR=$(dirname "$0")
      LIBDIR=$APPDIR/src/$SKETCHNAME/application.linux/lib
      SKETCH=$LIBDIR/$SKETCHNAME.jar

      CORE=$LIBDIR/core.jar
      GMRTV=$LIBDIR/geomerative.jar
      BTK=$LIBDIR/batikfont.jar

      LIBS=$SKETCH:$CORE:$GMRTV:$BTK

      java  -Djava.library.path="$APPDIR" \
            -cp "$LIBS" \
            $SKETCHNAME

      rm svg.i

# -------------------------------------------------------------------------- #
   # KEEP ORDER, REMOVE DUPLICATE LINES (?)
     #cat hpgl.hpgl | sed '$!N; /^\(.*\)\n\1$/!P; D' >> $HPGL

   # RANDOMIZE LINES (PREVENT FLOATING COLOR) 
     cat hpgl.hpgl | \
     sed 's/PU;/PU;\n/g' | \
     sed '/./{H;d;};x;s/\n/={NL}=/g' | \
     shuf | sed '1s/={NL}=//;s/={NL}=/\n/g' | \
     sed '$!N; /^\(.*\)\n\1$/!P; D'                  >> $HPGL

# -------------------------------------------------------------------------- #

#     PEN=`expr $PEN + 1`
#      if [ $PEN -gt $PENSAVAILABLE ]; then
#           PEN=1
#      fi

  done

## -------------------------------------------------------------------------- #


   echo "SP0;"   >> $HPGL
 # -------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
# CLEAN UP
# --------------------------------------------------------------------------- #

  rm hpgl.hpgl $LAYERED ${SVG%%.*}.tmp











exit 0;
