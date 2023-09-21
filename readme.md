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

```bash
createTempFile() {
  TEMP_FILE=$(mktemp)
}
```

### `deleteFileIfExists(file)`

This function deletes a file if it exists.

```bash
deleteFileIfExists() {
  local file=$1
  if [ -f "$file" ]; then
    rm "$file"
  fi
}
```

### `mergeSVGFiles(media, exclude)`

This function merges SVG files found in the `media` directory except for the files specified in `exclude`.

```bash
mergeSVGFiles() {
  local media=$1
  local exclude=$2
  $(which find) "$media" -type f -name "*.svg" -not -name "$exclude" -print0 | xargs -0 cat >> "$TEMP_FILE"
}
```

### `modifySVGFile(tempFile)`
This function modifies the SVG tags in the temporary file to SYMBOL tags. It accommodates three different operating systems:

1. **Linux**: Uses `sed -i` for in-place editing.
2. **macOS (Darwin)**: Uses `sed -i ''` for in-place editing, as macOS's version of sed requires an extension to be specified.
3. **Unknown**: If the operating system is neither Linux nor macOS, a warning message is displayed and sed is not executed.

```bash
modifySVGFile() {
  local tempFile=$1
  if [ "$OS_TYPE" = "Linux" ]; then
    sed -i 's/<svg/<symbol/g; s/<\/svg>/<\/symbol>/g' "$tempFile"
  elif [ "$OS_TYPE" = "Darwin" ] then
    sed -i '' 's/<svg/<symbol/g; s/<\/svg>/<\/symbol>/g' "$tempFile"
  else
    echo "Unknown operatingsystem. sed not being executed."
  fi
}
```

### `addHeaderAndFooter(exportFile, header, footer)`

This function adds a header and footer to the export file.

```bash
addHeaderAndFooter() {
  local exportFile=$1
  local header=$2
  local footer=$3
  echo "$header" > "$exportFile"
  cat "$TEMP_FILE" >> "$exportFile"
  echo "$footer" >> "$exportFile"
}
```

## Usage

### How to Use the Generated `sprites.svg` in HTML

The generated `sprites.svg` will look something like this:

```xml
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="0" height="0" style="position:absolute">
  <symbol id="example-icon" data-name="example" version="1.1" viewBox="0 0 500 500"> ... </symbol>
  <symbol id="example1-icon" data-name="example" version="1.1" viewBox="0 0 500 500"> ... </symbol>
  <symbol id="example2-icon" data-name="example" version="1.1" viewBox="0 0 500 500"> ... </symbol>
</svg>
```

To use these SVG sprites in your HTML, you can use the following code:

```html
<svg class=""><use href="sprites.svg#example-icon" xlink:href="sprites.svg#example-icon" aria-hidden="true"></use></svg>
<svg class=""><use href="sprites.svg#example1-icon" xlink:href="sprites.svg#example1-icon" aria-hidden="true"></use></svg>
<svg class=""><use href="sprites.svg#example2-icon" xlink:href="sprites.svg#example2-icon" aria-hidden="true"></use></svg>
```

## Importance of Using SVG Sprites

### Advantages of Using SVG Sprites

#### 1. Performance Optimization
- **Fewer HTTP Requests**: Instead of making multiple HTTP requests for each individual SVG file, you can make a single request for the sprite sheet, which contains all your SVGs.

#### 2. Cache Efficiency
- **Cache Once, Use Everywhere**: Once the sprite sheet is loaded, it is cached and can be reused across different pages and components without requiring additional HTTP requests.

#### 3. Simplified Management
- **Ease of Maintenance**: It's easier to manage a single sprite sheet than to keep track of multiple individual SVG files.
- **Version Control**: Changes to your SVGs can be made in one place, reducing the chances of outdated or inconsistent assets being used.

#### 4. Advanced CSS Control
- **Styling and Animation**: When SVGs are embedded into HTML, you can control their properties using CSS. Having them in a sprite allows you to apply styles and animations more consistently.

#### 5. Scalability
- **High-Quality Resolution**: SVGs are scalable without loss of quality, which is beneficial for responsive design.

#### 6. Icon Reusability
- **DRY (Don't Repeat Yourself)**: The same icon or shape used in multiple places can be defined once in the sprite and reused with different CSS classes or IDs.

By considering these factors, you can make a more informed decision about using SVG sprites in your projects.

## Run Locally  
Clone the project  

~~~bash  
  git clone https://github.com/digi4care/combine_svg_2_sprites
~~~

Go to the project directory  

~~~bash  
  cd combine_svg_2_sprites
~~~

Copy/Place multiple svg files in the media directory
Execute the script

~~~bash  
sh combine_svg_2_sprites.sh
~~~  

Look in the Export directory for the file called sprites.svg
-- Just be sure that every entry has it's own unique css-id

**id="example2-icon"**

```html
  <symbol id="example2-icon" data-name="example" version="1.1" viewBox="0 0 500 500"> ... </symbol>
```