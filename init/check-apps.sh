#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

apps_file="${SCRIPT_DIR}/applications.txt"

while IFS= read -r line
do
    app_name=$(echo "$line" | sed -e 's/#.*/ /g' | xargs) # trim whitespace, comments
    app_location="/Applications/$app_name"
    if [ ! -d "$app_location" ]; then
        echo "$app_name not installed. Please install it!"
    fi
done < "$apps_file"
