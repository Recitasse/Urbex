#!/bin/bash

# Install python3.11
sudo apt-get install python3.11
sudo apt update
python3.11 -m pip install --upgrade pip
python3.11 -m pip install virtualenv

python3.11 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

