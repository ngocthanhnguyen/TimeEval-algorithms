#!/bin/bash

# Build base image
cd 0-base-images
docker build -t python3-base:0.2.5 ./python3-base
cd ..

# Define the list of subfolders to ignore
ignored_folders=("01-data" "02-results" ".git" "0-base-images" "3-scripts" "lof")

# Get the list of sub-folders within the current folder, excluding the ones to ignore
subfolders=$(find . -mindepth 1 -maxdepth 1 -type d)

# Traverse through the list of sub-folders
for folder in $subfolders; do
    # Extract the name of the sub-folder
    folder_name=$(basename "$folder")
	
	# Check if the folder name is in the ignored folders list
    if [[ "${ignored_folders[*]}" =~ $folder_name ]]; then
        continue
    fi
	
    # Pass the sub-folder name to the desired command
	echo "$folder_name"
	docker build -t $folder_name ./$folder_name
    # your_command "$folder_name"  # Replace "your_command" with the actual command you want to run
done
