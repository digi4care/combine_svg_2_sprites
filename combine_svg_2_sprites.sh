#!/bin/bash

# ------------------------------------------------------------------------------
#
# Script Name: Combine SVG to Sprites.
# Author: Chris Engelhard
# Email: c.engelhard@digi4care.nl
# Created On: Debian 11
# Description: This script is designed to merge multiple SVG files into one and modify the SVG tags.
# Compatible: This script is tested to be compatible with Linux, macOS, and common BSD systems.
#
# ------------------------------------------------------------------------------


createTempFile() {
  TEMP_FILE=$(mktemp)
}

deleteFileIfExists() {
  local file=$1
  if [ -f "$file" ]; then
    rm "$file"
  fi
}

mergeSVGFiles() {
  local media=$1
  local exclude=$2
  $(which find) "$media" -type f -name "*.svg" -not -name "$exclude" -print0 | xargs -0 cat >> "$TEMP_FILE"
}

modifySVGFile() {
  local tempFile=$1
  # Kies de juiste sed-optie op basis van het besturingssysteem
  if [ "$OS_TYPE" = "Linux" ]; then
    sed -i 's/<svg/<symbol/g; s/<\/svg>/<\/symbol>/g' "$tempFile"
  elif [ "$OS_TYPE" = "Darwin" ]; then # macOS
    sed -i '' 's/<svg/<symbol/g; s/<\/svg>/<\/symbol>/g' "$tempFile"
  else
    echo "Unknown operatingsystem. sed not being executed."
  fi
}

addHeaderAndFooter() {
  local exportFile=$1
  local header=$2
  local footer=$3
  echo "$header" > "$exportFile"
  cat "$TEMP_FILE" >> "$exportFile"
  echo "$footer" >> "$exportFile"
}

# Main script
OS_TYPE=$(uname)
BESTAND="sprites.svg"
EXPORT=$(pwd)"/export/$BESTAND"
MEDIA=$(pwd)"/media"
EXCLUDE="sprites.svg"
HEADER="<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"0\" height=\"0\" style=\"position:absolute\">"
FOOTER="</svg>"

createTempFile
deleteFileIfExists "$TEMP_FILE"
deleteFileIfExists "$EXPORT"

mergeSVGFiles "$MEDIA" "$EXCLUDE"
modifySVGFile "$TEMP_FILE"
addHeaderAndFooter "$EXPORT" "$HEADER" "$FOOTER"

# Opruimen
deleteFileIfExists "$TEMP_FILE"
