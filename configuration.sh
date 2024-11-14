#!/bin/bash

##################     THIS PART IS TO REMOVE AND ADD USERS AND ADMINS     ######################

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

#########################       THIS PART IS TO ENABLE THE FIREWALL      ##########################

ufw allow 22
ufw default deny incoming
ufw default allow outgoing
ufw enable

###################        THIS PART IS TO UPDATE AND SET AUTOMATIC UPDATES      ##################

echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic


echo "updating system"
apt-get update -qq
apt-get upgrade -y -qq
apt-get full-upgrade -y -qq
apt-get autoremove -y -qq
apt-get clean -qq
echo "system updated"

################################     this is to disable services      ###########################################

service --status-all

read -p "Do you want to remove services? " answer
while [ $answer = "yes" ]
do
        read -p "What services do you want to remove? " srv
        systemctl disable $srv 2> /dev/null
        systemctl stop $srv 2> /dev/null
        systemctl mask $srv 2> /dev/null
        echo "service $srv has been disabled" | tee -a file/srv_disabled
        read -p "Do you want to remove another service? " answer
done
#################################### SSH configuration to disable root login #######################################
#!/bin/bash

# Define the path to the sshd_config file
SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP_CONFIG="/etc/ssh/sshd_config.bak"

# Check if the sshd_config file exists
if [ ! -f "$SSHD_CONFIG" ]; then
    echo "Error: SSH configuration file $SSHD_CONFIG not found!"
    exit 1
fi

# Backup the original sshd_config file
echo "Backing up the original SSH configuration file to $BACKUP_CONFIG"
sudo cp "$SSHD_CONFIG" "$BACKUP_CONFIG"

# Disable root login by modifying the sshd_config file
echo "Disabling root login in $SSHD_CONFIG"
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"

# Restart SSH service to apply changes
echo "Restarting SSH service to apply changes"
sudo systemctl restart sshd

# Check the status of SSH service
echo "Checking the status of SSH service"
sudo systemctl status sshd | grep "Active"

echo "Root login has been disabled. Please verify by testing SSH login."
