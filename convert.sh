#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "ERROR: must pass the ethereumbook folder."
    exit 2
fi

ETHEREUMBOOK_DIR=$1

# --------------------------------------------------------------
# Copy all ASCII doc and images

ASCIIDOC_DIR=./asciidoc

echo "Deleting old ASCII doc version..."
rm -f -R $ASCIIDOC_DIR

# Copying data
mkdir -p $ASCIIDOC_DIR/images
cp -R $ETHEREUMBOOK_DIR/images $ASCIIDOC_DIR
cp -R $ETHEREUMBOOK_DIR/code $ASCIIDOC_DIR

cp -R $ETHEREUMBOOK_DIR/*.asciidoc $ASCIIDOC_DIR

# --------------------------------------------------------------
# HTML

HTML_DIR=./html

echo "Deleting old HTML version..."
rm -f -R $HTML_DIR

echo "Generate HTML version..."
mkdir -p $HTML_DIR/images
cp -R $ETHEREUMBOOK_DIR/images $HTML_DIR
asciidoctor -D $HTML_DIR $ASCIIDOC_DIR/book.asciidoc

# --------------------------------------------------------------
# PDF

PDF_DIR=./pdf

echo "Deleting old PDF version..."
rm -f -R $PDF_DIR

echo "Generate PDF version..."
asciidoctor-pdf -D $PDF_DIR $ASCIIDOC_DIR/book.asciidoc

#echo "Updating PDF bookmarks..."
#pdftk $PDF_DIR/ethereumbook.pdf dump_data > $PDF_DIR/bookmarks.info
#pdftk $PDF_DIR/ethereumbook.pdf update_info $PDF_DIR/bookmarks.info output $PDF_DIR/ethereumbook.pdf

# --------------------------------------------------------------
# EPUB3

EPUB3_DIR=./epub3

echo "Deleting old EPUB3 version..."
rm -f -R $EPUB3_DIR

echo "Generate EPUB3 version..."
asciidoctor-epub3 -D $EPUB3_DIR $ASCIIDOC_DIR/book.asciidoc