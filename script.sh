#!/bin/bash
#Check if the correct number of arguments is provided

file1="file/user"

#Delete user from system
for user in $(grep -Fxv -f $file1 <(awk -F: '$3 >= 1000 {print $1}' /etc/passwd)); do
        userdel $user
        echo "$user has been deleted"
done


#Add user from file 
for user in $(grep -Fxv -f <(awk -F: '$3 >= 1000 {print $1}' /etc/passwd) $file1); do
        useradd $user
        echo "$user has been added"
done

file2="file/admin"

#Delete user from system
for admin in $(grep -Fxv -f $file2 <(getent group sudo | awk -F: '{print $4}' | tr ',' '\n')); do
	deluser $admin sudo
	echo "info: removing user $admin from group sudo ..."
done


#Add user from file
for admin in $(grep -Fxv -f  <(getent group sudo | awk -F: '{print $4}' | tr ',' '\n') $file2); do
	usermod -aG sudo $admin
	echo "info: adding user $admin to group sudo ..."
done