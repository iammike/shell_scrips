#!/bin/bash

# Function to read movie IDs from the CSV file
read_movie_ids() {
    local csv_file="$1"
    movie_ids=()
    while IFS=, read -r movie_id _; do
        # Skip the header line and any blank Movie IDs
        if [[ "$movie_id" != "Movie ID" && -n "$movie_id" ]]; then
            movie_ids+=("$movie_id")
        fi
    done < <(tail -n +2 "$csv_file")
}

# Function to search for movie IDs in files
search_files() {
    local directory="$1"
    local output_file="$2"
    > "$output_file" # Clear the output file

    # Create a pattern for grep to search for all movie IDs
    local pattern=$(printf "|%s" "${movie_ids[@]}")
    pattern=${pattern:1} # Remove the leading '|'

    # Recursively find all files in the directory and search for the pattern
    find "$directory" -type f | while read -r file; do
        grep -HnE "$pattern" "$file" | while IFS=: read -r filename lineno line; do
            for movie_id in "${movie_ids[@]}"; do
                if [[ "$line" == *"$movie_id"* ]]; then
                    echo "Movie ID: $movie_id, File: $(basename "$filename"), Line: $lineno" >> "$output_file"
                fi
            done
        done
    done
}

# Main script execution
main() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <directory_to_search>"
        exit 1
    fi

    script_dir=$(dirname "$0")
    csv_file="$script_dir/deployed_live_packages.csv"
    directory="$1"
    output_file="$script_dir/matches_output.txt"

    if [[ ! -f "$csv_file" ]]; then
        echo "CSV file not found in the script's directory."
        exit 1
    fi

    if [[ ! -d "$directory" ]]; then
        echo "The specified directory does not exist."
        exit 1
    fi

    read_movie_ids "$csv_file"
    search_files "$directory" "$output_file"
    echo "Search complete. Results are saved in $output_file"
}

main "$@"