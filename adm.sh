#!/bin/bash
#Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "usage:$0 <path_to_file>"
  exit 1
fi

file="$1"

#Delete user from system
for user in $(grep -Fxv -f $1 <(getent group sudo | awk -F: '{print $4}' | tr ',' '\n')); do
	deluser $user sudo
done


#Add user from file 
for user in $(grep -Fxv -f  <(getent group sudo | awk -F: '{print $4}' | tr ',' '\n') $1); do
	usermod -aG sudo $user
	echo "info: adding user $user to group sudo ..."
done
