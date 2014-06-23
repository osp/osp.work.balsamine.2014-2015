#!/bin/bash

# FONTFAMILY="Ume P Gothic"
  FONTFAMILY="Ume P Mincho"

  # AFFECTS PRECISENESS
  TRACEWIDTH=400 

  BLANKFONT=i/utils/blank_unicode.sfd
  OUTPUTDIR=o

  LOG=trace.log
  if [ -f $LOG ]; then rm trace.log; fi


#for WEIGHT in 2 5 10 15 20 30 40 50 60
 for WEIGHT in 1
  do

  WNAME=`echo 00$WEIGHT | rev | cut -c 1-2 | rev`
  NAME=Umetra-${WNAME}P_`echo $FONTFAMILY | rev | cut -d " " -f 1 | rev`

# --------------------------------------------------------------------------- # 
  TMPDIR=tmp
# SHIFT=`expr 35 + $WEIGHT / 4`
  SHIFT=200
  e() { echo $1 >> ${DUMP}; }
 
 
# NO ASTERISK SO FAR "&#42;"

 for CHARACTER in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
                  À Á Â Ã Ä Å Æ Œ Ç È É Ê Ë Ì Í Î Ï Ñ Ò Ó Ô Õ Ö Ù Ú Û Ü Ý \
                  0 1 2 3 4 5 6 7 8 9 « » ^ ° ~ + \` \´ \ ß ü ö ä Ö Ü Ä \
                  a b c d e f g h i j k l m n o p q r s t u v w x y z \
                  à á â ã ä å æ œ ç è é ê ë ì í î ï ñ ò ó ô õ ö ù ú û ü ý ÿ \
                 \; - — _ . ,  \# \§ \$ \% "&#38;" / \( \) \= { } [ ] \ \| ¶ \
                 "&#8216;" "&#8217;" "&#8218;" "&#8220;" "&#8221;" "&#8222;" \
                 "&quot;" "&gt;" "&lt;" "&#39;" "&#8364;" "&#8230;" "&#42;"
#for CHARACTER in A M y ~ K 
   do

      # THIS IS A HACK IF THE TRANSFORMATION DOES NOT WORK SOMETIMES
      # FOR SOME MAGICAL REASON (WHICH WAS THE CASE)
      FAIL=0
      while [ $FAIL -lt 10 ]; do


      if [ `echo $CHARACTER | wc -c ` -gt 3 ]; then  
         
        INFO=`echo $CHARACTER | \
              recode HTML..dump-with-names | \
              tail -2 | \
              head -1`
  
        UNICODE=`echo $INFO | cut -d " " -f 1`
        DESCRIPTION=`echo $INFO | cut -d " " -f 3-`
  
        echo $UNICODE
        echo $DESCRIPTION

      else 

        INFO=`echo $CHARACTER | \
              recode utf-8..dump-with-names | \
              tail -2 | \
              head -1`
  
        UNICODE=`echo $INFO | cut -d " " -f 1`
        DESCRIPTION=`echo $INFO | cut -d " " -f 3-`
  
        echo $UNICODE
        echo $DESCRIPTION
       
       fi

      DUMP=$TMPDIR/${UNICODE}.svg
 
      e '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'
      e '<svg width="300" height="450" id="svg" version="1.1"'
      e 'xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"'
      e '>'
      e '<g inkscape:label="letter" inkscape:groupmode="layer" id="X">'
      e '<flowRoot xml:space="preserve" id="flowRoot"'
 
      e "style=\"font-size:150px;\
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
      e "<rect id=\"rect\" width=\"300\" height=\"200\" x=\"0\" y=\"$SHIFT\" />"
      e "</flowRegion><flowPara id=\"flowPara\">$CHARACTER</flowPara></flowRoot>"
      e '</g>'
      e '</svg>'
 
      # Export SVG into PNG
      inkscape --export-png=${DUMP%%.*}.png \
               --export-background=#ffffff \
               --export-width=$TRACEWIDTH \
              $DUMP > /dev/null 2>&1

      # Vectorize bitmap with stroke
      autotrace -centerline \
                -color-count=2 \
                -background-color=ffffff \
                -output-file=${DUMP%%.*}.pdf \
                ${DUMP%%.*}.png

      # Use LaTeX to scale the stuff
      echo "\documentclass[9pt]{scrbook}"                    >  tmp.tex
      echo "\usepackage{pdfpages}"                           >> tmp.tex
      echo "\usepackage{geometry}"                           >> tmp.tex
      echo "\geometry{paperwidth=2625pt,paperheight=3375pt}" >> tmp.tex
      echo "\begin{document}"                                >> tmp.tex
      echo "\includepdf[offset=0 1880,scale=3.1]"            >> tmp.tex
      echo "{"${DUMP%%.*}.pdf"}"                             >> tmp.tex
      echo "\end{document}"                                  >> tmp.tex

      pdflatex -interaction=nonstopmode \
               -output-directory $TMPDIR \
                tmp.tex > /dev/null

      if [ -f $TMPDIR/tmp.pdf ]; then

      mv $TMPDIR/tmp.pdf ${DUMP%%.*}_scale.pdf

      # COULD BE AN ISSUE
      # PDF2SVG 0.2.1-2+b3 PROBLEMS (= IMPRECISE) !!
      # -> DOWNGRADE: https://github.com/wagle/pdf2svg
      pdf2svg ${DUMP%%.*}_scale.pdf $DUMP

      STYLE="style=\"stroke:#000000;fill:none;stroke-width:$WEIGHT;stroke-linecap:round\""

      # Setting "stroke" to "none" forces stroke import in Fontforge
#     STYLE="style=\"stroke:none;fill:none;\""

      # Apply stroke style
      sed -i "s/style=\"[^\"]*\"/$STYLE/g" $DUMP

      inkscape --verb EditSelectAllInAllLayers \
               --verb SelectionUnGroup \
               --verb StrokeToPath  \
               --verb FileSave \
               --verb FileClose \
               $DUMP > /dev/null 2>&1

       # Removes temporary files
       rm ${DUMP%%.*}.png ${DUMP%%.*}*.pdf

       FAIL=10

       else

       echo $CHARACTER >> trace.log
       # Remove all
       rm ${DUMP%%.*}.*
       FAIL=`expr $FAIL + 1`
       sleep 1

       fi

       # Removes temporary files
       rm tmp.tex $TMPDIR/*.aux $TMPDIR/*.log

     done
    done

    # Font naming
    HUNAME=$NAME
    FAMILY=$NAME

    # Makes a backup of the blank font file
    cp $BLANKFONT ${BLANKFONT%%.*}_backup.sfd 

    # Changes font info
    sed -i "s/XXXX/$NAME/g" $BLANKFONT  
    sed -i "s/YYYY/$HUNAME/g" $BLANKFONT
    sed -i "s/ZZZZ/$FAMILY/g" $BLANKFONT

    clear; echo
    echo "Launching Ana and Ricardo's script"; echo
    # Launches Ana and Ricardo's script 
    # (takes a set of SVG files and puts them into a blank .sfd)

       ./svg2ttf-0.3.py
    
    # Reset the blank font to blank
    mv ${BLANKFONT%%.*}_backup.sfd $BLANKFONT 

    # Moves "output.ttf" into "o" folder
    mv output.ttf ${OUTPUTDIR}/${NAME}.ttf

    # Clean the "tmp" folder
    rm $TMPDIR/*.*

 done


exit 0;



