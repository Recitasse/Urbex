#!/bin/bash

# Install python3.11
sudo apt-get install python3.11
sudo apt update
python3.11 -m pip install --upgrade pip
python3.11 -m pip install virtualenv

# install git
sudo apt install git
git --version
read -p "Give your git name : " name
git config --global user.name $name
read -p "Give your git email : " email
git config --global user.email $email

git clone git@github.com:Recitasse/Urbex.git
git status

read -p "Create folder on desktop? (Y/N): " answer
answer_lower=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

# Check the user's response
if [ "$answer_lower" == "y" ]; then

    desktop_path="$HOME/Desktop"

    # Check if the folder already exists
    if [ ! -d "$desktop_path/Urbex" ]; then
        mkdir "$desktop_path/Urbex"
        echo "Folder 'Urbex' created on the desktop."
        cd "$desktop_path/Urbex"
        echo "Folder created"
        path="$desktop_path/Urbex"
    else
        echo "Folder 'Urbex' already exists on the desktop."
    fi
else
    echo "Creating folder here."
    $path="$(pwd)"
    mkdir "$path/Urbex"
    cd "$path/Urbex"
fi

