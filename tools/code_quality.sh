#!/bin/bash

current_directory="$(pwd)"
cd ..

exclude_folders=("venv" "tools")
for folder in $(find "$current_directory" -type d); do
    if [[ ! " ${exclude_folders[@]} " =~ " ${folder##*/} " ]]; then
        flake8 "$folder"/*.py
    fi
done

