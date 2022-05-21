import epitran
import pathlib
import tqdm
from argparse import ArgumentParser
from pathlib import Path

# don't forget: pip install epitran


def transliterate_file(input_file, output_file, language_script):
    print(f"running epitran on {input_file}, outputting to {output_file}")
    input_contents = input_file.read_text().split("\n")
    transliterations = []
    epi = epitran.Epitran(language_script)
    for line in tqdm.tqdm(input_contents):
        transliterations.append(epi.transliterate(line))

    output_string = "\n".join(transliterations)
    output_file.write_text(output_string)


if __name__ == "__main__":
    # /home/cleong/projects/data/ALFFA/data_broadcastnews_sw/data/train/text
    # /home/cleong/projects/data/ALFFA/data_broadcastnews_sw/data/test/text
    # /home/cleong/projects/data/ALFFA/ALFFA_epitran

    parser = ArgumentParser()
    parser.add_argument("input_folder", type=Path, help="Will look for .txt files here")
    parser.add_argument(
        "output_folder", type=Path, help="where to put the data in .txt form"
    )
    parser.add_argument("language_script", type=str, default="swa-Latn", help="Which language code/script to use, e.g. swa-Latn. See https://github.com/dmort27/epitran for a list")
    args = parser.parse_args()

    # make the directory
    args.output_folder.mkdir(parents=True, exist_ok=True)

    # input_file = pathlib.Path('/home/cleong/projects/data/ALFFA/data_broadcastnews_sw/data/train/text')
    # output_file = pathlib.Path("/home/cleong/projects/data/ALFFA/ALFFA_epitran/train.txt")

    input_files = args.input_folder.glob("**/*.txt")

    for input_file in input_files:
        output_file = args.output_folder / input_file.name
        transliterate_file(input_file, output_file, args.language_script)
