from argparse import ArgumentParser
from clearml import Dataset, Task
import shutil

# adding command line interface, so it is easy to use
parser = ArgumentParser()
parser.add_argument('--dataset_id', default='c99edb940826493397021da7c1c5a867', type=str, help='Dataset name to train on')
parser.add_argument('--copy_dest', default='./data/training_set', type=str, help='where to put another local copy')
args = parser.parse_args()

# creating a task, so that later we could override the argparse from UI
#task = Task.init(project_name='put your CLEARML_PROJECT_NAME here', task_name='dataset demo')

# getting a local copy of the dataset
dataset_folder = Dataset.get(dataset_id=args.dataset_id).get_local_copy()
print(dataset_folder)

# Put the darn thing in a known location
try: 
    shutil.copytree(dataset_folder, args.copy_dest)
except FileExistsError:    
    print(f"Directory already exists error when copying {dataset_folder} to {args.copy_dest}")
