from argparse import ArgumentParser
from pathlib import Path
from datasets import load_dataset
import epitran
import random
from tokenizers.pre_tokenizers import Split

def transliterate(example):
    epi = epitran.Epitran("swa-Latn")
    unk_splitter = Split("UNK", behavior="isolated")
    text_sections = unk_splitter.pre_tokenize_str(example["text"]) # returns tuples, containing text and spans in original. 
    transliterated = ""
    for text_section in text_sections:
        if "UNK" not in text_section:
            transliterated = transliterated + epi.transliterate(text_section[0])
        else:
            transliterated = transliterated+"UNK"
    example["text"] = transliterated
    return example


def prepare_dataset(dataset, output_folder):
    splitnames = ["train", "test", "validation"]
    for splitname in splitnames:
        out_file_name = splitname + ".txt"
        out_file = output_folder / out_file_name
        dataset_split = dataset[splitname]
        with open(out_file, 'a') as f:
            for example in dataset_split:
                text = example["text"] + "\n"
                f.write(text)

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        "output_folder", type=Path, help="where to put the data in .txt form"
    )
    args = parser.parse_args()

    dataset_out_folder = args.output_folder / "hf_swahili"
    epitran_out_folder = args.output_folder / "hf_swahili_epitran"
    dataset_out_folder.mkdir(parents=True, exist_ok=True)
    epitran_out_folder.mkdir(parents=True, exist_ok=True)

    dataset = load_dataset("swahili")
    """
    DatasetDict({
    train: Dataset({
        features: ['text'],
        num_rows: 42069
    })
    test: Dataset({
        features: ['text'],
        num_rows: 3371
    })
    validation: Dataset({
        features: ['text'],
        num_rows: 3372
    })
    })
    """
    prepare_dataset(dataset, dataset_out_folder)

    transliterated_dataset = dataset.map(transliterate)
    prepare_dataset(transliterated_dataset, epitran_out_folder)
