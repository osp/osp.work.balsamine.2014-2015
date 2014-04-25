#!/usr/bin/env python
#-*- coding: utf-8 -*-

import os
import glob

# svg2ttf v0.3
# Copyleft 2014 Christoph Haag 
#
# BASED ON:
# svg2ttf v0.1
# Copyleft 2008-2009 Ricardo Lafuente

# generate a .ttf file from a set of .svg files
#
# before running this script, create a blank font file in Fontforge
# (make a New font and save it as it is) and change the BLANK_FONT location
#
# you might also want to edit the metadata (title, license, etc.) before
# saving it, or just edit the blank.sfd file afterwards
#
# finally, change the LETTERS_DIR value to the folder where your .svg
# files are; they ought to be named according to their unicode value

LETTERS_DIR = "./tmp"
#BLANK_FONT = "./i/utils/blank_unicode.sfd"
BLANK_FONT = "./i/Ume-P-Mincho.sfd"


letters = glob.glob(os.path.join(LETTERS_DIR, "*.svg"))

# right-o, here we go
import fontforge

# open a blank font template
# TODO: dynamically generate the space character
font = fontforge.open(BLANK_FONT)


for letter in letters:
	outlines = os.path.basename(letter)
	code = "\u" + os.path.splitext(outlines)[0]
#	print(code)
#	print(code.decode('unicode-escape'))
#	print(ord(code.decode('unicode-escape')))
        char = ord(code.decode('unicode-escape'))

# make new glyph
        font.createMappedChar(letter)
		font.createChar(char)

        # Gets original font bearings
        left = font[letter].left_side_bearing
        right = font[letter].right_side_bearing
# import outline file
# notice that font[glyphname] returns the appropriate glyph
# fontforge is awesome :o)
        font.selection.select(font[letter])
        font.cut()
        font[char].importOutlines(LETTERS_DIR + "/" + letter + ".svg")

        # Set bearings to 0
        font[char].left_side_bearing = 0
        font[char].right_side_bearing = 0

        # As bearings are null, the glyph width equals the drawing width
        width = font[char].width

        # We put back the overall bearing: drawing width + left + right
        font[char].width = width + left + right

        # Apply the original font bearings
        font[char].left_side_bearing = left
        font[char].right_side_bearing = right

# generate TrueType hints
# font[char].autoInstr()

# create the output truetype file
font.generate("output.ufo")


from xml.dom.minidom import parse as parseXml
GLYPH_DIR = "output.ufo/glyphs/"
print "cleaning UFO"

for letter in letters:
    if letter.isupper(): letter = letter + "_"
    glyph = parseXml("%s%s.glif" % (GLYPH_DIR, letter))

    contours = glyph.getElementsByTagName("contour")

    for contour in contours:
        # Checks type of first node
        type= contour.childNodes[1].attributes["type"].value

        if type == "move":
            print "nothing to do here"
            pass
        elif type == "line":
            print "changing line to move"
            contour.childNodes[1].attributes["type"].value = "move"
        elif type == "curve":
            print "putting curve at the end of contour"
            contour.appendChild(contour.childNodes[1])
            print "changing line to move"
            contour.childNodes[2].attributes["type"].value = "move"

    # Saves xml
    f = open("%s%s.glif" % (GLYPH_DIR, letter), "w")
    f.write(glyph.toxml())
    f.close()
