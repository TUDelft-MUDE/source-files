import os
import subprocess
from pdf2image import convert_from_path
import fitz

def compile_latex_to_pdf(basename):
    subprocess.run(["pdflatex", f"{basename}.tex"], check=True)

def pdf_to_png(basename, dpi=600):
    image = convert_from_path(f"{basename}.pdf", dpi)
    image[0].save(f"{basename}.png", "PNG")

def pdf_to_svg(basename):
    doc = fitz.open(f"{basename}.pdf")
    svg = doc[0].get_svg_image()
    with open(f"{basename}.svg", "w") as f:
        f.write(svg)


basename = "pie"

compile_latex_to_pdf(basename)
pdf_to_png(basename)
pdf_to_svg(basename)

