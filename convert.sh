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
rm $ASCIIDOC_DIR/book.asciidoc

# --------------------------------------------------------------
# HTML

HTML_DIR=./html

echo "Deleting old HTML version..."
rm -f -R $HTML_DIR

echo "Generate HTML version..."
mkdir -p $HTML_DIR/images
cp -R $ETHEREUMBOOK_DIR/images $HTML_DIR
asciidoctor -D $HTML_DIR $ASCIIDOC_DIR/*.asciidoc

# --------------------------------------------------------------
# PDF

PDF_DIR=./pdf

echo "Deleting old PDF version..."
rm -f -R $PDF_DIR

echo "Generate PDF version..."
asciidoctor-pdf -D $PDF_DIR/chapters $ASCIIDOC_DIR/*.asciidoc
pdftk $PDF_DIR/chapters/preface.pdf \
        $PDF_DIR/chapters/0*.pdf \
        $PDF_DIR/chapters/1*.pdf \
        $PDF_DIR/chapters/appdx-*.pdf \
        $PDF_DIR/chapters/github_contrib.pdf \
        $PDF_DIR/chapters/glossary.pdf \
    cat output $PDF_DIR/ethereumbook.pdf

echo "Updating PDF bookmarks..."
pdftk $PDF_DIR/ethereumbook.pdf dump_data > $PDF_DIR/bookmarks.info
pdftk $PDF_DIR/ethereumbook.pdf update_info $PDF_DIR/bookmarks.info output $PDF_DIR/ethereumbook.pdf
