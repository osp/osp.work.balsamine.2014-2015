#!/bin/bash


  OUTPUTDIR=o

  EGGBOTHATCHPY=~/.config/inkscape/extensions/eggbot_hatch.py
  INKSCAPEEXTENSION=/usr/share/inkscape/extensions
  export PYTHONPATH=$INKSCAPEEXTENSION

  SVG=$1
  if [[ -z "$1" ]]; then echo "please provide svg = $0 in.svg"; exit 0 ; fi


      DISTMIN=5
      DISTMAX=15
      ANGLEMIN=60
      ANGLEMAX=120



  LAYERED=${SVG%%.*}_layered.svg
  HATCHED=${SVG%%.*}_hatched.svg

# --------------------------------------------------------------------------- #
# CONVERT TO GRAYSCALE AND MODIFY SVG BODY FOR EASIER PARSING
# --------------------------------------------------------------------------- #

      python $INKSCAPEEXTENSION/color_grayscale.py $SVG | \
      sed 's/ / \n/g' | \
      sed '/^.$/d' | \
      sed ':a;N;$!ba;s/\n/ /g' | \
      sed 's/>/>\n/g'| \
      sed -n '/<\/metadata>/,/<\/svg>/p' | sed '1d;$d' | \
      sed ':a;N;$!ba;s/\n/ /g' | \
      sed 's/<\/g>/\n<\/g>/g' | \
      grep -v "XX_" | \
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

# --------------------------------------------------------------------------- #
# DISTRIBUTE DIFFERENT FILLS TO LAYERS (ONE LAYER PER LINE)
# --------------------------------------------------------------------------- #

  GROUPSTART="<g inkscape:label=\"NAME\" inkscape:groupmode=\"layer\" id=\"ID\">"
  GROUPCLOSE="</g>"
  COLORELEMENT="fill:#"

# --------------------------------------------------------------------------- #
  echo $SVGHEADER                                            >  $LAYERED

  for COLOR in `cat ${SVG%%.*}.tmp | \
                sed "s/$COLORELEMENT/\n$COLORELEMENT/g" | \
                sed 's/;/;\n/g' | \
                sed 's/"/"\n/g' | \
                grep "$COLORELEMENT" | \
                cut -d ":" -f 2 | \
                sort | uniq`
   do

       COLOR=`echo $COLOR | \
              cut -d "#" -f 2 | \
              cut -d ";" -f 1 | \
              cut -d "\"" -f 1`

       NAME="fill-"$COLOR

       ID=$NAME
     # ----------------------------------------------------------------- #

       LAYER=`echo $GROUPSTART | \
              sed "s/NAME/$NAME/g" | \
              sed "s/ID/$ID/g"`

       LAYER=$LAYER`grep -i ${COLORELEMENT}${COLOR} ${SVG%%.*}.tmp`
       LAYER=$LAYER$GROUPCLOSE

       echo $LAYER                                           >> $LAYERED

  done

  echo "</svg>"                                              >> $LAYERED
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
# HATCH FILL PER LAYER (= WERE FILLS)
# --------------------------------------------------------------------------- #

  echo $SVGHEADER                                               >  $HATCHED

  NAME="hatched"; ID=$NAME

  for ID in `cat $LAYERED | \
             sed 's/inkscape:groupmode="layer"/\n&/g' | \
             sed 's/>/>\n/g' | \
             grep "inkscape:groupmode=\"layer\"" | \
             sed 's/id=/\nid=/g' | \
             grep id= | cut -d "\"" -f 2`  
   do

      HEXCOLOR=`echo $ID | cut -d "-" -f 2`
      RHEX=`echo $HEXCOLOR | cut -c 1-2 | tr '[:lower:]' '[:upper:]'`
      BRIGHTNESS=`echo "ibase=16;obase=A;$RHEX" | bc`

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

      ANGLE=`map $BRIGHTNESS 0 255 $ANGLEMIN $ANGLEMAX`
      DISTANCE=`map $BRIGHTNESS 0 255 $DISTMIN $DISTMAX`

      STROKECOLOR=$HEXCOLOR

      NAME=$ID

      echo $GROUPSTART | \
      sed "s/NAME/$NAME/g" | \
      sed "s/ID/$ID/g"                                          >> $HATCHED

      echo $SVGHEADER              > tmp.svg
      grep "id=\"$ID\"" $LAYERED   >> tmp.svg
      echo "</svg>"                >> tmp.svg

     # Options:
     #   -h, --help            show this help message and exit
     #   --id=IDS              id attribute of object to manipulate
     #   --crossHatch=CROSSHATCH
     #                         Generate a cross hatch pattern
     #   --hatchAngle=HATCHANGLE
     #                         Angle of inclination for hatch lines
     #   --hatchSpacing=HATCHSPACING
     #                         Spacing between hatch lines
 
     python $EGGBOTHATCHPY \
            --id=$ID \
            --hatchAngle=$ANGLE \
            --hatchSpacing=$DISTANCE \
            tmp.svg | \
            sed 's/</\n</g' | \
            grep "<path" | \
            grep -v "fill:#$HEXCOLOR" | \
            sed "s/stroke:#[^;]*;/stroke:#$STROKECOLOR;/g" | \
            sed "s/stroke:#[^\"]*\"/stroke:#$STROKECOLOR\"/g"  >> $HATCHED

       echo $GROUPCLOSE                                        >> $HATCHED

  done

# --------------------------------------------------------------------------- #
# ADD THE STROKES
# --------------------------------------------------------------------------- #

  COLORELEMENT="stroke:#"

  for COLOR in `cat ${SVG%%.*}.tmp | \
                sed "s/$COLORELEMENT/\n$COLORELEMENT/g" | \
                sed 's/;/;\n/g' | \
                sed 's/"/"\n/g' | \
                grep $COLORELEMENT | \
                cut -d ":" -f 2 | \
                sort | uniq`
   do

       COLOR=`echo $COLOR | \
              cut -d "#" -f 2 | \
              cut -d ";" -f 1 | \
              cut -d "\"" -f 1`

       NAME="stroke-"$COLOR

       ID=$NAME
     # ----------------------------------------------------------------- #

       LAYER=`echo $GROUPSTART | \
              sed "s/NAME/$NAME/g" | \
              sed "s/ID/$ID/g"`

       LAYER=$LAYER`grep -i ${COLORELEMENT}${COLOR} ${SVG%%.*}.tmp`
       LAYER=$LAYER$GROUPCLOSE

       echo $LAYER                                              >> $HATCHED

  done

  echo "</svg>"                                                 >> $HATCHED

  KEEP=$OUTPUTDIR/`basename $HATCHED | cut -d "." -f 1`_`date +%s`
  cp $HATCHED ${KEEP}.svg

  echo "DISTMIN: "  $DISTMIN  >  ${KEEP}.log
  echo "DISTMAX: "  $DISTMAX  >> ${KEEP}.log
  echo "ANGLEMIN: " $ANGLEMIN >> ${KEEP}.log
  echo "ANGLEMAX: " $ANGLEMAX >> ${KEEP}.log

# --------------------------------------------------------------------------- #
# CLEAN UP
# --------------------------------------------------------------------------- #
  rm tmp.svg ${SVG%%.*}.tmp $LAYERED


exit 0;
