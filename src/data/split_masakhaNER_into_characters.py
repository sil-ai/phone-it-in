#!/bin/bash
import pathlib
import tqdm

def word_to_characters(word, annotation):

        
    chars = [char for char in word]

    if annotation.startswith("B"):
        # only the first letter is "B", aka "beginning"
        # replace first letter with an I for most of them.
        inner_annotation = "I"+annotation[1:]
        
        # fill the rest of the char annotation list with I-whatever
        char_annotations = [inner_annotation]*len(chars) 
        
        # make sure to set the first one only to B-whatever
        char_annotations[0] = annotation
    else:
        # we can just fill it all with the same annotation. I-whatever, or O, applies to all the characters. 
        char_annotations = [annotation]*len(chars)   
        
    return chars, char_annotations
        

def desegment(input_file, output_file):
    '''
    We want to test out a character-based model and have the test be like the train. So we need to label each character. 
    wizaɾa B-ORG
    becomes
    w B-ORG
    i 
    z
    a
      ɾ
    a 
    '''
    print(f"desegmenting {input_file}, outputting to {output_file}")
    input_lines = input_file.read_text().splitlines()
    data = []
    for line in tqdm.tqdm(input_lines):
        if line == "":
            new_line = "\n"
            data.append(new_line)
        else:
            word, annotation = line.split()
            chars, char_annotations = word_to_characters(word, annotation)
            for char, char_annotation in zip(chars, char_annotations):
                
                new_line = f"{char} {char_annotation}" # TODO: fix this

                data.append(new_line)

        
    output_string="\n".join(data)
    output_file.write_text(output_string)


if __name__ == "__main__":
    
    #input_folder = pathlib.Path('/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/swa/')
    #output_folder = pathlib.Path('/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/swa_no_word_boundaries/')
    
    #input_folder = pathlib.Path('/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/swa_phonemes/')
    #output_folder = pathlib.Path('/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/swa_phonemes_no_word_boundaries/')
    
    #input_folder = pathlib.Path("/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/kin")
    #output_folder = pathlib.Path('/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/kin_no_word_boundaries/')

    #input_folder = pathlib.Path('/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/kin_phonemes/')
    #output_folder = pathlib.Path('/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/kin_phonemes_no_word_boundaries/')

    data_folder = pathlib.Path('/home/cleong/projects/personal/masakhane-ner-phonemized/masakhane-ner/data/')
    datasets_to_remove_word_boundaries_from = ["swa", "swa_phonemes", "kin", "kin_phonemes"]
    for dataset in datasets_to_remove_word_boundaries_from:
        input_folder = data_folder/dataset
        output_folder = data_folder/f"{dataset}_no_word_boundaries"
        output_folder.mkdir()

        for split in ["train", "dev", "test"]:
            input_file = input_folder/f"{split}.txt"
            output_file = output_folder/f"{split}.txt"
            desegment(input_file, output_file)
      
    
