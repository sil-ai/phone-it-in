# Adapted from https://huggingface.co/blog/how-to-train
import argparse
from pathlib import Path
from tokenizers import ByteLevelBPETokenizer #TODO: look into other tokenizers for Phonemes


def train_tokenizer_and_save_it(data_folder : Path, tokenizer_folder : Path, vocab_size=52_000):
    paths = [str(x) for x in Path(data_folder).glob("**/*.txt")]
    if not paths: 
        raise ValueError(f"Couldn't find txt files in data folder. Is the path to the folder correct? Path given: {args.data_folder}.")
    vocab_size = args.vocab_size
    tokenizer_folder = Path(tokenizer_folder)
    
    ############################
    # TOKENIZER
    print("found {len(paths)} files in data folder")
    print(f"saving tokenizer to {tokenizer_folder}")
    
    # TODO: don't train if you already did it. 
    if tokenizer_folder.is_dir():
        print("tokenizer already trained")
    else: 
        print("We should be training tokenizer")
    print("training tokenizer")
    # Initialize a tokenizer
    tokenizer = ByteLevelBPETokenizer()

    # Customize training
    tokenizer.train(files=paths, vocab_size=vocab_size, min_frequency=2, special_tokens=[
        "<s>",
        "<pad>",
        "</s>",
        "<unk>",
        "<mask>",
    ])

    p = tokenizer_folder
    p.mkdir(parents=True, exist_ok=True)
    tokenizer.save_model(str(tokenizer_folder))
    output_json = tokenizer_folder / "tokenizer.json"
    tokenizer.save(str(output_json)) 


if __name__== "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("data_folder", help="path to folder with .txt files in it.")
    parser.add_argument("tokenizer_folder", help="where to save the trained tokenizer to")    
    parser.add_argument("--vocab_size", type=int, default=52_000, help="tokenizer vocab size. Default 52,000")
    args = parser.parse_args()    
    
    print(args)
    
    train_tokenizer_and_save_it(args.data_folder, args.tokenizer_folder)
    