BUILD = build
MAKEFILE = Makefile
OUTPUT_FILENAME = Die_Zugspitz-Expedition_zur_Errichtung_eines_vergoldeten_Eisen-Cylinder-Kreuzes
TITLE_NAME = "Die Zugspitz-Expedition zur Errichtung eines vergoldeten Eisen-Cylinder-Kreuzes"
METADATA = metadata.yml
CHAPTERS = chapters/*.md
TOC = --toc --toc-depth=3
IMAGES_FOLDER = images
IMAGES = $(IMAGES_FOLDER)/*
COVER_IMAGE = $(IMAGES_FOLDER)/cover.jpg
LATEX_CLASS = book
MATH_FORMULAS = --webtex
CSS_FILE = blitz.css
CSS_FILE_KINDLE=blitz.css
CSS_FILE_PRINT=print.css
CSS_ARG = --css=$(CSS_FILE)
CSS_ARG_KINDLE = --css=$(CSS_FILE_KINDLE)
CSS_ARG_PRINT = --css=$(CSS_FILE_PRINT)
METADATA_ARG = --metadata-file=$(METADATA)
METADATA_PDF = chapters/preface/metadata_pdf_html.md
PREFACE_EPUB = chapters/preface/preface_epub.md
PREFACE_HTML_PDF = chapters/preface/preface_html_pdf.md
ARGS = $(TOC) $(MATH_FORMULAS) $(CSS_ARG) $(METADATA_ARG) --reference-location=block
#CALIBRE="../../calibre/Calibre Portable/Calibre/"
CALIBRE="C:/Program Files/Calibre2/"

all: book

book: epub html pdf docx

clean:
	rm -r $(BUILD)

epub: $(BUILD)/epub/$(OUTPUT_FILENAME).epub

html: $(BUILD)/html/$(OUTPUT_FILENAME).html

pdf: $(BUILD)/pdf/$(OUTPUT_FILENAME).pdf

docx: $(BUILD)/docx/$(OUTPUT_FILENAME).docx

$(BUILD)/epub/$(OUTPUT_FILENAME).epub: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(CSS_FILE_KINDLE) $(IMAGES) \
																			 $(COVER_IMAGE) $(METADATA) $(PREFACE_EPUB)
	mkdir -p $(BUILD)/epub
	"C:\Program Files\Pandoc/pandoc" $(ARGS) --from markdown+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans --to epub+raw_html --resource-path=$(IMAGES_FOLDER) --epub-cover-image=$(COVER_IMAGE) -o $@  $(PREFACE_EPUB) $(CHAPTERS)
	$(CALIBRE)ebook-polish --add-soft-hyphens -i -p -U $@ $@
	$(CALIBRE)ebook-convert $@ $(BUILD)/epub/$(OUTPUT_FILENAME).azw3 --share-not-sync --disable-font-rescaling
	$(CALIBRE)ebook-convert $(BUILD)/epub/$(OUTPUT_FILENAME).azw3 $(BUILD)/epub/$(OUTPUT_FILENAME).mobi --share-not-sync --disable-font-rescaling --mobi-file-type both
   

$(BUILD)/docx/$(OUTPUT_FILENAME).docx: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(CSS_FILE_KINDLE) $(IMAGES) \
																			 $(COVER_IMAGE) $(PREFACE_HTML_PDF)
	mkdir -p $(BUILD)/docx
	pandoc $(ARGS) --from markdown+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans --to docx --resource-path=$(IMAGES_FOLDER) -o $@  $(CHAPTERS)
