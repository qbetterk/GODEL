#!/bin/bash
# ------------------------------------------------------------------
# [Author] Title
#          Description
# ------------------------------------------------------------------
set -xue
VERSION=0.1.0
SUBJECT=DialoGLMRedditDataset
USAGE="Usage: "

# # Please follow parlai to download WoW and WoI dataset
# cd ../data/
# WOW_PATH=./wizard_of_wikipedia
# if [ ! -f wizard_of_wikipedia.tgz ]
# then
#     wget http://parl.ai/downloads/wizard_of_wikipedia/wizard_of_wikipedia.tgz
# fi
# mkdir -p ${WOW_PATH}
# if [ ! -d wizard_of_wikipedia ]
# then
#     tar -zxvf ./wizard_of_wikipedia.tgz -C ./wizard_of_wikipedia
# fi
# cd ../scripts
# python downstream_tasks_converter.py WoWConverter ../data/wizard_of_wikipedia


# cd ../data/
# WOW_PATH=./wizard_of_internet
# if [ ! -f wizard_of_internet.tgz ]
# then
#     wget http://parl.ai/downloads/wizard_of_internet/wizard_of_internet.tgz
# fi
# mkdir -p ${WOW_PATH}
# if [ ! -f wizard_of_internet/train.jsonl ]
# then
#     tar -zxvf ./wizard_of_internet.tgz -C ./wizard_of_internet
# fi
# cd ../scripts
# python downstream_tasks_converter.py WoIConverter ../data/wizard_of_internet

# Please follow https://github.com/stanfordnlp/coqa-baselines to prepare seq2seq-train-h2 and seq2seq-dev-h2
if [ ! -d ../data/coqa-baselines ]
then
    git clone --recurse-submodules git@github.com:stanfordnlp/coqa-baselines.git ../data/coqa-baselines
fi
cd ../data/coqa-baselines
mkdir -p data
wget -P data https://nlp.stanford.edu/data/coqa/coqa-train-v1.0.json
wget -P data https://nlp.stanford.edu/data/coqa/coqa-dev-v1.0.json  
mkdir -p wordvecs
wget -P wordvecs http://nlp.stanford.edu/data/wordvecs/glove.42B.300d.zip
unzip -d wordvecs wordvecs/glove.42B.300d.zip
wget -P wordvecs http://nlp.stanford.edu/data/wordvecs/glove.840B.300d.zip
unzip -d wordvecs wordvecs/glove.840B.300d.zip
python scripts/gen_seq2seq_data.py --data_file data/coqa-train-v1.0.json --n_history 2 --lower --output_file data/seq2seq-train-h2
python scripts/gen_seq2seq_data.py --data_file data/coqa-dev-v1.0.json --n_history 2 --lower --output_file data/seq2seq-dev-h2
cd ../scripts
COQA_PATH=../data/coqa-baselines/data
python downstream_tasks_converter.py CoQAConverter ${COQA_PATH}

# # Please clone https://github.com/wenhuchen/HDSA-Dialog to download the data.
git clone https://github.com/wenhuchen/HDSA-Dialog ../data/HDSA-Dialog
MULTIWOZ_PATH=../data/HDSA-Dialog/data
python downstream_tasks_converter.py MultiWOZConverter ${MULTIWOZ_PATH}