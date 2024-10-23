#!/bin/bash
#Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "usage:$0 <path_to_file>"
  exit 1
fi

file="$1"

#Delete user from system
for user in $(grep -Fxv -f $file <(awk -F: '$3 >= 1000 {print $1}' /etc/passwd)); do
        userdel $user
        echo "$user has been deleted"
done


#Add user from file 
for user in $(grep -Fxv -f <(awk -F: '$3 >= 1000 {print $1}' /etc/passwd) $file); do
        useradd $user
        echo "$user has been added"
done
