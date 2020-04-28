#!/bin/bash

# General Requirements
echo 'INSTALLING GENERAL REQUIREMENTS...'
sudo apt-get -y install git
sudo apt-get -y install python3.7
sudo apt-get -y install python-pip
sudo apt-get -y install virtualenv
sudo apt-get -y install unzip

# Virtual Environment
echo 'SETTING UP VIRTUAL ENVIRONMENT...'
pip install setuptools
virtualenv venv
virtualenv -p /usr/bin/python3 venv
source venv/bin/activate

# Dependencies
pip install -r requirements.txt

# Get Data
echo 'DOWNLOADING DATA...'
wget http://bit.ly/bias-corpus
unzip bias-corpus
export DATA=$(pwd)/bias_data/

# Train
echo 'RUNNING TAGGER...'
cd src/
python tagging/train.py \
	--train $DATA/biased.word.train \
	--test $DATA/biased.word.test \
	--categories_file $DATA/revision_topics.csv \
	--extra_features_top --pre_enrich --activation_hidden --category_input \
	--learning_rate 0.0003 --epochs 20 --hidden_size 512 --train_batch_size 32 \
	--test_batch_size 16 --debias_weight 1.3 --working_dir train_tagging/
