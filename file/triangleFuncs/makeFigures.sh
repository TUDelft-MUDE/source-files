# compile latex to make multi-page pdf
latex *.tex
dvips *.dvi
ps2pdf *.ps

# split pdf into single pages
pdftoppm triangleFuncs.pdf triangleFuncs -r 400 -png -singlefile

