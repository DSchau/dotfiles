#!/usr/bin/env bash
#!/bin/bash

# Input folder where original files are stored
INPUT_FOLDER="$HOME/Movies/Drop/"
# Output folder where converted files will be stored
OUTPUT_FOLDER="$HOME/Movies/Home"

# Ensure output folder exists
mkdir -p "$OUTPUT_FOLDER"

# Iterate over all files in the input folder
find "$INPUT_FOLDER" -type f | while read -r file; do
    # Extract the filename without the path or extension for naming the output file
    filename=$(basename -- "$file")
    filename_no_ext="${filename%.*}"
    
    # Convert the file to mp4 format using ffmpeg
    ffmpeg -i "$file" "$OUTPUT_FOLDER/$filename_no_ext.mp4" -hide_banner -loglevel error
    
    # Check if the conversion was successful
    if [ $? -eq 0 ]; then
        # If the conversion was successful, delete the original file
        rm "$file"
    else
        # Optionally, print an error message if the conversion failed
        echo "Failed to convert $file"
    fi
done
