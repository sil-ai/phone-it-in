#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

clean_ALFFA_file_in_place() {
    input_file="$1"
    temp_file="/tmp/temp_ALFFA_file"
    # take out the first column
    cat "$input_file" |awk '{$1=""}1'|awk '{$1=$1}1' > "$temp_file"
    
    # remove <UNK> and <music> and <laughter>, in-place
    # https://stackoverflow.com/questions/10206337/how-do-i-remove-all-lines-matching-a-pattern-from-a-set-of-files
    sed -i -e 's/<.*>//g' "$temp_file"
    
    # remove empty lines: https://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed
    sed -i '/^[[:space:]]*$/d' "$temp_file"
    
    # Rather than transcripts, some lines have filenames, e.g. SWH-15-20101130_16k-emission_swahili_15h00_-_16h00_tu_20101130_part273	16k-emission_swahili_15h00_-_16h00_tu_20101130_part273
    # we remove those. 
    sed -i -e 's/16k-emission//g' "$temp_file"
    
    # somethings <music> was at the beginning or end of a line, so remove leading/trailing whitespace
    # https://www.cyberciti.biz/tips/delete-leading-spaces-from-front-of-each-word.html
    sed -i 's/^[ \t]*//;s/[ \t]*$//g' "$temp_file"
    
    # overwrite the input file
    cat "$temp_file" > "$input_file"
    
}

original_ALFFA_folder="$1"  # example: /home/cleong/projects/data/ALFFA/data_broadcastnews_sw/
output_folder="$2"

mkdir -p -v "$output_folder"

train_file="$original_ALFFA_folder/data/train/text"
test_file="$original_ALFFA_folder/data/test/text"

cp -v "$train_file" "$output_folder/train.txt"
cp -v "$test_file" "$output_folder/test.txt"

clean_ALFFA_file_in_place "$output_folder/train.txt"
clean_ALFFA_file_in_place "$output_folder/test.txt"
