#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
export CLEARML_PROJECT_NAME="" # add your ClearML project name
export CLEARML_OUTPUT_URI="s3://something" # add your bucket name
# first activate shiba environment! 


data_id="$1"
working_dir="$2"


shiba_path="/home/cleong/projects/personal/shiba-model/shiba/training/"



# get the clearml data
input_data="$working_dir/$data_id"

clearml-data get --id "$data_id" --copy "$input_data" 
echo "*************"
echo "input dataset:"
ls -alh "$input_data"
head -n 1 "$input_data/train.txt"

# we get the 5th line of t clearml-data search with sed -n 5p
# then we split on "|" characters and print the second item, which is the dataset name
# then we strip leading and trailing whitespace
old_name=$(clearml-data search --id "$data_id"|sed -n 5p |awk -F "|" '{print $2}'|sed 's/^[ \t]*//;s/[ \t]*$//')
new_name="$old_name""_jsonl"
echo "Name of new dataset will be $new_name"
output_data="$working_dir/$new_name"
echo "output dir will be $output_data"
mkdir -p "$output_data"

# to_examples
cd "$shiba_path"
# find "$input_data" -name "*.txt" |parallel echo "{}" "$output_data/{/.}.jsonl"
find "$input_data" -name "*.txt" |parallel python to_examples.py --input_data "{}" --output_data "$output_data/{/.}.jsonl"

cd $output_data
clearml-data create --project "$CLEARML_PROJECT_NAME" --name "$new_name"
clearml-data add --files ./* 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
