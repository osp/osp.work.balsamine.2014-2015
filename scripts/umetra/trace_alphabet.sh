#!/bin/bash

# FONTFAMILY="Ume P Gothic"
  FONTFAMILY="Ume P Mincho"

  TRACEWIDTH=400 
  WEIGHT=80

  BLANKFONT=i/utils/blank.sfd
  OUTPUTDIR=o



 for WEIGHT in 2 5 10 15 20 30 40 50 60
#for WEIGHT in 2 60
  do

  WNAME=`echo 00$WEIGHT | rev | cut -c 1-2 | rev`
  NAME=Umetra-${WNAME}P_`echo $FONTFAMILY | rev | cut -d " " -f 1 | rev`

# --------------------------------------------------------------------------- # 
  TMPDIR=tmp
  SHIFT=`expr 35 + $WEIGHT / 4`
  e() { echo $1 >> ${DUMP}; }
 
 
  for LETTER in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
                a b c d e f g h i j k l m n o p q r s t u v w x y z
# for LETTER in A g W M
   do
 
      DUMP=$TMPDIR/${LETTER}.svg
 
      e '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'
      e '<svg width="200" height="300" id="svg" version="1.1"'
      e 'xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"'
      e '>'
      e '<g inkscape:label="letter" inkscape:groupmode="layer" id="X">'
      e '<flowRoot xml:space="preserve" id="flowRoot"'
 
      e "style=\"font-size:200px;\
                 font-style:normal;\
                 font-variant:normal;\
                 font-weight:normal;\
                 font-stretch:normal;\
                 text-align:center;\
                 line-height:125%;\
                 letter-spacing:0px;\
                 word-spacing:0px;\
                 writing-mode:lr-tb;\
                 text-anchor:middle;\
                 fill:#000000;\
                 fill-opacity:1;\
                 stroke:none;\
                 font-family:$FONTFAMILY;\
                -inkscape-font-specification:$FONTFAMILY\""
      e '><flowRegion id="flowRegion">'
      e "<rect id=\"rect\" width=\"200\" height=\"300\" x=\"0\" y=\"-$SHIFT\" />"
      e "</flowRegion><flowPara id=\"flowPara\">$LETTER</flowPara></flowRoot>"
      e '</g>'
      e '</svg>'
 
      inkscape --export-png=${DUMP%%.*}.png \
               --export-background=#ffffff \
               --export-width=$TRACEWIDTH \
              $DUMP

      autotrace -centerline \
                -color-count=2 \
                -background-color=ffffff \
                -output-file=$DUMP \
                ${DUMP%%.*}.png

      STYLE="style=\"stroke:#000000;fill:none;stroke-width:$WEIGHT;stroke-linecap:square\""

      sed -i "s/style=\"[^\"]*\"/$STYLE/g" $DUMP

      inkscape --verb EditSelectAllInAllLayers \
               --verb StrokeToPath  \
               --verb FileSave \
               --verb FileClose \
               $DUMP

      rm ${DUMP%%.*}.png

    done

   #HUNAME=`echo $NAME | sed 's/_/ /g'`
    HUNAME=$NAME
    FAMILY=$NAME

    cp $BLANKFONT ${BLANKFONT%%.*}_backup.sfd 
    sed -i "s/XXXX/$NAME/g" $BLANKFONT  
    sed -i "s/YYYY/$HUNAME/g" $BLANKFONT
    sed -i "s/ZZZZ/$FAMILY/g" $BLANKFONT

       ./svg2ttf-0.2.py

    mv ${BLANKFONT%%.*}_backup.sfd $BLANKFONT 
    mv output.ttf ${OUTPUTDIR}/${NAME}.ttf


    rm $TMPDIR/*.*

 done


exit 0;



