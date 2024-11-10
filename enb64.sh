#!/bin/bash

touch en$1.txt
# Check if filename is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 filename"
  exit 1
fi

# Read file line by line and encode each line in Base64
while IFS= read -r line; do
  echo "$line" | base64 >> en$1
done < "$1"

#end of the script
