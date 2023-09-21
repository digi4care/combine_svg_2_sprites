#!/bin/bash

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
  sed -i 's/<svg/<symbol/g; s/<\/svg>/<\/symbol>/g' "$tempFile"
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
