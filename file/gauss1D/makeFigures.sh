fig2dev -L eps -D +49,50,52,53 gauss1D.xfig gauss1D1.eps
fig2dev -L eps -D +49,50,55,56,57 gauss1D.xfig gauss1D3.eps
fig2dev -L eps -D +49,50,58,59,60 gauss1D.xfig gauss1D5.eps

latex gauss1D.tex
dvips gauss1D.dvi
ps2pdf gauss1D.ps

pdftoppm gauss1D.pdf gauss1D -r 600 -png -singlefile
