#!/bin/bash
set -o errexit 
set -o pipefail
set -o nounset




# using epitran phone inventory
python -m allosaurus.bin.update_phone --lang kin --input epitran_kin-Latn_phones.txt


python -m allosaurus.bin.list_phone --lang kin


transliterate_with_allosaurus() {
    input_file=$1    
    input_filename=$2
    output_folder=$3
    output_file=$4
    output="$(python -m allosaurus.run --lang kin -i $input_file)"
    text="$input_filename,$output"
    echo "$text" >> "$output_folder"/text.csv
    echo "$output" >> "$output_folder"/"$output_file".txt
}
export -f transliterate_with_allosaurus


transliterate_folder() {
    data_folder="$1"
    output_folder="$2"
    output_file="$3"
    mkdir -p "$output_folder"
    echo "running allosaurus on .wav files in $data_folder"
    echo "output_folder is $output_folder"
    echo "output_file name is $output_file"
    find "$data_folder" -name "*.wav" |parallel --bar -j1 transliterate_with_allosaurus {} {/.} $output_folder $output_file
}
export -f transliterate_folder


# export data_folder=~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_wav/train/
# export output_folder=/home/cleong/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_allosaurus/train/
# mkdir -p "$output_folder"
# export output_file=train
# find "$data_folder" -name "*.wav" |parallel --bar -j1 transliterate_with_allosaurus {} {/.} $output_folder $output_file

# We had split the training set into 258 subfolders, each with a maximum of 2k files.
# setup a loop to go through the various "train" subfolders, e.g. train1, train2. 
# Did 204/258 of them before the process failed on 2021-8-6, decided to move on to dev/test sets 
#find ~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_wav/train/ -mindepth 1 -type d| parallel --bar -j1 transliterate_folder {} /home/cleong/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_allosaurus/train/{/} train


# Dev Set done 2021-8-6
#export data_folder=~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_wav/dev/
#export output_folder=/home/cleong/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_allosaurus/dev/
#mkdir -p "$output_folder"
#export output_file=dev
#find "$data_folder" -name "*.wav" |parallel --bar -j1 transliterate_with_allosaurus {} {/.} $output_folder $output_file


# Test Set
export data_folder=~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_wav/test/
export output_folder=/home/cleong/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_allosaurus/test/
mkdir -p "$output_folder"
export output_file=test
find "$data_folder" -name "*.wav" |parallel --bar -j1 transliterate_with_allosaurus {} {/.} $output_folder $output_file

# # restore original phone list. 
python -m allosaurus.bin.restore_phone --lang kin
