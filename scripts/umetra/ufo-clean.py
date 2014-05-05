#!/usr/bin/env python
#-*- coding: utf-8 -*-

from xml.dom.minidom import parse as parseXml
import sys
import glob
import fontforge


#letters = ["&#33;", "&#34;", "&#35;", "&#36;", "&#37;", "&#38;", "&#39;", "&#40;", "&#41;", "&#42;", "&#43;", "&#44;", "&#45;", "&#46;", "&#47;", "&#48;", "&#49;", "&#50;", "&#51;", "&#52;", "&#53;", "&#54;", "&#55;", "&#56;", "&#57;", "&#58;", "&#59;", "&#60;", "&#61;", "&#62;", "&#63;", "&#64;", "&#65;", "&#66;", "&#67;", "&#68;", "&#69;", "&#70;", "&#71;", "&#72;", "&#73;", "&#74;", "&#75;", "&#76;", "&#77;", "&#78;", "&#79;", "&#80;", "&#81;", "&#82;", "&#83;", "&#84;", "&#85;", "&#86;", "&#87;", "&#88;", "&#89;", "&#90;", "&#91;", "&#92;", "&#93;", "&#94;", "&#95;", "&#96;", "&#97;", "&#98;", "&#99;", "&#100;", "&#101;", "&#102;", "&#103;", "&#104;", "&#105;", "&#106;", "&#107;", "&#108;", "&#109;", "&#110;", "&#111;", "&#112;", "&#113;", "&#114;", "&#115;", "&#116;", "&#117;", "&#118;", "&#119;", "&#120;", "&#121;", "&#122;", "&#123;", "&#124;", "&#125;", "&#126;", "&#127;", "&#128;", "&#129;", "&#130;", "&#131;", "&#132;", "&#133;", "&#134;", "&#135;", "&#136;", "&#137;", "&#138;", "&#139;", "&#140;", "&#141;", "&#142;", "&#143;", "&#144;", "&#145;", "&#146;", "&#147;", "&#148;", "&#149;", "&#150;", "&#151;", "&#152;", "&#153;", "&#154;", "&#155;", "&#156;", "&#157;", "&#158;", "&#159;", "&#160;", "&#161;", "&#162;", "&#163;", "&#164;", "&#165;", "&#166;", "&#167;", "&#168;", "&#169;", "&#170;", "&#171;", "&#172;", "&#173;", "&#174;", "&#175;", "&#176;", "&#177;", "&#178;", "&#179;", "&#180;", "&#181;", "&#182;", "&#183;", "&#184;", "&#185;", "&#186;", "&#187;", "&#188;", "&#189;", "&#190;", "&#191;", "&#192;", "&#193;", "&#194;", "&#195;", "&#196;", "&#197;", "&#198;", "&#199;", "&#200;", "&#201;", "&#202;", "&#203;", "&#204;", "&#205;", "&#206;", "&#207;", "&#208;", "&#209;", "&#210;", "&#211;", "&#212;", "&#213;", "&#214;", "&#215;", "&#216;", "&#217;", "&#218;", "&#219;", "&#220;", "&#221;", "&#222;", "&#223;", "&#224;", "&#225;", "&#226;", "&#227;", "&#228;", "&#229;", "&#230;", "&#231;", "&#232;", "&#233;", "&#234;", "&#235;", "&#236;", "&#237;", "&#238;", "&#239;", "&#240;", "&#241;", "&#242;", "&#243;", "&#244;", "&#245;", "&#246;", "&#247;", "&#248;", "&#249;", "&#250;", "&#251;", "&#252;", "&#253;", "&#254;", "&#8364;"]

#letters = ["&#338;", "&#339;", "&#8230;", "&#8211;", "&#8212;", "&#8216;", "&#8217;", "&#8220;", "&#8221;", "&#8544;", "&#8545;", "&#8546;", "&#8547;", "&#8548;", "&#8549;", "&#8550;", "&#8551;", "&#8552;", "&#8553;", "&#8554;", "&#8555;", "&#8556;", "&#8557;", "&#8558;", "&#8559;", "&#8592;", "&#8593;", "&#8594;", "&#8595;", "&#9450;", "&#9312;", "&#9313;", "&#9314;", "&#9315;", "&#9316;", "&#9317;", "&#9318;", "&#9319;", "&#9320;", "&#9833;", "&#9834;", "&#9835;", "&#9836;", "&#9837;", "&#9838;", "&#9839;"]

letters = ["&#8242;", "&#8243;", "&#8738;"]

STROKE_FONT = "%s-stroke.ufo" % sys.argv[1].replace(" ", "-")
GLYPH_DIR = "%s/glyphs/" % STROKE_FONT

for letter in letters:
    letter = letter.split("/")[-1].replace(".svg", "")
    char = fontforge.unicodeFromName(letter)

    if char == -1:
        char = letter.replace("&#", "").replace(";", "")
        letter = fontforge.nameFromUnicode(int(char))
    print "letter: %s" % letter
    print "char: %s" % char


    # Gets the XML of the glyph
    try: 
        letter = letter.replace("&#", "").replace(";", "")
        letter = fontforge.nameFromUnicode(int(char))
        # In UFO, capital characters have an underscore in their name: "A" -> "A_.glif"
        if letter[0].isupper(): 
            if len(letter) == 1:
                letter = letter + "_"
            elif len(letter) == 2:
                letter = letter[0] + "_" + letter[1] + "_"
            else:
                letter = letter[0] + "_" + letter[1:]
            #letter = letter.lower()
        if letter[0:3] == "uni": 
            continue
            #letter = "uni" + letter[3:].upper() + "_"



        glyph = parseXml("%s%s.glif" % (GLYPH_DIR, letter))
        # Gets contours descriptions of the glyph
        contours = glyph.getElementsByTagName("contour")

        for contour in contours:
            try:
                # Checks type of first node of the countour
                type= contour.childNodes[1].attributes["type"].value
                if type == "move":
                    # Should be ok already
                    pass
                elif type == "line":
                    # Changing type "line" to "move"
                    contour.childNodes[1].attributes["type"].value = "move"
                elif type == "curve":
                    # Putting curve point at the end of the contour
                    contour.appendChild(contour.childNodes[1])
                    # Changing first "line" to "move"
                    contour.childNodes[2].attributes["type"].value = "move"
            except KeyError:
                print "Did not work."
                pass


        # Saves XML
        f = open("%s%s.glif" % (GLYPH_DIR, letter), "w")
        f.write(glyph.toxml())
        f.close()
    except IOError:
        # In case it still doesn't work, it passes. i.e: €
        print "%s did not work." % char
        pass

