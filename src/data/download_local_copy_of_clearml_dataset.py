from argparse import ArgumentParser
from clearml import Dataset, Task
import shutil

CLEARML_PROJECT_NAME="" # add your ClearML project name

# adding command line interface, so it is easy to use
parser = ArgumentParser()
parser.add_argument('--dataset', default='sw_wiki_with_tokenizer_and_config', type=str, help='Dataset name to train on')
parser.add_argument('--copy_dest', default='~/data/sw_wiki_with_tokenizer_and_config', type=str, help='where to put another local copy')
args = parser.parse_args()


# getting a local copy of the dataset
dataset_folder = Dataset.get(dataset_name="sw_wiki_with_tokenizer_and_config", dataset_project=CLEARML_PROJECT_NAME).get_local_copy()
print(dataset_folder)

# Put the darn thing in a known location
try: 
    shutil.copytree(dataset_folder, args.copy_dest)
except FileExistsError:    
    print(f"Directory already exists error when copying {dataset_folder} to {args.copy_dest}")
