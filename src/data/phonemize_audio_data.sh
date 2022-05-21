#!/bin/bash
set -o errexit 
set -o pipefail
set -o nounset


# using epitran phone inventory
python -m allosaurus.bin.update_phone --lang swh --input epitran_swa-Latn_phones.txt

transliterate_with_allosaurus() {
    input_file=$1
    
    input_filename=$2
    output_folder=$3
    output_file=$4
    output="$(python -m allosaurus.run --lang swh -i $input_file)"
    text="$input_filename,$output"
    echo "$text" >> "$output_folder"/text.csv
    echo "$output" >> "$output_folder"/"$output_file"
}
export -f transliterate_with_allosaurus

export data_folder=/home/cleong/projects/data/ALFFA/data_broadcastnews_sw/data/test/wav5
export output_folder=/home/cleong/projects/data/ALFFA/allosaurus_transcriptions_with_epitran_inventory/test/
mkdir -p "$output_folder"
#export output_file="$output_folder"/test.txt
export output_file=test
#find "$data_folder" -name "*.wav" |parallel --bar -j1 python -m allosaurus.run --lang swh -i {} >> "$output_file"
find "$data_folder" -name "*.wav" |parallel --bar -j1 transliterate_with_allosaurus {} {/.} $output_folder $output_file


export data_folder=/home/cleong/projects/data/ALFFA/data_broadcastnews_sw/data/train/wav/
export output_folder=/home/cleong/projects/data/ALFFA/allosaurus_transcriptions_with_epitran_inventory/train
mkdir -p "$output_folder"
export output_file=train
#find "$data_folder" -name "*.wav" |parallel --bar -j1 python -m allosaurus.run --lang swh -i {} >> "$output_file"
find "$data_folder" -name "*.wav" |parallel --bar -j1 transliterate_with_allosaurus {} {/.} $output_folder $output_file

# restore original phone list. 
python -m allosaurus.bin.restore_phone --lang swh
