#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

# SEED=42
# SEED=420
# SEED=314
# SEED=7
# SEED=666
# SEED=365
SEED=777


# Fixed version, with spaces removed. 
train_set="ALFFA_allosaurus_transcriptions_with_epitran_inventory_no_spaces_jsonl"
dev_set="hf_swahili_epitran_no_spaces_jsonl"
./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"

# Fixed combined HF Swahili plus alffa allosaurus, with spaces removed. 
train_set="hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed_jsonl"
dev_set="hf_swahili_epitran_no_spaces_jsonl"
./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"

# # Kinyarwanda Common voice phones from epitran
# train_set="common_voice_rw_epitran_no_spaces_jsonl"
# dev_set="common_voice_rw_epitran_no_spaces_jsonl"
# ./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"


# # Kinyarwanda Common Voice phones
# train_set="rw_allosaurus_204_of_258_train_jsonl"
# dev_set="rw_allosaurus_204_of_258_train_jsonl"
# ./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"

# # Audio only
# train_set="ALFFA_allosaurus_transcriptions_with_epitran_inventory_jsonl"
# dev_set="hf_swahili_epitran_no_spaces_jsonl"
# ./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"




# # # Normal word data, but without spaces
# train_set="hf_swahili_no_spaces_jsonl"
# dev_set="hf_swahili_no_spaces_jsonl"
# ./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"

# train_set="hf_swahili_plus_alffa_gold_no_word_boundaries_jsonl"
# dev_set="hf_swahili_no_spaces_jsonl"
# ./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"

# # # EPITRAN EXPERIMENTS
# # hf_swahili_epitran_no_spaces_jsonl
# train_set="hf_swahili_epitran_no_spaces_jsonl"
# dev_set="hf_swahili_epitran_no_spaces_jsonl"
# ./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"

# # hf_swahili_epitran_plus_alffa_gold_epitran_no_word_boundaries_jsonl
# train_set="hf_swahili_epitran_plus_alffa_gold_epitran_no_word_boundaries_jsonl"
# dev_set="hf_swahili_epitran_no_spaces_jsonl"
# ./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"


# # ALLOSAURUS
# #hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_jsonl
# train_set="hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_jsonl"
# dev_set="hf_swahili_epitran_no_spaces_jsonl"
# ./pretrain_shiba.sh "$train_set" "$dev_set" "$SEED"


