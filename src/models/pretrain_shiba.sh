#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset


export CLEARML_PROJECT_NAME="" # add your ClearML project name
export CLEARML_OUTPUT_URI="s3://something" # add your bucket name
export CLEARML_QUEUE_NAME="" # add which queue to use, e.g. 40gb_queue 
export clearml_training_set="$1"
export clearml_validation_set="$2"



# The following line from https://erictleung.com/conda-in-subshell-script, lets you run conda activate.
eval "$(conda shell.bash hook)"
conda activate shiba


max_steps=300000
SEED="$3"

#BATCH_SIZE=32 # Cuda OOM on the large GPU
#BATCH_SIZE=16 # works on the large GPU
#BATCH_SIZE=22 # works on the large GPU, 83% memory usage
BATCH_SIZE=26 # works on the large GPU, 97% memory usage. Good enough!

# where is our forked version of Shiba? 
shiba_path="/home/cleong/projects/personal/shiba-model/shiba/training/"
cd "$shiba_path"


export CLEARML_TASK_NAME="SHIBA, train='$clearml_training_set', val='$clearml_validation_set', steps=$max_steps, seed=$SEED"
python train.py \
--clearml_training_set "$clearml_training_set" \
--clearml_validation_set "$clearml_validation_set" \
--clearml_project_name "$CLEARML_PROJECT_NAME" \
--clearml_task_name "$CLEARML_TASK_NAME" \
--clearml_output_uri "$CLEARML_OUTPUT_URI" \
--clearml_queue_name "$CLEARML_QUEUE_NAME" \
--logging_steps 50 \
--max_steps "$max_steps" \
--evaluation_strategy steps \
--save_strategy steps \
--eval_steps 500 \
--save_steps 500 \
--learning_rate 0.0004 \
--adam_beta2 0.98 \
--adam_epsilon 1e-06 \
--dropout 0.1 \
--weight_decay 0.01  \
--masking_type rand_span \
--gradient_accumulation_steps 6 \
--per_device_eval_batch_size "$BATCH_SIZE" \
--per_device_train_batch_size "$BATCH_SIZE" \
--output_dir "./shiba_outputs/" \
--report_to "tensorboard" \
--seed "$SEED" \
--load_best_model_at_end true \
