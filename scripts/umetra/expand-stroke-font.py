#!/usr/bin/env python
#-*- coding: utf-8 -*-

import fontforge
import glob
import sys

LETTERS_DIR = "./tmp"
FONT_NAME = "%s".replace(" ", "-") % sys.argv[1]
BASE_FONT = "./i/%s.sfd" % FONT_NAME
FONT = "%s-stroke.ufo" % FONT_NAME
WEIGHT = int(sys.argv[2])

def expand(char, WEIGHT=200):
    font[char].stroke("circular", WEIGHT, "round", "round", "cleanup")
    left = original[char].left_side_bearing
    right = original[char].right_side_bearing
    font[char].left_side_bearing = 0
    font[char].right_side_bearing = 0
    width = font[char].width
    font[char].width = left + width + right
    font[char].left_side_bearing = left
    font[char].right_side_bearing = right


original = fontforge.open(BASE_FONT)
font = fontforge.open(FONT)

#letters = "kK"
letters = glob.glob("%s/*.svg" % LETTERS_DIR)

for letter in letters:
    letter = letter.split("/")[-1].replace(".svg", "")
    print letter

    try:
        # Convert HTML entity to unicode name
        char = letter.replace("&#", "").replace(";", "")
        char = fontforge.nameFromUnicode(int(char))
        print char
        expand(char, WEIGHT)
    except TypeError:
        # In case it still doesn't work, it passes. i.e: €
        print "%s was not expanded." % char
        pass
    
font.generate("%s-%s.otf" % (FONT_NAME, WEIGHT))
