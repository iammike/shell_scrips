#!/bin/zsh

# Check if the directory is provided
if [[ -z "$1" ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

directory="$1"

echo "----------------------------------------------------------------"


# Find all .m files and store in a list
files=()
while IFS= read -r -d $'\0' file; do
  files+=("$file")
done < <(find "$directory" -type f -name '*.m' -print0)

# Check if any .m files were found
if (( ${#files[@]} == 0 )); then
  echo "No .m files found in the specified directory."
  exit 0
fi

# Create a temporary file to store results
tmpfile=$(mktemp)

# Initialize total line count
total_lines=0

# Iterate over files, count lines and store in the temporary file
for file in "${files[@]}"; do
  line_count=$(wc -l < "$file")
  # Add to total line count
  total_lines=$((total_lines + line_count))
  # Store the relative path and line count in the temporary file
  relative_path="${file#$directory/}"
  echo "$line_count $relative_path" >> "$tmpfile"
done

# Sort the temporary file by line count in descending order and print
sort -nr "$tmpfile"

# Print delimiter line
echo "----------------------------------------------------------------"

# Print the total number of lines formatted like the others
printf "%8d TOTAL\n" "$total_lines"

# Clean up the temporary file
rm "$tmpfile"