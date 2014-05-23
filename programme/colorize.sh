#! /usr/bin/env bash

mkdir colors

convert "Balsa 2014-2015.pdf" colors/Balsa2014-2015%d.gif

function colorize {
    convert colors/Balsa2014-2015$((${1} - 1)).gif -colorspace Gray  +level-colors $2, colors/Balsa2014-2015$((${1} - 1))-color.gif
}
colorize 1  "#00334C"
colorize 4  "#00334C"
colorize 5  "#00334C"
colorize 8  "#00334C"
colorize 9  "#00334C"
colorize 12 "#00334C"
colorize 13 "#00334C"
colorize 16 "#00334C"
colorize 17 "#00334C"
colorize 20 "#00334C"
colorize 21 "#00334C"
colorize 24 "#00334C"
colorize 25 "#00334C"
colorize 28 "#00334C"
colorize 29 "#00334C"
colorize 32 "#00334C"

colorize 2  "#8C2633"
colorize 3  "#8C2633"
colorize 30 "#8C2633"
colorize 31 "#8C2633"

colorize 6  "#603311"
colorize 7  "#603311"
colorize 26 "#603311"
colorize 27 "#603311"

colorize 10 "#3F302B"
colorize 11 "#3F302B"
colorize 22 "#3F302B"
colorize 23 "#3F302B"

colorize 14 "#004438"
colorize 15 "#004438"
colorize 18 "#004438"
colorize 19 "#004438"

convert $(ls -v colors/*-color.gif) Balsa2014-2015-color.pdf

rm -r colors
