#! /usr/bin/env bash

mkdir cahier
mkdir pages
mkdir pages/odd

# sans les crop marks
gs -o "Balsa 2014-2015-nocrop.pdf" -sDEVICE=pdfwrite -c "[/CropBox [34 34 671.81 884.4] /PAGES pdfmark"  -f "Balsa 2014-2015.pdf"

# fait un PDF pages paires et impaires
gs -o "pages/Balsa2014-2015-%02d.pdf" -sDEVICE=pdfwrite   -f "Balsa 2014-2015.pdf"

mv pages/Balsa2014-2015-[0123][13579].pdf pages/odd
gs -o "Balsa2014-2015-even.pdf" -sDEVICE=pdfwrite   pages/Balsa2014-2015-*.pdf
gs -o "Balsa2014-2015-odd.pdf" -sDEVICE=pdfwrite   pages/odd/Balsa2014-2015-*.pdf


# cahier central
gs -o "Balsa2014-2015-odd-cahier.pdf" -sDEVICE=pdfwrite -c "[/CropBox [34 34 402.52 671.81] /PAGES pdfmark"  -f "Balsa2014-2015-odd.pdf"
gs -o "Balsa2014-2015-even-cahier.pdf" -sDEVICE=pdfwrite -c "[/CropBox [303.3 34 671.81 671.81] /PAGES pdfmark"  -f "Balsa2014-2015-even.pdf"
gs -o "cahier/Balsa2014-2015-%02d-A.pdf" -sDEVICE=pdfwrite   -f "Balsa2014-2015-odd-cahier.pdf"
gs -o "cahier/Balsa2014-2015-%02d-B.pdf" -sDEVICE=pdfwrite   -f "Balsa2014-2015-even-cahier.pdf"
gs -o "Balsa2014-2015-cahier.pdf" -sDEVICE=pdfwrite   cahier/Balsa2014-2015-*.pdf


# glose
gs -o "Balsa2014-2015-glose.pdf" -sDEVICE=pdfwrite -c "[/CropBox [34 671.81 671.81 884.4] /PAGES pdfmark"  -f "Balsa 2014-2015.pdf"

# chutes
gs -o "Balsa2014-2015-odd-chutes.pdf" -sDEVICE=pdfwrite -c "[/CropBox [402.52 34 671.81 w1.81] /PAGES pdfmark"  -f "Balsa2014-2015-odd.pdf"
gs -o "Balsa2014-2015-even-chutes.pdf" -sDEVICE=pdfwrite -c "[/CropBox [34 34 303.3 671.81] /PAGES pdfmark"  -f "Balsa2014-2015-even.pdf"
gs -o "chutes/Balsa2014-2015-%02d-A.pdf" -sDEVICE=pdfwrite   -f "Balsa2014-2015-odd-chutes.pdf"
gs -o "chutes/Balsa2014-2015-%02d-B.pdf" -sDEVICE=pdfwrite   -f "Balsa2014-2015-even-chutes.pdf"
gs -o "Balsa2014-2015-chutes.pdf" -sDEVICE=pdfwrite   chutes/Balsa2014-2015-*.pdf

rm Balsa2014-2015-odd-chutes.pdf Balsa2014-2015-even-chutes.pdf
rm Balsa2014-2015-odd-cahier.pdf Balsa2014-2015-even-cahier.pdf
rm Balsa2014-2015-odd.pdf Balsa2014-2015-even.pdf
rm cahier/*.pdf
rm chutes/*.pdf
rm pages/odd/*.pdf
rm pages/*.pdf
