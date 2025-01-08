#!/bin/bash

# Check if the directory is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/directory"
  exit 1
fi

# Directory to search
directory_to_search="$1"

# Find all .m files in the directory and its subdirectories
echo "Searching for .m files in $directory_to_search..."
find "$directory_to_search" -type f -name "*.m"
echo "Searching for .h files in $directory_to_search..."
find "$directory_to_search" -type f -name "*.h"

# End of script