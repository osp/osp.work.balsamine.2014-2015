#!/usr/bin/env python
#-*- coding: utf-8 -*-
import fontforge

letters = "kK"
FONT = "output.ufo"
font = fontforge.open(FONT)

for letter in letters:
    font[letter].stroke("circular", 80, "round", "round", "cleanup")
    
font.generate("output-%s.ufo" % ("80"))
