# Datasets: 

Details of dataset processing for most of the dataset variations we created. Not all of which were used. 

## Swahili Wikipedia (c99edb940826493397021da7c1c5a867). 

Used https://www.kdnuggets.com/2017/11/building-wikipedia-text-corpus-nlp.html primarily. 
Pulled Swahili-language Wikipedia on 2021-06-01T1617EDT. 

Other guides: 
* https://towardsdatascience.com/pre-processing-a-wikipedia-dump-for-nlp-model-training-a-write-up-3b9176fdf67, ran into various issues with this one, paths not being right, custom regexes are weird, etc. 
* https://medium.com/ai-quest/pre-trained-language-model-in-any-language-7531ea7217d4 I did not try, but they use Vietnamese


## ALFFA "gold" transcripts, with tokenizer and config (7e469acb926345dbaded2b7f372a602a). 
Some minimal cleaning done. 

### Version with just training set: 7e469acb926345dbaded2b7f372a602a 
```
# remove first column with filenames. Command taken from https://stackoverflow.com/questions/32812916/how-to-delete-the-first-column-which-is-in-fact-row-names-from-a-data-file-in#32814062
cat text |awk '{$1=""}1'|awk '{$1=$1}1' > text_without_first_column

cp text_without_first_column text_cleaned

# remove <UNK> and <music> and <laughter>
# https://stackoverflow.com/questions/10206337/how-do-i-remove-all-lines-matching-a-pattern-from-a-set-of-files
sed -i -e 's/<.*>//g' text_cleaned

# remove leading whitespace. 
# https://unix.stackexchange.com/questions/339266/removing-the-first-space-in-a-line
sed -i 's/ //' text_cleaned

# remove empty lines: https://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed
sed -i '/^[[:space:]]*$/d' text_cleaned


# Rather than transcripts, some lines have filenames, e.g. SWH-15-20101130_16k-emission_swahili_15h00_-_16h00_tu_20101130_part273	16k-emission_swahili_15h00_-_16h00_tu_20101130_part273
# we remove those. 
sed -i -e 's/16k-emission//g' text_cleaned

mv text_cleaned train.txt

python train_tokenizer_and_save_it.py ~/projects/personal/colin-summer-2021/data/intermediate/ALFFA_gold_transcripts_cleaned/ ~/projects/personal/colin-summer-2021/data/processed/ALFFA_gold_transcripts_with_tokenizer_and_config/

cp ~/projects/personal/colin-summer-2021/data/intermediate/ALFFA_gold_transcripts_cleaned/train.txt ~/projects/personal/colin-summer-2021/data/processed/ALFFA_gold_transcripts_with_tokenizer_and_config/

# from the root dir of the repo
# copy the standard model config we've been using for training. 
cp -v config/config.json data/processed/ALFFA_gold_transcripts_with_tokenizer_and_config/

# upload to ClearML
cd data/processed/ALFFA_gold_transcripts_with_tokenizer_and_config/
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_gold_transcripts_with_tokenizer_and_config
clearml-data add --files * 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
# Dataset ID was 7e469acb926345dbaded2b7f372a602a
   
```

### ALFFA Gold Transcripts Version 2, including both train and test, cleaned with clean_ALFFA_gold_transcriptions.sh (00d248a36a4948639cea019d8cb3eb61)

Following the steps above, created a script, `clean_ALFFA_gold_transcriptions.sh`, included in this repo at src/data/. This time, included both train and test, as .txt files. 

Then uploaded to ClearML: 

```
cd /home/cleong/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_v2
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_gold_transcripts_cleaned_v2
clearml-data add --files * 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

output of clearml-data list
```
clearml-data - Dataset Management & Versioning CLI
List dataset content: 00d248a36a4948639cea019d8cb3eb61
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    113,606 | f4c2480eb6ecb3ad734b2e601fef92a82f320cc8f794f63039735cc486b50c30
train.txt                                                        |    581,151 | 4361c0a14faadfd4536336770eb3353b7af0332ada7776064ecfa5bfb7b8b844
```

small sample: 
```
head train.txt 
rais wa tanzania jakaya mrisho kikwete
yanayo andaliwa nami pendo pondo idhaa ya kiswahili
inayokutangazia moja kwa moja kutoka jijini dar es salaam tanzania
juma hili bara la afrika limeshuhudia raia wa nchi za niger
wakipiga kura ya maoni ilikufanya mabadiliko ya
kule abidjan raia wa jiji hilo
walipata fursa ya kutumia haki yao ya msingi
waziri mkuu wa zamani alasane watara
na rais aliyetangulia henry konan berdi
walichuana vikali na rais lauren bagbo
```

## ALFFA Gold cleaned Transcripts, epitran version (691ffbadc3fd425bae4d14d56e8486a8). 

Took the files from 00d248a36a4948639cea019d8cb3eb61, above. 

Then ran the following
```
# activate epitran conda environment
conda activate epitran
python phonemize_text_data.py ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_v2/ ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_epitran/
```

Then uploaded to clearml: 
```
cd ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_epitran/
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_gold_transcripts_cleaned_epitran
clearml-data add --files * 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

Output of clearml-data list: 
```
List dataset content: 691ffbadc3fd425bae4d14d56e8486a8
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    122,156 | 2be34812b361daec4e7646d745f2f29eb919f8a947aee5a9d642b45b4fd1d690
train.txt                                                        |    624,450 | 3e336ddb757347ac9dbf6815cfb28043e6a343d6d6e6f280cd03804a3e477675
Total 2 files, 746606 bytes
```

output of `head train.txt`
```
ɾais wa tanzania ʄakaja mɾiʃo kikwete
janajo andaliwa nami pendo pondo iðaa ja kiswahili
inajokutanɡazia moʄa kwa moʄa kutoka ʄiʄini ɗaɾ es salaam tanzania
ʄuma hili ɓaɾa la afɾika limeʃuhuɗia ɾaia wa nt͡ʃi za niɠeɾ
wakipiɠa kuɾa ja maoni ilikufaɲa maɓaɗiliko ja
kule aɓiɗʄan ɾaia wa ʄiʄi hilo
walipata fuɾsa ja kutumia haki jao ja msinɡi
waziɾi mkuu wa zamani alasane wataɾa
na ɾais alijetanɡulia henɾj konan ɓeɾɗi
walit͡ʃuana vikali na ɾais lauɾen ɓaɠɓo
```

## ALFFA gold transcripts, cleaned, epitran'd, no spaces (8101d11e76464ce0a7786997d538e662)

Used a script to remove all instances of the " " space character. See notes on 4376729e20ff43e1a17ee7da82ae81e6 dataset, below. 
```
./remove_spaces_recursively_from_text_files_in_folder.sh ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_epitran ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_epitran_no_spaces/
```

Then uploaded to ClearML: 
```
cd ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_epitran_no_spaces
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_gold_transcripts_cleaned_epitran_no_spaces
clearml-data add --files * 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

Output of clearml-data list: 
```
clearml-data - Dataset Management & Versioning CLI
List dataset content: 8101d11e76464ce0a7786997d538e662
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    106,447 | e2213b06ebaefad7f3d5a132f7a6dba52c1774d18066a30468c7b510791a46c3
train.txt                                                        |    543,590 | 5b5be11888609f9b716f011fbadd435e76c54e1f3045ca2b0f6a4b385716bc7c
Total 2 files, 650037 bytes

```

Output of `head train.txt`
```
ɾaiswatanzaniaʄakajamɾiʃokikwete
janajoandaliwanamipendopondoiðaajakiswahili
inajokutanɡaziamoʄakwamoʄakutokaʄiʄiniɗaɾessalaamtanzania
ʄumahiliɓaɾalaafɾikalimeʃuhuɗiaɾaiawant͡ʃizaniɠeɾ
wakipiɠakuɾajamaoniilikufaɲamaɓaɗilikoja
kuleaɓiɗʄanɾaiawaʄiʄihilo
walipatafuɾsajakutumiahakijaojamsinɡi
waziɾimkuuwazamanialasanewataɾa
naɾaisalijetanɡuliahenɾjkonanɓeɾɗi
walit͡ʃuanavikalinaɾaislauɾenɓaɠɓo
```
## ALFFA gold transcripts, cleaned, no spaces (20a6fea6173f49d7b43441afcc9f432b)
For completeness, took the files from 00d248a36a4948639cea019d8cb3eb61 and ran 
```
./remove_spaces_recursively_from_text_files_in_folder.sh ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_v2/ ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_no_spaces/
```

Then uploaded to ClearML: 
```
cd ~/projects/data/ALFFA/ALFFA_gold_transcripts_cleaned_no_spaces/
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_gold_transcripts_cleaned_no_spaces
clearml-data add --files * 
clearml-data list 
head train.txt
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

Output of clearml-data list: 
```
List dataset content: 20a6fea6173f49d7b43441afcc9f432b
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |     97,897 | 253bce3d7f80220cf03d15ef70959666aab1aac1d48193c00769b0b6aac7e29a
train.txt                                                        |    500,291 | 335928e616523c5aa47ad1a9f3d0ee99976f69e3e828a3ef5eb64f5cd9170077

```

Output of `head train.txt`
```
raiswatanzaniajakayamrishokikwete
yanayoandaliwanamipendopondoidhaayakiswahili
inayokutangaziamojakwamojakutokajijinidaressalaamtanzania
jumahilibaralaafrikalimeshuhudiaraiawanchizaniger
wakipigakurayamaoniilikufanyamabadilikoya
kuleabidjanraiawajijihilo
walipatafursayakutumiahakiyaoyamsingi
wazirimkuuwazamanialasanewatara
naraisaliyetanguliahenrykonanberdi
walichuanavikalinaraislaurenbagbo
```

## (outdated) Combined SW Wikipedia and ALFFA Gold transcripts, with tokenizer and config (22a8a8311806484596ca27c1b9b0dff0)

Literally just concatenated the two files, and re-ran tokenization on it. 

```
# in ~/projects/personal/colin-summer-2021/data/processed
mkdir combined_sw_wiki_and_ALFFA_gold_transcripts
cat ALFFA_gold_transcripts_with_tokenizer_and_config/train.txt > combined_sw_wiki_and_ALFFA_gold_transcripts/train.txt
cat sw_wiki_with_tokenizer_and_config/train.txt >> combined_sw_wiki_and_ALFFA_gold_transcripts/train.txt

# head combined_sw_wiki_and_ALFFA_gold_transcripts/train.txt shows that it consists of data from the transcriptions. 
# tail combined_sw_wiki_and_ALFFA_gold_transcripts/train.txt shows that it consists of data from swahili wikipedia. 

cd ../../src/data/
python train_tokenizer_and_save_it.py ../../data/processed/combined_sw_wiki_and_ALFFA_gold_transcripts/ ../../data/processed/combined_sw_wiki_and_ALFFA_gold_transcripts/

# root folder of repo
cd ../..

# add in the training config
cp config/config.json data/processed/combined_sw_wiki_and_ALFFA_gold_transcripts/
```

After above, here's what's in the folder: 

```
$ ls -lh
total 50M
-rw-rw-r-- 1 cleong cleong  480 Jul  7 09:39 config.json
-rw-rw-r-- 1 cleong cleong 487K Jul  7 09:38 merges.txt
-rw-rw-r-- 1 cleong cleong 1.4M Jul  7 09:38 tokenizer.json
-rw-rw-r-- 1 cleong cleong  47M Jul  7 09:33 train.txt
-rw-rw-r-- 1 cleong cleong 832K Jul  7 09:38 vocab.json
```

And then we add it to clearML
```

cd data/processed/combined_sw_wiki_and_ALFFA_gold_transcripts/
clearml-data create --project "$CLEARML_PROJECT_NAME" --name combined_sw_wiki_and_ALFFA_gold_transcripts_with_tokenizer_and_config
clearml-data add --files * 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

## ALFFA phonemized with Allosaurus, using epitran inventory (0fa48149d7f745a0971e68b0b611e746). 
downloaded swa-Latn.csv from epitran repo. 
pulled out the second column, the phone inventory. 
Updated phonemize_audio_data.sh to save filename+phonemes to .csv, and also create a train.txt/test.txt with just the data in it. 

```
cd /home/cleong/projects/data/ALFFA/allosaurus_transcriptions_with_epitran_inventory
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_allosaurus_transcriptions_with_epitran_inventory
clearml-data add --files * 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

ID was 0fa48149d7f745a0971e68b0b611e746

output of `head train`
```
head train 
a l i ɾ e t o k a n e k s e k i e m e ɾ i ð j a n ð
a n i k i t u o k a k a m k o n a i t͡ʃ o n e t e
a k i n e s i u i l a m a l a t a ð e m a k i p e ɾ i k e s ð a u j a k a p e n i k e s o n o m t a i e i n o t a
a m e ð e t a p a j a n o s e i ɾ i t͡ʃ a ð e m a n e ð a i k w o a n a o
e l o e s ð o k u i o n o ð o i n j ɾ e n s a k a s e k a m j a k a e l s t i s a m j a
k e l e ð i a ɾ j e p o t e
o ɾ e n k a n e s t e m a p o x a p a m a ɾ i f u k o a l i t a s i
n a ð a p i k a m a k z o k a f a t a n a o t o t͡ʃ a t͡ʃ u s o f a n i s i ð e
t o m e n o ɾ i a o t͡ʃ i a k o ð i n a w a i k o p u t i ŋ k a k a m a t o t i o x a j a w a l i
s a u p a e ŋ o
```

result of ls
```
-rw-rw-r--  1 cleong cleong 161K Sep 27 19:07 test
-rw-rw-r--  1 cleong cleong 835K Sep 27 19:07 train
```

## ALFFA phonemized with Allosaurus, using epitran inventory, with spaces removed ALFFA_allosaurus_transcriptions_with_epitran_inventory_no_spaces (b334d9a388e248ba9170ae46ecb3a765). 

Ran quite a few pretrainings with above, totally forgetting there was a space between every character. 

Removed spaces, then did: 
```
cd /home/cleong/projects/data/ALFFA/ALFFA_allosaurus_transcriptions_with_epitran_inventory_no_spaces
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_allosaurus_transcriptions_with_epitran_inventory_no_spaces
clearml-data add --files * 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

`head train`
```
aliɾetokaneksekiemeɾiðjanð
anikituokakamkonait͡ʃonete
akinesiuilamalataðemakipeɾikesðaujakapenikesonomtaieinota
ameðetapajanoseiɾit͡ʃaðemaneðaikwoanao
eloesðokuionoðoinjɾensakasekamjakaelstisamja
keleðiaɾjepote
oɾenkanestemapoxapamaɾifukoalitasi
naðapikamakzokafatanaotot͡ʃat͡ʃusofanisiðe
tomenoɾiaot͡ʃiakoðinawaikoputiŋkakamatotioxajawali
saupaeŋo
```



```bash
ls -alh
-rw-rw-r--  1 cleong cleong  88K Sep 27 19:12 test
-rw-rw-r--  1 cleong cleong 454K Sep 27 19:12 train
```

## Hugging Face Swahili dataset with tokenizer and config (1653e234349b44a4b11d3282a6307d8e)
Used `prepare_hf_swahili_datasets.py` to download the data, run epitran on it, and save both versions to .txt.

Then used train_tokenizer_and_save_it.py and saved a tokenizer in there. 

Then added in a standard config file. TODO: check where it's saved in this repo. 

Then uploaded to ClearML.  
```
cd /home/cleong/projects/personal/colin-summer-2021/data/processed/hf_swahili_with_tokenizer_and_config
clearml-data create --project "$CLEARML_PROJECT_NAME" --name hf_swahili_with_tokenizer_and_config
clearml-data add --files * 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

listing and sample

`clearml-data list --id 1653e234349b44a4b11d3282a6307d8e`
```
List dataset content: 1653e234349b44a4b11d3282a6307d8e
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
config.json                                                      |        480 | 85d4c669251607feec392da2007a6e9f408f297bcb52607f5c077aecfab38095
merges.txt                                                       |    407,322 | 0f779ca958dab55e873dd66ceb1452a0f04dc56a9bf6c1c638e05654d3255faf
test.txt                                                         |    684,975 | 764ed4486a40a5a4e90dc1f4cd742ade6e5910581837efa2e8812906c0835668
tokenizer.json                                                   |  1,143,960 | df8a99016571a5c43ee4e6a234fc959a62e54982428794bb2cc8d1906a03a611
train.txt                                                        |  7,573,909 | cc7ff34b5384168637c2fc0feb619ffd1e0f9f4a960a6b5d1c22d7cbe206819c
validation.txt                                                   |    653,400 | 8e2ccb162f3b6506f39e4f5ba381d794adc7d73c6f1894fcc11f51a3e24d34bf
vocab.json                                                       |    660,837 | 6b6896ad0424b283dc75c57eba5c9bfc0993f08ed8d760afe34ed96e8a7cae9f
Total 7 files, 11124883 bytes
```

`head train.txt`
```
taarifa hiyo ilisema kuwa ongezeko la joto la maji juu ya wastani katikati ya bahari ya UNK inaashiria kuwepo kwa mvua za el nino UNK hadi mwishoni mwa april ishirini moja sifuri imeelezwa kuwa ongezeko la joto magharibi mwa bahari ya hindi linatarajiwa kuhamia katikati ya bahari hiyo hali ambayo itasababisha pepo kutoka kaskazini mashariki kuvuma kuelekea bahari ya hindi
aidha ilisema kuwa mwelekeo wa kupungua kwa joto kusini mashariki mwa bahari ya atlantic UNK kusababisha pepo kutoka magharibi kuvuma kuelekea magharibi mwa tanzania katika maeneo ya ziwa victoria
mwelekeo wa mvua wa septemba hadi desemba ishirini sifuri tisa unatarajiwa kuwa katika namna tofauti ambapo baadhi ya maeneo yanaweza kunufaika huku mengine UNK
ilifafanua kuwa msimu wa vuli UNK maeneo ambayo hupata mvua mara mbili ambayo ni kaskazini mwa nchi ikiwa ni nyanda za juu kaskazini mashariki kanda ya ziwa victoria na pwani ya kaskazini
katika maeneo hayo mvua zinatarajiwa kunyesha wiki ya pili na tatu ya septemba mwaka huu
mvua za msimu ambazo UNK mara moja kwa mwaka zinatarajiwa katika mikoa ya magharibi ambayo ni tabora rukwa kigoma kusini mwa mkoa wa shinyanga ambapo zinatarajiwa kuanza wiki ya kwanza ya novemba mwaka huu ambapo wastani wake unatarajiwa kuwa juu
katika mikoa ya kati mvua zinatarajiwa kunyesha singida na dodoma kuanzia wiki ya tatu na nne ya novemba mwaka huu na kupimwa juu ya wastani
mikoa ya nyanda za juu magharibi mvua UNK kuanza wiki ya tatu hadi ya nne ya novemba mwaka huu ambapo zinatarajiwa kuwa zaidi ya wastani wa kawaida
katika mikoa ya kusini na pwani ya kusini ambayo ni ruvuma mtwara pamoja na lindi mvua zinatarajiwa kuanza katika wiki ya tatu na nne ya novemba ambapo zinatarajiwa kuwa chini ya wastani
taarifa hiyo ilieleza kuwa baadhi ya maeneo yanaweza kuathirika kutokana na uwepo wa mvua hizo huku mengine UNK kwa kuwa na mvua za wastani
```

train.txt has 42069 lines according to `wc -l`

## Hugging Face Swahili dataset, epitran version (e56476896c0a4ec79ad04243ae396564)
Used `prepare_hf_swahili_datasets.py` to download the data, run epitran on it, and save both versions to .txt.

```
cd /home/cleong/projects/data/hf_swahili/hf_swahili_epitran
clearml-data create --project "$CLEARML_PROJECT_NAME" --name hf_swahili_epitran
clearml-data add --files * 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

Output of `clearml list`
```
clearml-data - Dataset Management & Versioning CLI
List dataset content: e56476896c0a4ec79ad04243ae396564
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    732,913 | ad504673b0c308c96634362d200b15207e34861434ea531bb8c690784bb7f629
train.txt                                                        |  8,126,176 | d21c0e292b8d9a0e526ca83a278218f714fd41a6de343dd65d48b76bb7e6c123
validation.txt                                                   |    699,556 | ccb4ca464864d510e770cac9f7ae7ec462abbc3531ad15a82af730e7931f10d2
```

A small sample: 
```
$ head test.txt 
hujo alisisitiza kuwa hakuhoʄiwa ɓali alipewa kaɾatasi tupu na kutakiwa kusaini ɓila kufahamu ni kitu ɠani UNK
akielezea siku ja tukio alisema alipiɠiwa simu na ssp salum kisai ambaje alimtaka kufika katika ofisi za tume hijo na alifika hapo oktoɓa kumi mwaka ʄana kutekeleza aɠizo la mpelelezi hujo
aliɗai kuwa ɓaaɗa ja kufika hapo aliambiwa na ɓwana kisai kuwa anahitaʄi kufaɲa maɾekeɓiʃo mat͡ʃat͡ʃe kweɲe maelezo ja tuhuma zake hivjo alimpa kaɾatasi tupu UNK na ɓaaɗaje mpelelezi hujo anɡeandika maelezo
aliɗai kuwa kaɓla ja kutia saini aliɾuhusiwa kwenda msikitini kuswali hivjo aliondoka kuelekea maeneo ja mikot͡ʃeni ɗaɾ es salaam
sitasahau katika maiʃa janɡu ni tukio la aʄaɓu ambalo nilifaɲiwa nikiwa msikitini alikuʄa ofisa mmoʄa wa tume na kunitaka niende ofisi zao huku mtoa hotuɓa akiwa amepanda eneo la kutolea hotuɓa hijo kwa waislam ndit͡ʃo kitu muhimu sana aliɗai ɓwana faɾiʄala
aliɗai kuwa ɓaaɗa ja kufika katika tume hijo alipewa kaɾatasi zile zile na kuambiwa asaini ili aweze kuwahi UNK
kutokana na maelezo hajo alikanuʃa kutoa maelezo hajo kwa mɗomo wake na kuɗai kuwa uʃahiɗi wote uliotolewa na ssp kisai hauna ukweli wowote
ɓwana faɾiʄala alikuwa akitoa uʃahiɗi kwa aʄili ja kuθiɓitiʃa maɗai ja kut͡ʃukuliwa maelezo ja oɲo ɓila kufuata taɾatiɓu za kiʃeɾia lakini pia kuhamiʃwa kwa maelezo hajo kutoka kesi ɲinɡine kwenda kesi ja kampuni ja miɓaɾe faɾm
ɓaaɗa ja kumaliza kutoa uʃahiɗi huo mahakama hijo itatoa uamuzi wa kupokea maelezo jake au la kutokana na uʃahiɗi wa pande zote mbili
uamuzi huo unatolewa leo mahakamani hapo
```


## Hugging Face Swahili dataset without spaces (4376729e20ff43e1a17ee7da82ae81e6)
Started with HF Swahili data (1653e234349b44a4b11d3282a6307d8e), and used GNU Parallel and sed to simply remove all instances of the " " space character. 
```
./remove_spaces_recursively_from_text_files_in_folder.sh ~/projects/data/hf_swahili/hf_swahili ~/projects/data/hf_swahili/hf_swahili_no_spaces/
```

Then uploaded to ClearML: 

```
cd /home/cleong/projects/data/hf_swahili/hf_swahili_no_spaces
clearml-data create --project "$CLEARML_PROJECT_NAME" --name hf_swahili_no_spaces
clearml-data add --files * 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

Output of `clearml list`
```
clearml-data - Dataset Management & Versioning CLI
List dataset content: 4376729e20ff43e1a17ee7da82ae81e6
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    580,475 | bf92bfaff5c2ef9d7dde00c8b53a6b62c2970bf3d29ca4ec6df14aa9300f693b
train.txt                                                        |  6,407,023 | 0b6b0beb92257ba7a09bfd5e07dec8757b48c0edca3df14e74ca4a7488393d80
validation.txt                                                   |    554,447 | fbf29106393d30235a32fc5bd3b907f0854d1b5af33833032b1678c748ed0c10
Total 3 files, 7541945 bytes
```

Sample of data: 
```
head test.txt
huyoalisisitizakuwahakuhojiwabalialipewakaratasitupunakutakiwakusainibilakufahamunikituganiUNK
akielezeasikuyatukioalisemaalipigiwasimunasspsalumkisaiambayealimtakakufikakatikaofisizatumehiyonaalifikahapooktobakumimwakajanakutekelezaagizolampelelezihuyo
alidaikuwabaadayakufikahapoaliambiwanabwanakisaikuwaanahitajikufanyamarekebishomachachekwenyemaelezoyatuhumazakehivyoalimpakaratasitupuUNKnabaadayempelelezihuyoangeandikamaelezo
alidaikuwakablayakutiasainialiruhusiwakwendamsikitinikuswalihivyoaliondokakuelekeamaeneoyamikochenidaressalaam
sitasahaukatikamaishayangunitukiolaajabuambalonilifanyiwanikiwamsikitinialikujaofisammojawatumenakunitakaniendeofisizaohukumtoahotubaakiwaamepandaeneolakutoleahotubahiyokwawaislamndichokitumuhimusanaalidaibwanafarijala
alidaikuwabaadayakufikakatikatumehiyoalipewakaratasizilezilenakuambiwaasainiiliawezekuwahiUNK
kutokananamaelezohayoalikanushakutoamaelezohayokwamdomowakenakudaikuwaushahidiwoteuliotolewanasspkisaihaunaukweliwowote
bwanafarijalaalikuwaakitoaushahidikwaajiliyakuthibitishamadaiyakuchukuliwamaelezoyaonyobilakufuatataratibuzakisherialakinipiakuhamishwakwamaelezohayokutokakesinyinginekwendakesiyakampuniyamibarefarm
baadayakumalizakutoaushahidihuomahakamahiyoitatoauamuziwakupokeamaelezoyakeaulakutokananaushahidiwapandezotembili
uamuzihuounatolewaleomahakamanihapo
```


## Hugging Face Swahili dataset, epitran version, without spaces (e05732c60024428eb5a6b82f2f92c475)
Used GNU Parallel and sed to simply remove all instances of the " " space character. 
```
./remove_spaces_recursively_from_text_files_in_folder.sh ~/projects/data/hf_swahili/hf_swahili_epitran/ ~/projects/data/hf_swahili/hf_swahili_epitran_no_spaces/
```

Then uploaded to ClearML:
```
cd /home/cleong/projects/data/hf_swahili/hf_swahili_epitran_no_spaces
clearml-data create --project "$CLEARML_PROJECT_NAME" --name hf_swahili_epitran_no_spaces
clearml-data add --files * 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

`clearml list`
```
clearml-data - Dataset Management & Versioning CLI
List dataset content: e05732c60024428eb5a6b82f2f92c475
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    628,413 | 31a7e51983cca7a6bc223401cf00fc780d37597847ea9488e919945de3d397e9
train.txt                                                        |  6,959,290 | 8495f4db90cdc122047a68b8d7ee91ad6a6bb5488eba806cc47ec6349e2a7750
validation.txt                                                   |    600,603 | 2f482f15bf07ac381002edcbb8c3d79f70f53f7ae399feb9525c80e1d405ec36
Total 3 files, 8188306 bytes
```

sample
```
head test.txt
hujoalisisitizakuwahakuhoʄiwaɓalialipewakaɾatasitupunakutakiwakusainiɓilakufahamunikituɠaniUNK
akielezeasikujatukioalisemaalipiɠiwasimunasspsalumkisaiambajealimtakakufikakatikaofisizatumehijonaalifikahapooktoɓakumimwakaʄanakutekelezaaɠizolampelelezihujo
aliɗaikuwaɓaaɗajakufikahapoaliambiwanaɓwanakisaikuwaanahitaʄikufaɲamaɾekeɓiʃomat͡ʃat͡ʃekweɲemaelezojatuhumazakehivjoalimpakaɾatasitupuUNKnaɓaaɗajempelelezihujoanɡeandikamaelezo
aliɗaikuwakaɓlajakutiasainialiɾuhusiwakwendamsikitinikuswalihivjoaliondokakuelekeamaeneojamikot͡ʃeniɗaɾessalaam
sitasahaukatikamaiʃajanɡunitukiolaaʄaɓuambalonilifaɲiwanikiwamsikitinialikuʄaofisammoʄawatumenakunitakaniendeofisizaohukumtoahotuɓaakiwaamepandaeneolakutoleahotuɓahijokwawaislamndit͡ʃokitumuhimusanaaliɗaiɓwanafaɾiʄala
aliɗaikuwaɓaaɗajakufikakatikatumehijoalipewakaɾatasizilezilenakuambiwaasainiiliawezekuwahiUNK
kutokananamaelezohajoalikanuʃakutoamaelezohajokwamɗomowakenakuɗaikuwauʃahiɗiwoteuliotolewanasspkisaihaunaukweliwowote
ɓwanafaɾiʄalaalikuwaakitoauʃahiɗikwaaʄilijakuθiɓitiʃamaɗaijakut͡ʃukuliwamaelezojaoɲoɓilakufuatataɾatiɓuzakiʃeɾialakinipiakuhamiʃwakwamaelezohajokutokakesiɲinɡinekwendakesijakampunijamiɓaɾefaɾm
ɓaaɗajakumalizakutoauʃahiɗihuomahakamahijoitatoauamuziwakupokeamaelezojakeaulakutokananauʃahiɗiwapandezotembili
uamuzihuounatolewaleomahakamanihapo
```

## ALFFA ASR Transcriptions (1c71646c657d49b4bf613fc7521f82d3)
Transcribed with `alokmatta/wav2vec2-large-xlsr-53-sw`, based on [this code](https://github.com/chuachinhon/wav2vec2_transformers/blob/main/notebooks/1.0_wav2vec2_short.ipynb)

`transcribe_wav_files_to_txt.py` was the script used. 

```
cd /home/cleong/projects/data/ALFFA/ASR_Transcriptions/
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_ASR_transcriptions_with_wav2vec
clearml-data add --files * 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

`clearml-data list --id 1c71646c657d49b4bf613fc7521f82d3`
```
List dataset content: 1c71646c657d49b4bf613fc7521f82d3
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
README.md                                                        |        192 | c9d3c690b42638bbe94dd8d9210717d697a980bf3a41566410132c7484239073
test.txt                                                         |    111,198 | 9dc917fafe869e33376c3998c6e4e9994af3800289b7cc162d4b71acec6ed6a7
train.txt                                                        |    577,778 | 3cfa1d9c23d1f5bd819b98e7f81c649cf76a6205206f3788ef33ba1ff31653bc
```

`head train.txt`
```
haliiyo inatokana akufikia marigano ya kisiasa
aha ni kitu mafaka kama kuna kitu naita efcion
lakini si huru huru ina maana ptalema angependekeza huyu yakapendekeza una majaji wengi wa stafu
ameweka bayana ushahidi cha dema inayodai kuwa nao
iliweza kuiongoza uingereza katika miaka elfu tisa mia
laziwarivut
horengo wamesema kuwa ocampo amemwarifu kuwa waliotajwa
nna pia kama kazi kazi inaweza ukafanywa na watu wachache kwa ufanishi zaidi
tume huru ya uchaguzi na wajibu wa kutangaza matokeo hayo ya awali
```

train.txt has 10179 lines according to `wc -l`

## ALFFA ASR Transcriptions with spaces removed (a2f63fdc76c7460ead90eb0b3e7b2741)
Used GNU Parallel and sed to simply remove all instances of the " " space character. 
```
./remove_spaces_recursively_from_text_files_in_folder.sh ~/projects/data/ALFFA/ASR_Transcriptions ~/projects/data/ALFFA/ASR_Transcriptions_no_spaces/
```

Then, uploaded to ClearML: 
```
cd /home/cleong/projects/data/ALFFA/ASR_Transcriptions_no_spaces
clearml-data create --project "$CLEARML_PROJECT_NAME" --name ALFFA_ASR_transcriptions_with_wav2vec_no_spaces
clearml-data add --files * 
clearml-data list 
#printed the following
#file name                                                        | size       | hash                                                            
#------------------------------------------------------------------------------------------------------------------------------------------------
#test.txt                                                         |     96,123 | 318f4cb46bf9c88cdf3716a8cc1e3aa128b937550bbfb4ccfe5877b2ff109a9b
#train.txt                                                        |    498,224 | d4b8ca2ca1e8aaaad2917de7c2a8bcb4f2753bd712f0c0950fc755052a240c9d
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```


## hf_swahili_plus_alffa_gold_no_word_boundaries (f930aaae84bc4f8e9b62a2db8ce866cb)
Downloaded the following two (HF swahili and Alffa gold, both with no word boundaries) and simply concatenated the files together
* 4376729e20ff43e1a17ee7da82ae81e6
* 20a6fea6173f49d7b43441afcc9f432b


First I downloaded each folder to a working directory,. 
Then ran the following: 
```
# working dir /home/cleong/projects/data/formatted_for_shiba/text_format/words_with_no_boundaries
cd /home/cleong/projects/data/formatted_for_shiba/text_format/words_with_no_boundaries
clearml-data get --id 4376729e20ff43e1a17ee7da82ae81e6 --copy 4376729e20ff43e1a17ee7da82ae81e6
clearml-data get --id 20a6fea6173f49d7b43441afcc9f432b --copy 20a6fea6173f49d7b43441afcc9f432b
```

Then I created a new folder with concatenated train.txt and validation.txt and so forth.

Checking the lengths of the files...
```
*************
input_folder 1:
total 7.3M
drwxrwxr-x 2 cleong cleong 4.0K Aug  7 10:48 .
drwxrwxr-x 5 cleong cleong 4.0K Aug  7 10:52 ..
-rw-rw-r-- 1 cleong cleong 567K Aug  7 10:01 test.txt
-rw-rw-r-- 1 cleong cleong 6.2M Aug  7 10:01 train.txt
-rw-rw-r-- 1 cleong cleong 542K Aug  7 10:01 validation.txt
*************
input_folder 2:
total 596K
drwxrwxr-x 2 cleong cleong 4.0K Aug  7 10:48 .
drwxrwxr-x 5 cleong cleong 4.0K Aug  7 10:52 ..
-rw-rw-r-- 1 cleong cleong  96K Aug  7 10:02 test.txt
-rw-rw-r-- 1 cleong cleong 489K Aug  7 10:02 train.txt
*************
output folder:
total 7.8M
drwxrwxr-x 2 cleong cleong 4.0K Aug  7 10:57 .
drwxrwxr-x 5 cleong cleong 4.0K Aug  7 10:52 ..
-rw-rw-r-- 1 cleong cleong 663K Aug  7 10:57 test.txt
-rw-rw-r-- 1 cleong cleong 6.6M Aug  7 10:57 train.txt
-rw-rw-r-- 1 cleong cleong 542K Aug  7 10:57 validation.txt
```

Checking the first and last lines of train.txt

```
> head -n 1 /home/cleong/projects/data/formatted_for_shiba/text_format/words_with_no_boundaries/hf_swahili_plus_alffa_gold_no_word_boundaries/train.txt
taarifahiyoilisemakuwaongezekolajotolamajijuuyawastanikatikatiyabahariyaUNKinaashiriakuwepokwamvuazaelninoUNKhadimwishonimwaaprilishirinimojasifuriimeelezwakuwaongezekolajotomagharibimwabahariyahindilinatarajiwakuhamiakatikatiyabaharihiyohaliambayoitasababishapepokutokakaskazinimasharikikuvumakuelekeabahariyahindi
> tail -n 1 /home/cleong/projects/data/formatted_for_shiba/text_format/words_with_no_boundaries/hf_swahili_plus_alffa_gold_no_word_boundaries/train.txt
```


Upload to ClearML

```
cd /home/cleong/projects/data/formatted_for_shiba/text_format/words_with_no_boundaries/hf_swahili_plus_alffa_gold_no_word_boundaries/
clearml-data create --project "$CLEARML_PROJECT_NAME" --name hf_swahili_plus_alffa_gold_no_word_boundaries
clearml-data add --files * 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

clearml-data list: 
```
List dataset content: f930aaae84bc4f8e9b62a2db8ce866cb
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    678,372 | 21948dee249b13a5e9e0ac1c937b1c0d1767ef2098f62e5fa268f265909228da
train.txt                                                        |  6,907,314 | 9fc7ba6e4e4b5aeedf625e2394bacc51f20f5416d22cd8d141a8df8b9b8c27a4
validation.txt                                                   |    554,447 | fbf29106393d30235a32fc5bd3b907f0854d1b5af33833032b1678c748ed0c10
Total 3 files, 8140133 bytes

```


## hf_swahili_epitran_plus_alffa_gold_epitran_no_word_boundaries (d54b006cd86f4fc7985a43c62b4d9544)
As above, but with datasets 
* e05732c60024428eb5a6b82f2f92c475 (HF Swahili epitran)
* 8101d11e76464ce0a7786997d538e662 (ALFFA Gold epitran)

And I made a script that does the steps. 


```bash
cd /home/cleong/projects/personal/colin-summer-2021/src/data
data_id_1="e05732c60024428eb5a6b82f2f92c475"
data_id_2="8101d11e76464ce0a7786997d538e662"
new_name="hf_swahili_epitran_plus_alffa_gold_epitran_no_word_boundaries"
working_dir="/home/cleong/projects/data/formatted_for_shiba/text_format/epitran_phones_with_no_word_boundaries"
bash concatenate_two_clearml_datasets.sh "$data_id_1" "$data_id_2" "$new_name" "$working_dir"
```

All looks good to me. 

## hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries (8f36fe1f355146a2beb738b5341e5cf2)

As above, but with the following two: 
* HF Swahili epitran	e05732c60024428eb5a6b82f2f92c475
* ALFFA allosaurus version	0fa48149d7f745a0971e68b0b611e746

...but I couldn't use my script, because the second one doesn't have a "train.txt", it only has a "train". And similarly for "test". 

I copied them all to the same folder, and did
```
cd "$working_dir/$new_name"
cat test  >>test.txt && rm test
cat train >> train.txt && rm train
clearml-data create --project "$CLEARML_PROJECT_NAME" --name "$new_name"
clearml-data add --files ./* 
clearml-data list 
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

here's the file list and first/last line of train.txt
```
clearml-data - Dataset Management & Versioning CLI
List dataset content: 8f36fe1f355146a2beb738b5341e5cf2
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    793,109 | 57ef1ca22ce418ea80826591eb85cfbd3b244526e3e1df2ae4be97da3f49ec20
text.csv                                                         |  1,565,339 | 012a2d85c74d64b620ad311b2c53dbd4c6879b163d7dc652189a271b86f2cf61
train.txt                                                        |  7,813,491 | 12955199ca3a23fef2fccf09887ee66466ddbc617c3e7b2cabdf910529f20dc4
validation.txt                                                   |    600,603 | 2f482f15bf07ac381002edcbb8c3d79f70f53f7ae399feb9525c80e1d405ec36
Total 4 files, 10772542 bytes
```

### EDIT: this dataset was wrong!
Forgot to remove spaces from the ALFFA data. 

## hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed (5c606acffb2044da88541e82ae352146)
Above, but with the spaces removed. 

```bash
cd /home/cleong/projects/data/formatted_for_shiba/text_format/allosaurus_phones_with_no_word_boundaries/hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed
clearml-data create --project "$CLEARML_PROJECT_NAME" --name hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed
clearml-data add --files * 
clearml-data list 
tail train.txt
head train.txt
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```


And some of the outputs: 
```
(languagemodel) cleong@act3admin-Precision-7730:~/projects/data/formatted_for_shiba/text_format/allosaurus_phones_with_no_word_boundaries/hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed$ clearml-data list 
clearml-data - Dataset Management & Versioning CLI
List dataset content: 5c606acffb2044da88541e82ae352146
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
test.txt                                                         |    718,172 | f2be8ee61e2581693a719af0fb3c603ad266657d3de09e6daf9c88cd376ba038
text.csv                                                         |  1,175,619 | e54a9e03e38b769e258f70928d4b9a05419a18f5d0be80b93bb675cc1e518f0b
train.txt                                                        |  7,423,770 | f688c51995070982eb86492afa67979ea0f2df3051df638adda2c511b7b9ed3b
validation.txt                                                   |    600,602 | 665b24ba60c57032df43fa9ce46694f39ee1379aeee7f3095f677abb645d0897
Total 4 files, 9918163 bytes
(languagemodel) cleong@act3admin-Precision-7730:~/projects/data/formatted_for_shiba/text_format/allosaurus_phones_with_no_word_boundaries/hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed$ tail train.txt
kat͡ʃieiɾanameteifomokuvaɲenkufutunjanekomalðeðekamt͡ʃinsestampo
sakuminamviðekameðekwasaðafikamosovi
koxot͡ʃiaponoŋkot͡ʃaŋjantakanmesiŋɾinaniŋti
anaðoskeit͡ʃeteimðeɾosðeteifɾampapokosikoðevikeɾimunivika
namlikot͡ʃuŋnazoŋkomnsakonɲilanimoiokomoialanaxotzemnimijnefa
ameisizakanpawafpeðinaonenlazimaimu
neutakekilaðaeɾikaɾikasikialeo
avioneoutolevokoɲeapeɾseɾekalia
paɾasakaomant͡ʃiɲiekinezaðiukwjakimateia
ðitaminesieneauelofuiuokonmaɾjoemenekovoðetinentaipa
(languagemodel) cleong@act3admin-Precision-7730:~/projects/data/formatted_for_shiba/text_format/allosaurus_phones_with_no_word_boundaries/hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed$ head train.txt
taaɾifahijoilisemakuwaonɡezekolaʄotolamaʄiʄuujawastanikatikatijaɓahaɾijaUNKinaaʃiɾiakuwepokwamvuazaelninoUNKhaɗimwiʃonimwaapɾiliʃiɾinimoʄasifuɾiimeelezwakuwaonɡezekolaʄotomaɣaɾiɓimwaɓahaɾijahindilinataɾaʄiwakuhamiakatikatijaɓahaɾihijohaliambajoitasaɓaɓiʃapepokutokakaskazinimaʃaɾikikuvumakuelekeaɓahaɾijahindi
aiðailisemakuwamwelekeowakupunɡuakwaʄotokusinimaʃaɾikimwaɓahaɾijaatlanticUNKkusaɓaɓiʃapepokutokamaɣaɾiɓikuvumakuelekeamaɣaɾiɓimwatanzaniakatikamaeneojaziwavictoɾia
mwelekeowamvuawaseptembahaɗiɗesembaiʃiɾinisifuɾitisaunataɾaʄiwakuwakatikanamnatofautiambapoɓaaðijamaeneojanawezakunufaikahukumenɡineUNK
ilifafanuakuwamsimuwavuliUNKmaeneoambajohupatamvuamaɾambiliambajonikaskazinimwant͡ʃiikiwaniɲandazaʄuukaskazinimaʃaɾikikandajaziwavictoɾianapwanijakaskazini
katikamaeneohajomvuazinataɾaʄiwakuɲeʃawikijapilinatatujaseptembamwakahuu
mvuazamsimuambazoUNKmaɾamoʄakwamwakazinataɾaʄiwakatikamikoajamaɣaɾiɓiambajonitaɓoɾaɾukwakiɠomakusinimwamkoawaʃiɲanɡaambapozinataɾaʄiwakuanzawikijakwanzajanovembamwakahuuambapowastaniwakeunataɾaʄiwakuwaʄuu
katikamikoajakatimvuazinataɾaʄiwakuɲeʃasinɡiɗanaɗoɗomakuanziawikijatatunannejanovembamwakahuunakupimwaʄuujawastani
mikoajaɲandazaʄuumaɣaɾiɓimvuaUNKkuanzawikijatatuhaɗijannejanovembamwakahuuambapozinataɾaʄiwakuwazaiɗijawastaniwakawaiɗa
katikamikoajakusininapwanijakusiniambajoniɾuvumamtwaɾapamoʄanalindimvuazinataɾaʄiwakuanzakatikawikijatatunannejanovembaambapozinataɾaʄiwakuwat͡ʃinijawastani
taaɾifahijoilielezakuwaɓaaðijamaeneojanawezakuaθiɾikakutokananauwepowamvuahizohukumenɡineUNKkwakuwanamvuazawastani
```



## Shiba versions of datasets
Shiba requires converting files to .jsonl format and doing a bit of processing

One at a time, we download the following...
* hf_swahili_no_spaces	4376729e20ff43e1a17ee7da82ae81e6
* ALFFA_gold_transcripts_cleaned_no_spaces	20a6fea6173f49d7b43441afcc9f432b
* hf_swahili_plus_alffa_gold_no_word_boundaries	f930aaae84bc4f8e9b62a2db8ce866cb
* hf_swahili_epitran_no_spaces	e05732c60024428eb5a6b82f2f92c475
* ALFFA_gold_transcripts_cleaned_epitran_no_spaces	8101d11e76464ce0a7786997d538e662
* hf_swahili_epitran_plus_alffa_gold_epitran_no_word_boundaries	d54b006cd86f4fc7985a43c62b4d9544
* ALFFA_allosaurus_transcriptions_with_epitran_inventory (edit: this one is wrong, forgot to remove spaces!)	0fa48149d7f745a0971e68b0b611e746
* hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries (edit: this one is wrong, forgot to remove spaces!)	8f36fe1f355146a2beb738b5341e5cf2
* ALFFA_allosaurus_transcriptions_with_epitran_inventory_no_spaces (b334d9a388e248ba9170ae46ecb3a765). 
* hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed (5c606acffb2044da88541e82ae352146)

and feed them into a script that runs shiba's `to_examples.py` script on them. 

```bash
cd /home/cleong/projects/personal/colin-summer-2021/src/data
working_dir="/home/cleong/projects/data/formatted_for_shiba/jsonl_format"



bash create_shiba_version_of_dataset.sh 4376729e20ff43e1a17ee7da82ae81e6 "$working_dir" # created hf_swahili_no_spaces_jsonl
bash create_shiba_version_of_dataset.sh 20a6fea6173f49d7b43441afcc9f432b "$working_dir" # created ALFFA_gold_transcripts_cleaned_no_spaces_jsonl
bash create_shiba_version_of_dataset.sh f930aaae84bc4f8e9b62a2db8ce866cb "$working_dir" # hf_swahili_plus_alffa_gold_no_word_boundaries_jsonl
bash create_shiba_version_of_dataset.sh e05732c60024428eb5a6b82f2f92c475 "$working_dir" # hf_swahili_epitran_no_spaces_jsonl
bash create_shiba_version_of_dataset.sh 8101d11e76464ce0a7786997d538e662 "$working_dir" # ALFFA_gold_transcripts_cleaned_epitran_no_spaces_jsonl
bash create_shiba_version_of_dataset.sh d54b006cd86f4fc7985a43c62b4d9544 "$working_dir" # hf_swahili_epitran_plus_alffa_gold_epitran_no_word_boundaries_jsonl
bash create_shiba_version_of_dataset.sh 0fa48149d7f745a0971e68b0b611e746 "$working_dir" # ALFFA_allosaurus_transcriptions_with_epitran_inventory_jsonl, had to do some steps manually as filenames were not consistent
bash create_shiba_version_of_dataset.sh 8f36fe1f355146a2beb738b5341e5cf2 "$working_dir" #


# (after remembering to remove spaces...)

# ALFFA_allosaurus_transcriptions_with_epitran_inventory_no_spaces (b334d9a388e248ba9170ae46ecb3a765). 
# had to manually edit "test" and "train" to "test.txt" and "train.txt"
# created ALFFA_allosaurus_transcriptions_with_epitran_inventory_no_spaces_jsonl (adc86236bbf44e02b829acf47d13ecea)
bash create_shiba_version_of_dataset.sh b334d9a388e248ba9170ae46ecb3a765 "$working_dir" 

# hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed (5c606acffb2044da88541e82ae352146)
# created hf_swahili_epitran_plus_alffa_allosaurus_no_word_boundaries_spaces_fixed_jsonl 00004aa1223d4437a1053d4fdc89b9cc 
bash create_shiba_version_of_dataset.sh 5c606acffb2044da88541e82ae352146 "$working_dir" 
```


## RobertaForMaskedLM_config (2b820e77c971416db0839cdb659593fe)
A "dataset" consisting of just the config.json as follows: 
```
{
  "architectures": [
    "RobertaForMaskedLM"
  ],
  "attention_probs_dropout_prob": 0.1,
  "bos_token_id": 0,
  "eos_token_id": 2,
  "hidden_act": "gelu",
  "hidden_dropout_prob": 0.1,
  "hidden_size": 768,
  "initializer_range": 0.02,
  "intermediate_size": 3072,
  "layer_norm_eps": 1e-05,
  "max_position_embeddings": 514,
  "model_type": "roberta",
  "num_attention_heads": 12,
  "num_hidden_layers": 12,
  "pad_token_id": 1,
  "type_vocab_size": 1,
  "vocab_size": 50265
}
```

```
clearml-data create --project "$CLEARML_PROJECT_NAME" --name RobertaForMaskedLM_config
clearml-data add --files * 
clearml-data list
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```


## RobertaForMaskedLM_small_52k_vocab (fd96da7461a741ec9897138c123cbb80)
The config we used for most of our experiments, with 6 hidden layers and vocabulary of 52_000

```
{
  "architectures": [
    "RobertaForMaskedLM"
  ],
  "attention_probs_dropout_prob": 0.1,
  "bos_token_id": 0,
  "eos_token_id": 2,
  "hidden_act": "gelu",
  "hidden_dropout_prob": 0.1,
  "hidden_size": 768,
  "initializer_range": 0.02,
  "intermediate_size": 3072,
  "layer_norm_eps": 1e-05,
  "max_position_embeddings": 514,
  "model_type": "roberta",
  "num_attention_heads": 12,
  "num_hidden_layers": 6,
  "pad_token_id": 1,
  "type_vocab_size": 1,
  "vocab_size": 52000
}
```

```
clearml-data create --project "$CLEARML_PROJECT_NAME" --name RobertaForMaskedLM_small_52k_vocab
clearml-data add --files * 
clearml-data list
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```


## Common Voice Kinyarwanda
Downloaded Common voice Kinyarwanda dataset, cv-corpus-6.1-2020-12-11/rw. 

### CV-RW original transcriptions ()
Pulled out the transcriptions to make a "text dataset". 
```
cd cv-corpus-6.1-2020-12-11/rw_wav
mkdir ../rw_text
awk -F "\t" '{print $3}' train.tsv > ../rw_text/train.txt
awk -F "\t" '{print $3}' dev.tsv > ../rw_text/dev.txt
awk -F "\t" '{print $3}' test.tsv > ../rw_text/test.txt
cd ../rw_text
# delete the headers
# https://stackoverflow.com/questions/339483/how-can-i-remove-the-first-line-of-a-text-file-using-bash-sed-script
FILE=train.txt
tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
FILE=test.txt
tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
FILE=dev.txt
tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
```





### Kinyarwanda Common Voice cv-corpus-6.1-2020-12-11_rw_wav (7e6f8b88af454e3f984facc1e833faf0)
Used `convert_mp3_folder_to_wav_and_convert_bitrate.sh` to convert the cv-corpus-6.1-2020-12-11/rw dataset from Common Voice to 16khz mono .wav files.

Put those in a folder called rw_wav

Then, pulled out the different subsets. 
```
cd cv-corpus-6.1-2020-12-11/rw_wav
mkdir train
mkdir dev
mkdir test
awk '{print $2}' train.tsv | parallel --bar cp ./clips/{} train/
awk '{print $2}' dev.tsv | parallel --bar cp ./clips/{} dev/
awk '{print $2}' test.tsv | parallel --bar cp ./clips/{} test/
```

Also, using `break_folder_into_subsets.sh`, broke the training set up into 2k-file subsets. There's 515197 files in the training set, so that ended up being quite a few!


Based on above, uploaded ~10GB of .wav files from the train, dev and test subsets of cv-corpus-6.1-2020-12-11/rw

The "Train" folder is divided into 258 folders, each with 2k files, except for train258 which has a bit fewer

```
cd ~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_wav
clearml-data create --project "$CLEARML_PROJECT_NAME" --name cv-corpus-6.1-2020-12-11_rw_wav
find train -mindepth 1 -type d  |parallel clearml-data add --dataset-folder {} --files {}
#clearml-data add --dataset-folder train --files train  # would have put all the .wav files in one folder again.
clearml-data add --dataset-folder test --files test 
clearml-data add --dataset-folder dev --files dev/ 
clearml-data list > clearml-list.txt
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

### epitran with `kin-Latn`  common_voice_rw_epitran (c78630549a314333837ed4f626e086df)
Updated phonemize_text_data.py to take a language code argument. 

```
conda activate epitran
python phonemize_text_data.py ~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_text/ ~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_text_epitran/ kin-Latn

cd ~/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_text_epitran/
clearml-data create --project "$CLEARML_PROJECT_NAME" --name common_voice_rw_epitran
clearml-data add --files * 
clearml-data list
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

list output:
```
List dataset content: c78630549a314333837ed4f626e086df
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
dev.txt                                                          |  1,047,791 | 67659c35632849c9ccd98b19c545e338e09081b89f5f5ed0d231d9feec2d4fad
test.txt                                                         |  1,011,931 | d60e477df7dcc1b1748bc482279b391f3cc530496a7e97734c1d02c8aa0877d6
train.txt                                                        | 28,873,057 | 3bf60253887ebd723cc57ad8add06181452217f7f09668ec25d85759767ce6da
Total 3 files, 30932779 bytes

```

first line of train.txt: 
```
akunda u ɾwanda kjane kjane ku bjeɾekeje isuku ihaba
```

### common_voice_rw_epitran_no_spaces (bc251f9b118744fd83937875918f8e7b)

```
cd ~/projects/personal/colin-summer-2021/src/data
input_folder="$HOME/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_text_epitran/"
output_folder="$HOME/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_text_epitran_no_spaces/"
bash remove_spaces_recursively_from_text_files_in_folder.sh "$input_folder" "$output_folder"

cd "$output_folder"
clearml-data create --project "$CLEARML_PROJECT_NAME" --name common_voice_rw_epitran_no_spaces
clearml-data add --files * 
clearml-data list
head -n 1 train.txt
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```
list output: 
```
List dataset content: bc251f9b118744fd83937875918f8e7b
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
dev.txt                                                          |    930,564 | a2951b0182a70a74af380139aec3e62c8ff7e3eba3e802ad6e843648763ca6d3
test.txt                                                         |    900,319 | d0f0ba78bad5d35f526eb4ea5c908b658592e610bc43e4fc9f7e70bc215ee85b
train.txt                                                        | 25,707,523 | 3752d7de35ed498251a67d51476f2dc1bd2772408652da6b66faa730efe93498
Total 3 files, 27538406 bytes
```

first line of train.txt: 
```
akundauɾwandakjanekjanekubjeɾekejeisukuihaba
```


### common_voice_rw_epitran_no_spaces_jsonl (82ac906b6c964748a65b2516d65b7d43)

```bash
cd ~/projects/personal/colin-summer-2021/src/data
conda activate shiba
data_id="bc251f9b118744fd83937875918f8e7b"
working_dir="$HOME/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11"
bash create_shiba_version_of_dataset.sh "$data_id" "$working_dir"
```

list output: 
```bash
List dataset content: 82ac906b6c964748a65b2516d65b7d43
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
dev.jsonl                                                        |  3,853,032 | d557811f2420a88f8c44014e89b98bb72b4e356e644a0b9b0b511330f3c614d5
test.jsonl                                                       |  3,735,615 | 339a813a8c592b659e1b5f6721c39e5f3c27349942f19427e08bdae6169a2f71
train.jsonl                                                      | 107,739,453 | a2c73a111cf3881ba09f667dd6f5ffbc1872dec66d7d33d9f593ceb054a48b25
```


### allosaurus with epitran inventory, 204/258 train folders

Made a new script, run_allosaurus_on_common_voice.sh, which loaded in epitran_kin-Latn_phones.txt, and then used GNU Parallel and allosaurus to phonemize the data. Hardcoded paths, etc. 

Epitran list of phonemes: pulled https://github.com/dmort27/epitran/blob/master/epitran/data/map/kin-Latn.csv

```
wget https://raw.githubusercontent.com/dmort27/epitran/master/epitran/data/map/kin-Latn.csv
awk -F "," '{print $2}' kin-Latn.csv > epitran_kin-Latn_phones.txt
# https://stackoverflow.com/questions/339483/how-can-i-remove-the-first-line-of-a-text-file-using-bash-sed-script
FILE=epitran_kin-Latn_phones.txt
tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
```

Phonemize with allosaurus:
```
conda activate allosaurus
bash run_allosaurus_on_common_voice.sh 
blk> a aː b c kj d e eː f ɡ h i iː ɟ ɡj k l m n ŋ nk nt ɲ o p ɾ s xj t u uː v w j z
```

Ran Allosaurus on 204/258 train folders as well as the dev and test sets. Used the phone inventory from Epitran, `kin-Latn`

#### rw_allosaurus_204_of_258_train .txt files (cc2cb1532fab46769e5781a938493eac)

Did above, concatenated all the train.txt files into one. 

Then removed blank lines a la https://unix.stackexchange.com/questions/101440/how-to-remove-blank-lines-from-a-file-including-tab-and-spaces

```
cd /home/cleong/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_allosaurus_204_of_258_train

mkdir orig
cp *.txt orig


#remove blank lines
mkdir no_blanks
grep '[^[:blank:]]' < orig/train.txt > no_blanks/train.txt
grep '[^[:blank:]]' < orig/dev.txt > no_blanks/dev.txt
grep '[^[:blank:]]' < orig/test.txt > no_blanks/test.txt


cd no_blanks

clearml-data create --project "$CLEARML_PROJECT_NAME" --name rw_allosaurus_204_of_258_train
clearml-data add --files train.txt
clearml-data add --files dev.txt 
clearml-data add --files test.txt 
clearml-data list
clearml-data close --storage "$CLEARML_OUTPUT_URI"
```

clearml-data list 
```
List dataset content: cc2cb1532fab46769e5781a938493eac
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
dev.txt                                                          |  1,329,264 | e08e865b0505004c58b98f8edaeeaf197cc4c548c3700570c1a2e009dc7274c3
test.txt                                                         |  1,264,905 | fb5b865b8862b688a3d5f21537900a987346fa53ed942c4575e9b8e254bc7d15
train.txt                                                        | 30,691,218 | 20a678f1a17fe96ff9a911d3c5b04de3e053ba65079720cf8350480bd853ee03
```


#### rw_allosaurus_204_of_258_train_jsonl (443f2c1bb25b4d34985fc498fc42d78c)

Took rw_allosaurus_204_of_258_train above, and ran `create_shiba_version_of_dataset.sh`
```bash
conda activate shiba
cd src/data
data_id="cc2cb1532fab46769e5781a938493eac"
working_dir="/home/cleong/projects/data/Common_Voice/cv-corpus-6.1-2020-12-11/rw_allosaurus_204_of_258_train"
bash create_shiba_version_of_dataset.sh "$data_id" "$working_dir"
```

```
List dataset content: 443f2c1bb25b4d34985fc498fc42d78c
Listing dataset content
file name                                                        | size       | hash                                                            
------------------------------------------------------------------------------------------------------------------------------------------------
dev.jsonl                                                        |  5,280,085 | 009728666e133f2d80a9c4f8a279b13c0842faab8939c4d38df2eba08faf1800
test.jsonl                                                       |  5,017,595 | 364ddaaa2aa68e76463c64513070460ea9b398527ee4cd1a99911bc9b1ec8a29
train.jsonl                                                      | 122,216,665 | 5c8d245def88334311805aa803c64a9fb83378f0aec7845cb54da588aeb30049
```
