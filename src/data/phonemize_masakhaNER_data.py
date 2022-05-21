#!/bin/bash
import epitran
import pathlib
import tqdm

# don't forget: pip install epitran


def phonemize_file(input_file, output_file, language_code):
    '''
    We want to test out a character-based model and have the test be like the train. So we need to label each character. 
    '''
    input_lines = input_file.read_text().splitlines()
    transliterations = []
    epi = epitran.Epitran(language_code)
    for line in tqdm.tqdm(input_lines):
        if line == "":
            new_line = ""
        else:
    
            word, annotation = line.split()
            phonemized_word = epi.transliterate(word)
            new_line = f"{phonemized_word} {annotation}"
        transliterations.append(new_line)

        
    output_string="\n".join(transliterations)
    output_file.write_text(output_string)


if __name__ == "__main__":
#    input_folder = pathlib.Path("/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/swa")
#    output_folder = pathlib.Path("/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/swa_phonemes")
#    language_code="swa-Latn"
    input_folder = pathlib.Path("/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/kin")
    output_folder = pathlib.Path("/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/kin_phonemes")
    language_code="kin-Latn"

    for split in ["train", "dev", "test"]:
        input_file = input_folder/f"{split}.txt"
        output_file = output_folder/f"{split}.txt"
        phonemize_file(input_file, output_file, language_code)
