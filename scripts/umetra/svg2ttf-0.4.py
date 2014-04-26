#!/usr/bin/env python
#-*- coding: utf-8 -*-

import glob
import fontforge
from xml.dom.minidom import parse as parseXml

# svg2ttf v0.3
# Copyleft 2014 Christoph Haag 
#
# BASED ON:
# svg2ttf v0.1
# Copyleft 2008-2009 Ricardo Lafuente

# generates a .ufo file from a set of .svg files autotraced in its centerlines
#
# it then imports the glyph inside the original font file BASE_FONT
#
# you might also want to edit the metadata (title, license, etc.) before
# saving it, or just edit the .ufo file afterwards
#
# finally, change the LETTERS_DIR value to the folder where your .svg
# files are; they ought to be named according to their unicode value

LETTERS_DIR = "./tmp"
BLANK_FONT = "./i/utils/blank_unicode.sfd"
BASE_FONT = "./i/Ume-P-Mincho.sfd"
STROKE_FONT = "Ume-P-Mincho-stroke.ufo"


files = glob.glob("%s/*.svg" % LETTERS_DIR)

original = fontforge.open(BASE_FONT)
font = fontforge.open(BLANK_FONT)

def importGlyph(f, letter, char): 
    # Gets original font bearings
    try:
        left = original[char].left_side_bearing
        right = original[char].right_side_bearing
    except TypeError:
        ## Happens when glyph was not existing
        left = 0
        right = 0

    # make new glyph
    font.createMappedChar(letter)
    font.createChar(char)

    # Import outline file
    font[char].importOutlines(f)

    # Set bearings to 0
    font[char].left_side_bearing = 0
    font[char].right_side_bearing = 0

    # As bearings are null, the glyph width equals the drawing width
    width = font[char].width

    # Put back the overall bearing
    font[char].width = left + width + right

    # Apply the original font bearings
    font[char].left_side_bearing = left
    font[char].right_side_bearing = right

for f in files:
        letter = f.split("/")[-1].replace(".svg", "")
        char = fontforge.unicodeFromName(letter)

        if char == -1:
            char = letter.replace("&#", "").replace(";", "")
            letter = fontforge.nameFromUnicode(int(char))
        print "letter: %s" % letter
        print "char: %s" % char
        importGlyph(f, letter, int(char))


# create the output ufo file
font.generate(STROKE_FONT)


#####################################################


print "cleaning UFO"

GLYPH_DIR = "%s/glyphs/" % STROKE_FONT

for letter in files:
    letter = letter.split("/")[-1].replace(".svg", "")
    char = fontforge.unicodeFromName(letter)

    if char == -1:
        char = letter.replace("&#", "").replace(";", "")
        letter = fontforge.nameFromUnicode(int(char))
    print "letter: %s" % letter
    print "char: %s" % char

    # In UFO, capital characters have an underscore in their name: "A" -> "A_.glif"
    if letter[0].isupper(): 
        if len(letter) == 1:
            letter = letter + "_"
        elif len(letter) == 2:
            letter = letter[0] + "_" + letter[1] + "_"
        else:
            letter = letter[0] + "_" + letter[1:]


    # Gets the XML of the glyph
    try: 
        glyph = parseXml("%s%s.glif" % (GLYPH_DIR, letter))
    except IOError:
        # In case of HTML entities
        try:
            letter = letter.replace("&#", "").replace(";", "")
            letter = fontforge.nameFromUnicode(int(char))
            glyph = parseXml("%s%s.glif" % (GLYPH_DIR, letter))
        except ValueError:
            # In case it still doesn't work, it passes. i.e: €
            print "%s did not work." % char
            pass

    # Gets contours descriptions of the glyph
    contours = glyph.getElementsByTagName("contour")

    for contour in contours:
        # Checks type of first node of the countour
        type= contour.childNodes[1].attributes["type"].value

        try:
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
