#!/bin/bash -x
set -o errexit
set -o pipefail
set -o nounset
# based on https://stackoverflow.com/questions/29116212/split-a-folder-into-multiple-subfolders-in-terminal-bash-script
# heavily edited, and used shellcheck to rewrite some of it. 


folder_to_split="$1"
dir_size="$2"
dir_name="$3"
cd "$folder_to_split"
echo "now in $PWD"
n=$(($(find . -maxdepth 1 -type f | wc -l)/dir_size+1))
echo "n is $n"

for i in $(seq 1 $n);
do
    subdir="$dir_name$i"
    echo "creating subdir $subdir"
    # find . -maxdepth 1 -type f | tail -n 3
    mkdir -p "$subdir"
    find . -maxdepth 1 -type f | tail -n "$dir_size" | parallel --bar -N 20 mv "{}" "$subdir"
    # find . -maxdepth 1 -type f | head -n "$dir_size" | wc -l
    # find . -maxdepth 1 -type f | head -n "$dir_size" 
done
