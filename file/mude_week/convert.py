import os
from pdf2image import convert_from_path
import fitz

def pdf_to_png(basename, output_dir="pngs", dpi=600):
    os.makedirs(output_dir, exist_ok=True)
    images = convert_from_path(f"{basename}.pdf", dpi)
    for i, image in enumerate(images):
        image.save(f"{output_dir}/{basename}-{i+1}.png", "PNG")

def pdf_to_svg(basename, output_dir="svgs"):
    os.makedirs(output_dir, exist_ok=True)
    doc = fitz.open(f"{basename}.pdf")
    for i, page in enumerate(doc):
        svg = page.get_svg_image()
        with open(f"{output_dir}/{basename}-{i+1}.svg", "w") as f:
            f.write(svg)

basename = "schedule"

pdf_to_png(basename)
pdf_to_svg(basename)
