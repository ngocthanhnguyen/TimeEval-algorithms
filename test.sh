#!/bin/bash

# Store the command output in a variable
output=$(sudo docker images | grep adapad_ | awk '{print $1}')

# Remove newlines and enclose each line in double quotes
formatted_output=$(echo $output';' | tr '\n' ' ' | sed 's/ /\n/g' | sed 's/.*/"&"/' | tr -d '\n')

# Break formatted_output into elements covered by double quotes
echo "$formatted_output" | while IFS=';' read -r element; do
    echo "$element"
done
