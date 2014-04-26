#!/usr/bin/env python
#-*- coding: utf-8 -*-

import fontforge
import glob

LETTERS_DIR = "./tmp"
FONT = "Ume-P-Mincho-stroke.ufo"
WEIGHT = 200

def expand(char):
    font[char].stroke("circular", WEIGHT, "round", "round", "cleanup")


font = fontforge.open(FONT)

#letters = "kK"
letters = glob.glob("%s/*.svg" % LETTERS_DIR)

for letter in letters:
    letter = letter.split("/")[-1].replace(".svg", "")
    print letter
    try:
        expand(letter)
    except TypeError:
        # In case of HTML entities
        try:
            print "Convert HTML entity to unicode name"
            char = letter.replace("&#", "").replace(";", "")
            char = fontforge.nameFromUnicode(int(char))
            expand(char)
        except TypeError:
            # In case it still doesn't work, it passes. i.e: €
            print "%s was not expanded." % char
            pass
    
font.generate("Ume-P-Mincho-%s.otf" % (WEIGHT))
