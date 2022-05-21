#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# example usage for 16khz bit rate
# ./convert_mp3_folder_to_wav_and_convert_bitrate.sh ~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw/clips/ ~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_wav/ 16000
# see also https://stackoverflow.com/questions/13358287/how-to-convert-any-mp3-file-to-wav-16khz-mono-16bit


folder_to_get_audio_from="$1"
output_folder="$2"
bitrate="$3"

echo "Searching folder $folder_to_get_audio_from for .mp3 files, converting them to .wav with bitrate $bitrate, outputting to $output_folder (directory will be created if it doesn't exist)"
mkdir -p -v "$output_folder"
#
#find "$folder_to_get_audio_from" -type f -name "*.mp3"| parallel --bar echo {} "$bitrate" "$output_folder/"{/.}.wav


find "$folder_to_get_audio_from" -type f -name "*.mp3"| parallel --bar ffmpeg -i {} -ac 1 -ar "$bitrate" "$output_folder/"{/.}.wav

