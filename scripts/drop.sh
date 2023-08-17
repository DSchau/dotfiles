#!/usr/bin/env bash
#!/bin/bash

# Input folder where original files are stored
INPUT_FOLDER="$HOME/Movies/Drop/"
# Output folder where converted files will be stored
OUTPUT_FOLDER="$HOME/Movies/Home"

LOG_LEVEL="info"

# Ensure output folder exists
mkdir -p "$OUTPUT_FOLDER"

total_files=$(find "$INPUT_FOLDER" -type f -iname "*.mov" | wc -l | awk '{print $1}')

echo "Converting total of $total_files files"

# Iterate over all files in the input folder
find "$INPUT_FOLDER" -type f -iname "*.mov" | while read -r file; do
    # Extract the filename without the path or extension for naming the output file
    filename=$(basename -- "$file")
    filename_no_ext="${filename%.*}"

    ((current_file++))

    output_file="$OUTPUT_FOLDER/$filename_no_ext.mp4"
    progress="($current_file / $total_files)"
    
    # Convert the file to mp4 format using ffmpeg
    ffmpeg -y -nostdin -i "$file" "$output_file" -hide_banner -loglevel $LOG_LEVEL
    
    # Check if the conversion was successful
    if [ $? -eq 0 ]; then
        echo "✅ $progress Converted $file to $output_file"
        # If the conversion was successful, delete the original file
        rm "$file"
    else
        # Optionally, print an error message if the conversion failed
        echo "❌ $progress Failed to convert $file"
    fi
done
