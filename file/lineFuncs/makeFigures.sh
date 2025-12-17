fig2dev -L eps -D +50:52 lineFuncs.fig lineFuncs4.eps
fig2dev -L eps -D +50,62 lineFuncs.fig lineFuncs5.eps

# compile latex to make multi-page pdf
latex *.tex
dvips *.dvi
ps2pdf *.ps

# split pdf into single pages
pdftoppm lineFuncs.pdf lineFuncs -r 600 -png

