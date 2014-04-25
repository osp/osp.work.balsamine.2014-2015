#!/bin/bash

# FONTFAMILY="Ume P Gothic"
  FONTFAMILY="Ume P Mincho"

  TRACEWIDTH=3500 

  BLANKFONT=i/utils/blank.sfd
  OUTPUTDIR=o



  WNAME=`echo 00$WEIGHT | rev | cut -c 1-2 | rev`
  NAME=Umetra-P_`echo $FONTFAMILY | rev | cut -d " " -f 1 | rev`-stroke

# --------------------------------------------------------------------------- # 
  TMPDIR=tmp
  SHIFT=`expr 35`
  e() { echo $1 >> ${DUMP}; }
 
 
  for LETTER in Q S —
  #for LETTER in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z À Á Â Ã Ä Å Æ Œ Ç È É Ê Ë Ì Í Î Ï Ñ Ò Ó Ô Õ Ö Ù Ú Û Ü Ý 0 1 2 3 4 5 6 7 8 9 « » \
                #a b c d e f g h i j k l m n o p q r s t u v w x y z à á â ã ä å æ œ ç è é ê ë ì í î ï ñ ò ó ô õ ö ù ú û ü ý ÿ
# for LETTER in A g W M
   do
 
      DUMP=$TMPDIR/${LETTER}.svg
 
      e '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'
      e '<svg width="3500" height="4500" id="svg" version="1.1"'
      e 'xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"'
      e '>'
      e '<g inkscape:label="letter" inkscape:groupmode="layer" id="X">'
      e '<flowRoot xml:space="preserve" id="flowRoot"'
 
      e "style=\"font-size:4000px;\
                 font-style:normal;\
                 font-variant:normal;\
                 font-weight:normal;\
                 font-stretch:normal;\
                 text-align:center;\
                 line-height:100%;\
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
      e "<rect id=\"rect\" width=\"4000\" height=\"4500\" x=\"0\" y=\"-$SHIFT\" />"
      e "</flowRegion><flowPara id=\"flowPara\">$LETTER</flowPara></flowRoot>"
      e '</g>'
      e '</svg>'
 
      # Export SVG into PNG
      inkscape --export-png=${DUMP%%.*}.png \
               --export-background=#ffffff \
               --export-width=$TRACEWIDTH \
              $DUMP
        
      convert ${DUMP%%.*}.png ${DUMP%%.*}.gif

      # Vectorize bitmap with stroke
      autotrace -centerline \
                -color-count=2 \
                -background-color=ffffff \
                -output-file=$DUMP \
                ${DUMP%%.*}.gif

      # Setting "stroke" to "none" forces stroke import in Fontforge
      STYLE="style=\"stroke:none;fill:none;\""

      # Apply stroke style
      sed -i "s/style=\"[^\"]*\"/$STYLE/g" $DUMP

      # Removes png files
      rm ${DUMP%%.*}.png

    done

    # Font naming
   HUNAME=`echo $NAME | sed 's/_/ /g'`
    HUNAME=$NAME
    FAMILY=$NAME

    # Makes a backup of the blank font file
    cp $BLANKFONT ${BLANKFONT%%.*}_backup.sfd 

    # Changes font info
    sed -i "s/XXXX/$NAME/g" $BLANKFONT  
    sed -i "s/YYYY/$HUNAME/g" $BLANKFONT
    sed -i "s/ZZZZ/$FAMILY/g" $BLANKFONT

    echo "Launching Ana and Ricardo's script"
    # Launches Ana and Ricardo's script (takes a set of SVG files and puts them into a blank .sfd)
       python2 svg2ttf-0.2.py

    # Reset the blank font to blank
    mv ${BLANKFONT%%.*}_backup.sfd $BLANKFONT 

    # Moves "output.ttf" into "o" folder
    mv output.ttf ${OUTPUTDIR}/${NAME}.ttf


    # Clean the "tmp" folder
    rm $TMPDIR/*.*



exit 0;



