#!/usr/bin/env bash

# this will be used for iCloud Photos
OPTIMIZED_DIR="/Users/dustinschau/Pictures/Optimized"
OUTPUT_DIR="${MEDIA_DIR}/Pictures"

rsync -rav --progress --partial "${PICTURES_DIR}" "${OUTPUT_DIR}/Source"

mkdir -p "${OPTIMIZED_DIR}"

# cd to source directory
pushd "${PICTURES_DIR}" > /dev/null

find "." -type f \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.heic" -o -iname "*.arw" \) -print0 | while IFS= read -r -d $'\0' file
do
  full_filename=$(basename "$file")
  filename="${full_filename%.*}"

  # add your logic here, $file variable contains the filename
  date=$(exiftool -DateTimeOriginal -s -s -s "$file" | awk '{print $1}')
  year=$(date -j -f "%Y" "$date" +"%Y")

  # Use the date and city name to form the new filename
  base_filename=$(echo "${date} ${city}" | xargs)

  temp_filename="${filename}_optimized.jpg"

  # Convert the .heic file to .jpg using sips
  sips -s format jpeg -s formatOptions 80 "$file" --out "$temp_filename"

  folder_name="${OPTIMIZED_DIR}/${year}"

  # Resize the .jpg file to a maximum width of 2000 pixels, maintaining the aspect ratio
  # sips -Z 2000 "$temp_filename"

  mkdir -p "$folder_name"

  # Move the .jpg file to the destination directory
  mv "$temp_filename" "${folder_name}/${filename}.jpg"
done

# rsync the optimized files 
rsync -rav --progress --partial "${OPTIMIZED_DIR}/." "${OUTPUT_DIR}/Optimized"
## uncomment the below for flat files
# find "." -type f \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.heic" \) -exec rsync -a --progress {} dschau@10.193.1.250:/media/Pictures/ \;

# Return to the original directory
popd > /dev/null
