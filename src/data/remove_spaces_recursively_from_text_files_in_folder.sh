#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
input_folder="$1"
output_folder="$2"

echo "input folder is $input_folder, output folder is $output_folder"
mkdir -p "$output_folder"
replace_characters() {
    input_file="$1"
    output_file="$2"
    echo "removing spaces in $input_file, outputting to $output_file"
    sed 's/ //g' "$input_file" > "$output_file"
}
export -f replace_characters
# note: 
find "$input_folder" -name "*.txt" | parallel replace_characters {} "$output_folder"{/}
