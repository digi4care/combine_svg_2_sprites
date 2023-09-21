# Combine SVG to Sprites

## Author

- **Name**: Chris Engelhard
- **Email**: c.engelhard@digi4care.nl

## Compatibility

This script is tested to be compatible with Linux, macOS, and common BSD systems.

## Description

This Bash script is designed to merge multiple SVG files into a single SVG file while also modifying the SVG tags. It uses temporary files to assist in this process.

## Functions

### `createTempFile()`

This function creates a temporary file that is used to store the merged SVG content temporarily.

\```bash
createTempFile() {
  TEMP_FILE=$(mktemp)
}
\```

### `deleteFileIfExists(file)`

This function deletes a file if it exists.

\```bash
deleteFileIfExists() {
  local file=$1
  if [ -f "$file" ]; then
    rm "$file"
  fi
}
\```

### `mergeSVGFiles(media, exclude)`

This function merges SVG files found in the `media` directory except for the files specified in `exclude`.

\```bash
mergeSVGFiles() {
  local media=$1
  local exclude=$2
  $(which find) "$media" -type f -name "*.svg" -not -name "$exclude" -print0 | xargs -0 cat >> "$TEMP_FILE"
}
\```

### `modifySVGFile(tempFile)`

This function modifies the SVG tags in the temporary file.

\```bash
modifySVGFile() {
  local tempFile=$1
  sed -i 's/<svg/<symbol/g; s/<\/svg>/<\/symbol>/g' "$tempFile"
}
\```

### `addHeaderAndFooter(exportFile, header, footer)`

This function adds a header and footer to the export file.

\```bash
addHeaderAndFooter() {
  local exportFile=$1
  local header=$2
  local footer=$3
  echo "$header" > "$exportFile"
  cat "$TEMP_FILE" >> "$exportFile"
  echo "$footer" >> "$exportFile"
}
\```
