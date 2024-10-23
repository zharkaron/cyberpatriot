#!/bin/bash
#Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "usage:$0 <path_to_file>"
  exit 1
fi

file_path="$!"

for user in $(grep -Fxv -f <(awk -F: '$3 >= 1000 {print $1}' /etc/passwd) $1); do
  echo $user
done
