# compile lates to make multi-page pdf
latex *.tex
dvips *.dvi
ps2pdf *.ps

# split pdf into single pages
pdftoppm 3dElements.pdf 3dElements -r 600 -png -singlefile

