# Phone-ing it in: Towards Flexible, Multi-Modal Language Model Training using Phonetic Representations of Data 


Scripts and code used in the research paper [Phone-ing it in: Towards Flexible Multi-Modal Language Model Training by Phonetic Representations of Data](https://openreview.net/forum?id=cBDrOuONuhl). 

See also, our fork of MasakhaNER benchmark converted to phonetic representation at [this github repo](https://github.com/cdleong/masakhane-ner).

Currently working to clean/upload. 


# The Pipeline: steps from data to F1 score. 

Overall the process was thus: 
* created various pretraining datasets using Bash, [Epitran](https://github.com/dmort27/epitran) for text data, and [Allosaurus](https://github.com/xinjli/allosaurus) for audiio data. With and without phonemization, with and without spaces, etc. Most such scripts can be found in src/data
* pretrained SHIBA models using the datasets, enqueueing the pretraining runs using our ClearML server on a local compute cluster. These scripts can be found in src/models. 
* finetuned on [our variations on MasakhaNER](https://github.com/cdleong/masakhane-ner), mostly using Google Colab Pro notebooks. Copies of these notebooks can be found at src/models as well. 



### Data Preprocessing

Using our scripts, created a variety of training and test sets, taking various base sets and creating phonemized variations, with or without spaces, etc. 

For a detailed listing including a number of processing details see [this list](dataset_list.md)

### Scripts
Various scripts used for data processing

#### Processing audio data to phones. 
* [convert_mp3_folder_to_wav_and_convert_bitrate.sh](src/data/convert_mp3_folder_to_wav_and_convert_bitrate.sh) used to convert mp3 files to .wav with expected bitrate for allosaurus. We used this for Common Voice. 
* [break_folder_into_subsets.sh](src/data/break_folder_into_subsets.sh) used to break massive Common Voice dataset into a number of smaller folders each with a more manageable number of files in it. 
* [phonemize_audio_data.sh](src/data/phonemize_audio_data.sh), used to run phone recognition on ALFFA Swahili dataset. 
* [run_allosaurus_on_common_voice.sh](src/data/run_allosaurus_on_common_voice.sh) script for running allosaurus on common voice. Requires conversion to .wav first. Very similar to the one above, mostly just adapted to different folder structure and to convert one split at a time. Includes some notes on the process, including errors that resulted in only converting 205/258 subfolders. We had split the training set into 258 subfolders, each with a maximum of 2k files. setup a loop to go through the various "train" subfolders, e.g. train1, train2. Did 204/258 of them before the process failed, decided to move on due to time constraints to dev/test sets, which we converted without incident.
* Phone inventories: used in the phone recognition process so that we can be sure that allosaurus/epitran output the same symbols. 
    * [Allosaurus `swh`](src/data/allosaurus_swh_phone_inventory.txt) the original Allosaurus phone inventory for Swahili.
    * [Epitran `swa-Latn`](src/data/epitran_swa-Latn_phones.txt) Original Epitran phone inventory for Swahili.
    * [Epitran `kin-Latn`](src/data/epitran_kin-Latn_phones.txt) Original Epitran phone inventory for Kinyarwanda.
* [remove_spaces_recursively_from_text_files_in_folder.sh](src/data/remove_spaces_recursively_from_text_files_in_folder.sh) allosaurus outputs a space between each phone. We remove these. 

#### Text Data: Pre-cleaning ALFFA "gold" transcriptions. 

* [clean_ALFFA_gold_transcriptions.sh](src/data/clean_ALFFA_gold_transcriptions.sh) ALFFA dataset audio files came paired with already-created transcriptions we call "gold" transcriptions. We had to do some editing/preprocessing to these. 

#### Text Data: Grapheme to Phoneme
We converted several datasets of text/graphemes to phones. ALFFA gold transcriptions, Huggingface "Swahili language modeling" set, etch. 
* [phonemize_masakhaNER_data.py](src/data/phonemize_masakhaNER_data.py) used to convert MasakhaNER dataset to phones. 
* [phonemize_text_data.py](src/data/phonemize_text_data.py) For phonemizing other datasets using epitran. 
* [prepare_hf_swahili_datasets.py](src/data/prepare_hf_swahili_datasets.py) used for preparing the Swahili Language Modeling dataset downloaded from HuggingFace. 

#### Convert MasakhaNER to character-based annotations. 
* [split_masakhaNER_into_characters.py](src/data/split_masakhaNER_into_characters.py) used to create [our variations on MasakhaNER](https://github.com/cdleong/masakhane-ner), with per-character annotations.

#### Converting datasets to Shiba-compatible jsonlines format
* [create_shiba_version_of_dataset.sh](src/data/create_shiba_version_of_dataset.sh) shows how to create a .jsonl file for SHIBA pretraining and upload it to ClearML

#### Processed Dataset Samples: 

### Language Model Pretraining
* [pretrain_shiba.sh](src/models/pretrain_shiba.sh) shows how to kick off a SHIBA pretraining with ClearML, and has some details on arguments. Uses a slightly forked version of SHIBA at https://github.com/cdleong/shiba.git
* [enqueue_shiba_experiments.sh](src/models/enqueue_shiba_experiments.sh) used to conveniently queue up experiments on ClearML by passing arguments to pretrain_shiba.sh above. 
* Scripts for downloading the correct datasets inside ClearML jobs
    * [download_local_copy_of_clearml_dataset.py](src/data/download_local_copy_of_clearml_dataset.py)
    * [download_local_copy_of_clearml_dataset_using_id.py](src/data/download_local_copy_of_clearml_dataset_using_id.py)

### MasakhaNER Fine-tuning
Experiments used Google Colab Pro+ for fine-tuning, as well as ClearML for tracking. Adapting these for use outside of that environment is left as an exercise to the reader. 
* [shiba_fine_tuning_with_clearml_no_pretrained_model_on_Colab.ipynb](src/models/shiba_fine_tuning_with_clearml_no_pretrained_model_on_Colab.ipynb) Colab notebook for finetuning SHIBA on MaskahaNER without a pretrained model, as a baseline.
* [shiba_fine_tuning_with_clearml_pretrained_model_on_Colab.ipynb](src/models/shiba_fine_tuning_with_clearml_pretrained_model_on_Colab.ipynb) Demonstrates how to load a pretrained SHBA model from ClearML, and finetune it on MasakhaNER. 
* [finetuning_and_training_metrics_in_Colab.ipynb](src/models/finetuning_and_training_metrics_in_Colab.ipynb). After training/finetuning is already completed, download metrics from ClearML. 



### Experimental Results
