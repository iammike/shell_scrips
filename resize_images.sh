#!/bin/bash

###############################################################################
# This script reduces the quality of an image to target filesize.             #
#                                                                             #
# It is important to note this will not resize an image; for my use-case,     #
# first reducing the image's dimensions via Finder's right-click ->           #
# Quick Actions -> Convert Image -> Image Size set to Large provides a good   #
# starting point for this script to then lower the quality on.                #
###############################################################################

# Check if the input folder and file size are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 path/to/input/folder max_filesize"
    exit 1
fi

input_folder="$1"
max_filesize="$2"
output_folder="$input_folder/output"

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it to use this script."
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_folder"

# Process each image in the input folder
for file in "$input_folder"/*.{jpg,jpeg,png}; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        output_file="$output_folder/$filename"

        # Use ImageMagick to resize the image
        magick "$file" -define jpeg:extent="$max_filesize" "$output_file"

        echo "Processed $filename"
    fi
done