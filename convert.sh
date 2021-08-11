#!/bin/bash

ETHEREUMBOOK_DIR=$1
HTML_DIR=./html

echo "Deleting old HTML version..."
rm -f -R $HTML_DIR

echo "Generate HTML version..."
mkdir -p $HTML_DIR/images
cp -R $ETHEREUMBOOK_DIR/images $HTML_DIR
asciidoctor -D $HTML_DIR $ETHEREUMBOOK_DIR/*.asciidoc

# -r asciidoctor-pdf
# -r asciidoctor-epub3