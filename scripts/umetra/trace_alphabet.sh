#!/bin/bash

# FONTFAMILY="Ume P Gothic"
  FONTFAMILY="Ume P Mincho"

  TRACEWIDTH=400 
  WEIGHT=80

  BLANKFONT=i/utils/blank.sfd
  OUTPUTDIR=o



#for WEIGHT in 2 5 10 15 20 30 40 50 60
 for WEIGHT in 60
  do

  WNAME=`echo 00$WEIGHT | rev | cut -c 1-2 | rev`
  NAME=Umetra-${WNAME}P_`echo $FONTFAMILY | rev | cut -d " " -f 1 | rev`

# --------------------------------------------------------------------------- # 
  TMPDIR=tmp
  SHIFT=`expr 35 + $WEIGHT / 4`
  e() { echo $1 >> ${DUMP}; }
 
 
  for CHARACTER in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z À Á Â Ã Ä Å Æ Œ Ç È É Ê Ë Ì Í Î Ï Ñ Ò Ó Ô Õ Ö Ù Ú Û Ü Ý 0 1 2 3 4 5 6 7 8 9 « » \
                   a b c d e f g h i j k l m n o p q r s t u v w x y z à á â ã ä å æ œ ç è é ê ë ì í î ï ñ ò ó ô õ ö ù ú û ü ý ÿ
#  for CHARACTER in À Á Â Ã Ä Å Æ Œ Ç È É Ê Ë Ì Í Î Ï Ñ Ò Ó Ô Õ Ö Ù Ú Û Ü Ý 0 1 2 3 4 5 6 7 8 9 « » \
#                   à á â ã ä å æ œ ç è é ê ë ì í î ï ñ ò ó ô õ ö ù ú û ü ý ÿ
# for CHARACTER in A g W M
   do
      INFO=`echo $CHARACTER | \
            recode utf-8..dump-with-names | \
            tail -2 | \
            head -1`

      UNICODE=`echo $INFO | cut -d " " -f 1`
      DESCRIPTION=`echo $INFO | cut -d " " -f 3-`

      echo $UNICODE
      echo $DESCRIPTION

    # DUMP=$TMPDIR/${CHARACTER}.svg
      DUMP=$TMPDIR/${UNICODE}.svg

 
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
      e "</flowRegion><flowPara id=\"flowPara\">$CHARACTER</flowPara></flowRoot>"
      e '</g>'
      e '</svg>'
 
      inkscape --export-png=${DUMP%%.*}.png \
               --export-background=#ffffff \
               --export-width=$TRACEWIDTH \
              $DUMP > /dev/null 2>&1

      autotrace -centerline \
                -color-count=2 \
                -background-color=ffffff \
                -output-file=$DUMP \
                ${DUMP%%.*}.png

      STYLE="style=\"stroke:#000000;fill:none;stroke-width:$WEIGHT;stroke-linecap:round\""

      sed -i "s/style=\"[^\"]*\"/$STYLE/g" $DUMP

      inkscape --verb EditSelectAllInAllLayers \
               --verb StrokeToPath  \
               --verb FileSave \
               --verb FileClose \
               $DUMP > /dev/null 2>&1

      rm ${DUMP%%.*}.png

    done

   #HUNAME=`echo $NAME | sed 's/_/ /g'`
    HUNAME=$NAME
    FAMILY=$NAME

    cp $BLANKFONT ${BLANKFONT%%.*}_backup.sfd 
    sed -i "s/XXXX/$NAME/g" $BLANKFONT  
    sed -i "s/YYYY/$HUNAME/g" $BLANKFONT
    sed -i "s/ZZZZ/$FAMILY/g" $BLANKFONT

       ./svg2ttf-0.3.py

    mv ${BLANKFONT%%.*}_backup.sfd $BLANKFONT 
    mv output.ttf ${OUTPUTDIR}/${NAME}.ttf


    rm $TMPDIR/*.*

 done


exit 0;



