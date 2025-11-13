# create eps from fig
fig2dev -L eps -D +49,50,51 barDefinition.fig barDefinition0.eps
fig2dev -L eps -D +49,50,53 barDefinition.fig barDefinition1.eps
fig2dev -L eps -D +47,50 barDefinition.fig barDefinition2.eps
fig2dev -L eps -D +47,50,51 barDefinition.fig barDefinition3.eps

# compile lates to make multi-page pdf
latex *.tex
dvips *.dvi
ps2pdf *.ps

# split pdf into singl pages
pdftk barDefinition.pdf burst output barDefinition-%d.pdf

pdf2svg barDefinition-1.pdf barDefinition-1.svg 
pdf2svg barDefinition-2.pdf barDefinition-2.svg 
pdf2svg barDefinition-3.pdf barDefinition-3.svg 
pdf2svg barDefinition-4.pdf barDefinition-4.svg 

pdftoppm barDefinition.pdf barDefinition -r 600 -png


