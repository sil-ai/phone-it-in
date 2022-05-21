#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
export CLEARML_PROJECT_NAME="" # add your ClearML project name
export CLEARML_OUTPUT_URI="s3://something" # add your bucket name

data_id_1="$1"
data_id_2="$2"
new_name="$3"
working_dir="$4"

input_folder_1="$working_dir/$data_id_1"
input_folder_2="$working_dir/$data_id_2"
output_folder="$working_dir/$new_name"



# clearml-data 
clearml-data get --id "$data_id_1" --copy "$input_folder_1"
clearml-data get --id "$data_id_2" --copy "$input_folder_2"


echo "In working dir $working_dir, combining files from $input_folder_1 and $input_folder_2, outputting to $output_folder"

mkdir -p -v "$output_folder"

append_to_file() {
    cat "$1" >> "$2"
    # input_lines=$(wc -l "$1")
    # output_lines=$(wc -l "$2")
    # echo "appended $1 to $2"
    # echo "input had $input_lines lines" 
    # echo "output now has $output_lines lines"
}

export -f append_to_file

find "$input_folder_1" -type f | parallel append_to_file "{}" "$output_folder/{/}"
find "$input_folder_2" -type f | parallel append_to_file "{}" "$output_folder/{/}"

echo "*************"
echo "input_folder 1:"
ls -alh "$input_folder_1"

echo "*************"
echo "input_folder 2:"
ls -alh "$input_folder_2"

echo "*************"
echo "output folder:"
ls -alh "$output_folder"


cd "$working_dir"
clearml-data create --project "$CLEARML_PROJECT_NAME" --name "$new_name"
clearml-data add --files ./* 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"

echo "train head and tail"
head -n 1 "$output_folder/train.txt"
tail -n 1 "$output_folder/train.txt"