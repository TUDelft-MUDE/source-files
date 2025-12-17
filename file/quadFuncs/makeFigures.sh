# extract eps from selected layers in fig-file
fig2dev -L eps -D +48:62 quadFuncs.fig quadFuncs1.eps
fig2dev -L eps -D +44:48,56:62 quadFuncs.fig quadFuncs2.eps

# compile latex to make multi-page pdf
latex *.tex
dvips *.dvi
ps2pdf *.ps

# split pdf into single pages
pdftoppm quadFuncs.pdf quadFuncs -r 600 -png

