#!/bin/bash

# Check if a directory argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory_to_search="$1"
output_file="output.csv"

# Write the CSV header
echo "File,Line Number,Content" > "$output_file"

# Search for the pattern in files under the specified directory
find "$directory_to_search" -type f | while read -r file; do
    grep -HnE '\bXCTAssert(True|False|Nil|NotNil)\b[^,]*$' "$file" | while IFS=: read -r filename lineno content; do
        # Remove the initial directory portion from the filename
        relative_filename="${filename#$directory_to_search/}"
        
        # Escape double quotes in content for CSV formatting
        content=$(echo "$content" | sed 's/"/""/g')
        
        echo "\"$relative_filename\",\"$lineno\",\"$content\"" >> "$output_file"
    done
done

echo "Results have been written to $output_file"