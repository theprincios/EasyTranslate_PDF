import sys
import os
from PyPDF2 import PdfReader
from googletrans import Translator
from fpdf import FPDF


def parse_pages(pages_str):
    if not pages_str:
        return None  # tutte le pagine
    try:
        pages = [int(p.strip()) for p in pages_str.split(',') if p.strip().isdigit()]
        return pages
    except Exception as e:
        print(f"Error parsing pages list: {e}. Use comma-separated integers like: 0,1,2", flush=True)
        return None


def translate_pdf_simple(input_pdf, output_pdf, input_language="en", target_language="en", pages_to_translate=None, font_path=None):
    print(f"Opening PDF: {input_pdf}", flush=True)

    reader = PdfReader(input_pdf)
    translator = Translator()
    pdf_writer = FPDF()
    pdf_writer.set_auto_page_break(auto=False)

    if font_path and os.path.isfile(font_path):
        pdf_writer.add_font("CustomFont", '', font_path, uni=True)
        pdf_writer.set_font("CustomFont", size=12)
        print(f"Using custom font: {font_path}", flush=True)
    else:
        pdf_writer.set_font("Arial", size=12)
        print("Using default Arial font", flush=True)

    total_pages = len(reader.pages)
    if pages_to_translate is None:
        pages_to_translate = range(total_pages)
    else:
        pages_to_translate = [p for p in pages_to_translate if 0 <= p < total_pages]

    print(f"Translating {len(pages_to_translate)} pages from {input_language} to {target_language}...", flush=True)

    for i, page_num in enumerate(pages_to_translate, start=1):
        page = reader.pages[page_num]
        text = page.extract_text()

        if not text or not text.strip():
            translated_text = "(Empty Page)"
        else:
            try:
                translated_text = translator.translate(text, src=input_language, dest=target_language).text
            except Exception as e:
                print(f"Error translating page {page_num + 1}: {e}", flush=True)
                translated_text = "(Translation Error)"

        pdf_writer.add_page()
        pdf_writer.multi_cell(0, 10, translated_text)

        print(f"PAGE_PROGRESS {i}/{len(pages_to_translate)}", flush=True)

    print(f"Saving translated PDF to: {output_pdf}", flush=True)
    pdf_writer.output(output_pdf)
    print("Translation complete.", flush=True)



if __name__ == "__main__":
    if len(sys.argv) < 5:
        print("Usage: python3 translate_pdf.py <input_pdf> <output_pdf> <input_language> <target_language> [pages] [font_path]", flush=True)
        sys.exit(1)

    input_pdf = sys.argv[1]
    output_pdf = sys.argv[2]
    input_language = sys.argv[3]
    target_language = sys.argv[4]
    pages_arg = sys.argv[5] if len(sys.argv) > 5 else ""
    font_path = sys.argv[6] if len(sys.argv) > 6 else None

    pages = parse_pages(pages_arg)

    print(f"Input PDF: {input_pdf}")
    print(f"Output PDF: {output_pdf}")
    print(f"Input language: {input_language}")
    print(f"Target language: {target_language}")
    print(f"Pages: {pages if pages is not None else 'All pages'}")
    print(f"Font path: {font_path if font_path else 'None (default font)'}")

    translate_pdf_simple(input_pdf, output_pdf, input_language=input_language, target_language=target_language, pages_to_translate=pages, font_path=font_path)
