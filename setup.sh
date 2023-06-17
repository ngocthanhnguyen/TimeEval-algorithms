#!/bin/bash

# Build base image
cd 0-base-images
docker build -t registry.gitlab.hpi.de/akita/i/python3-base:0.2.5 ./python3-base
docker build -t registry.gitlab.hpi.de/akita/i/python3-torch:0.2.5 ./python3-torch
docker build -t registry.gitlab.hpi.de/akita/i/pyod:0.2.5 ./pyod
docker build -t registry.gitlab.hpi.de/akita/i/r-base:0.2.5 ./r-base
docker build -t registry.gitlab.hpi.de/akita/i/tsmp:0.2.5 ./tsmp
docker build -t registry.gitlab.hpi.de/akita/i/java-base:0.2.5 ./java-base
docker build -t registry.gitlab.hpi.de/akita/i/python2-base:0.2.5 ./python2-base
docker build -t registry.gitlab.hpi.de/akita/i/python36-base:0.2.5 ./python36-base
docker build -t registry.gitlab.hpi.de/akita/i/r4-base:0.2.5 ./r4-base
docker build -t registry.gitlab.hpi.de/akita/i/rust-base:0.2.5 ./rust-base
docker build -t registry.gitlab.hpi.de/akita/i/timeeval-test-algorithm:0.2.5 ./timeeval-test-algorithm
cd ..

# Define the list of subfolders to ignore
ignored_folders=("01-data" "02-results" ".git" "0-base-images" "3-scripts" "ts_bitmap")

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
	docker build -t adapad_$folder_name ./$folder_name || true
	# your_command "$folder_name"  # Replace "your_command" with the actual command you want to run
	
done
