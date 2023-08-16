#!/usr/bin/env bash

# share common environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/env.sh"

OPTIMIZED_DIR="/Users/dustinschau/Pictures/Optimized"
OUTPUT_DIR="${MEDIA_DIR}/Pictures"

echo $PICTURES_DIR
echo $OUTPUT_DIR
echo $MEDIA_DIR

mkdir -p "${OPTIMIZED_DIR}"

# cd to source directory
pushd "${PICTURES_DIR}" > /dev/null

rsync --omit-dir-times --dry-run --partial --archive --compress --itemize-changes "${PICTURES_DIR}" "${OUTPUT_DIR}/Source" | \
while read -r line ; do
  if [[ $line == "<f"* ]] ; then
    # Extract the filename (9th field onward)
    full_filename=${line#*<f+++++++ }
    full_filename=$(echo "$full_filename" | cut -d'/' -f2-) # strips the first folder

    filename=$(basename "$full_filename")
    filename_without_ext="${filename%.*}"

    file="$PICTURES_DIR/${full_filename}"

    # add your logic here, $file variable contains the filename
    date=$(exiftool -DateTimeOriginal -s -s -s "$file" | awk '{print $1}')
    year=$(date -j -f "%Y" "$date" +"%Y")

    temp_filename="${filename_without_ext}_optimized.jpg"

    # Convert the input file to .jpg using sips
    sips -s format jpeg -s formatOptions 80 "$file" --out "$temp_filename"

    folder_name="${OPTIMIZED_DIR}/${year}"

    # Resize the .jpg file to a maximum width of 2000 pixels, maintaining the aspect ratio
    # sips -Z 2000 "$temp_filename"

    mkdir -p "$folder_name"

    # Move the .jpg file to the destination directory
    mv "$temp_filename" "${folder_name}/${filename_without_ext}.jpg"
  fi
done

# rsync the optimized files 
rsync -rav --partial --remove-source-files "${OPTIMIZED_DIR}/." "${OUTPUT_DIR}/Optimized"

# rsync the raw, source files from memory card to NFS
rsync -rav --partial --archive --compress --omit-dir-times --remove-source-files "${PICTURES_DIR}" "${OUTPUT_DIR}/Source"

## uncomment the below for flat files
# find "." -type f \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.heic" \) -exec rsync -a --progress {} dschau@10.193.1.250:/media/Pictures/ \;

# Return to the original directory
popd > /dev/null
