#! /usr/bin/env bash

mkdir colors

convert "Balsa 2014-2015.pdf" colors/Balsa2014-2015%d.gif

function colorize {
    convert colors/Balsa2014-2015$((${1} - 1)).gif -colorspace Gray  +level-colors $2, colors/Balsa2014-2015$((${1} - 1))-color.gif
}
colorize 1  "#000080"
colorize 4  "#000080"
colorize 5  "#000080"
colorize 8  "#000080"
colorize 9  "#000080"
colorize 12 "#000080"
colorize 13 "#000080"
colorize 16 "#000080"
colorize 17 "#000080"
colorize 20 "#000080"
colorize 21 "#000080"
colorize 24 "#000080"
colorize 25 "#000080"
colorize 28 "#000080"
colorize 29 "#000080"
colorize 32 "#000080"

colorize 2  "#8B4513"
colorize 3  "#8B4513"
colorize 30 "#8B4513"
colorize 31 "#8B4513"

colorize 6  "#2E8B57"
colorize 7  "#2E8B57"
colorize 26 "#2E8B57"
colorize 27 "#2E8B57"

colorize 10 "#4B0082"
colorize 11 "#4B0082"
colorize 22 "#4B0082"
colorize 23 "#4B0082"

colorize 14 "#DC143C"
colorize 15 "#DC143C"
colorize 18 "#DC143C"
colorize 19 "#DC143C"

convert $(ls -v colors/*-color.gif) Balsa2014-2015-color.pdf

rm -r colors
