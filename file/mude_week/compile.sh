# compile lates to make multi-page pdf
pdflatex *.tex

# split pdf into single pages
pdftk weekly.pdf burst output pdfs/weekly-%d.pdf

# convert single pages to svg
pdf2svg pdfs/weekly-1.pdf svgs/weekly-1.svg
pdf2svg pdfs/weekly-2.pdf svgs/weekly-2.svg
pdf2svg pdfs/weekly-3.pdf svgs/weekly-3.svg
pdf2svg pdfs/weekly-4.pdf svgs/weekly-4.svg
pdf2svg pdfs/weekly-5.pdf svgs/weekly-5.svg

# remove single page pdfs
rm -r pdfs

# make separate pngs from all pages
pdftoppm weekly.pdf pngs/weekly -r 600 -png
