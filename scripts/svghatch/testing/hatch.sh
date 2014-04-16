#!/bin/bash

  EGGBOTHATCHPY=~/.config/inkscape/extensions/eggbot_hatch.py
  INKSCAPEEXTENSION=/usr/share/inkscape/extensions
  export PYTHONPATH=$INKSCAPEEXTENSION

  SVG=$1
  if [[ -z "$1" ]]; then echo "please provide svg = $0 in.svg"; exit 0 ; fi


  LAYERED=${SVG%%.*}_layered.svg
  HATCHED=${SVG%%.*}_hatched.svg

# --------------------------------------------------------------------------- #
# CONVERT TO GRAYSCALE AND MODIFY SVG BODY FOR EASIER PARSING
# --------------------------------------------------------------------------- #

      python /usr/share/inkscape/extensions/color_grayscale.py $SVG | \
      sed 's/ / \n/g' | \
      sed '/^.$/d' | \
      sed ':a;N;$!ba;s/\n/ /g' | \
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

# --------------------------------------------------------------------------- #
# DISTRIBUTE DIFFERENT FILLS TO LAYERS (ONE LAYER PER LINE)
# --------------------------------------------------------------------------- #

  GROUPSTART="<g inkscape:label=\"NAME\" inkscape:groupmode=\"layer\" id=\"ID\">"
  GROUPCLOSE="</g>"
  COLORELEMENT="fill:"

# --------------------------------------------------------------------------- #
  echo $SVGHEADER                                            >  $LAYERED

  for COLOR in `cat ${SVG%%.*}.tmp | \
                sed "s/$COLORELEMENT/\n$COLORELEMENT/g" | \
                sed 's/;/;\n/g' | \
                sed 's/"/"\n/g' | \
                grep $COLORELEMENT | \
                cut -d ":" -f 2 | \
                sort | uniq`
   do
       NAME="fill-"`echo $COLOR | \
             cut -d "#" -f 2 | \
             cut -d ";" -f 1 | \
             cut -d "\"" -f 1`

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

  echo $SVGHEADER                                            >  $HATCHED

  NAME="hatched"; ID=$NAME

  echo $GROUPSTART | \
  sed "s/NAME/$NAME/g" | \
  sed "s/ID/$ID/g"                                           >> $HATCHED

  for ID in `cat $LAYERED | \
             sed 's/inkscape:groupmode="layer"/\n&/g' | \
             sed 's/>/>\n/g' | \
             grep "inkscape:groupmode=\"layer\"" | \
             sed 's/id=/\nid=/g' | \
             grep id= | cut -d "\"" -f 2`  
   do

    # echo $ID

      HEXCOLOR=`echo $ID | cut -d "-" -f 2`
      RHEX=`echo $HEXCOLOR | cut -c 1-2 | tr '[:lower:]' '[:upper:]'`
      BRIGHTNESS=`echo "ibase=16;obase=A;$RHEX" | bc`

      DISTANCE=`expr $BRIGHTNESS / 15 + 2`
      ANGLE=-$BRIGHTNESS
    # ANGLE=90

      echo $SVGHEADER              > tmp.svg
      echo $GROUPSTART | \
      sed "s/NAME/$NAME/g" | \
      sed "s/ID/$ID/g"             >> tmp.svg
      grep "id=\"$ID\"" $LAYERED   >> tmp.svg
      echo $GROUPCLOSE             >> tmp.svg
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
             grep -v "fill:#$HEXCOLOR"                       >> $HATCHED

  done

  echo $GROUPCLOSE                                           >> $HATCHED
  echo "</svg>"                                              >> $HATCHED


# --------------------------------------------------------------------------- #
# CLEAN UP
# --------------------------------------------------------------------------- #
  rm tmp.svg $LAYERED ${SVG%%.*}.tmp



exit 0;
