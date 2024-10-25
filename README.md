Change the file permissions to make the script executable:
chmod +x myscript.sh

You can run the script in two ways:
./myscript.sh
bash myscript.sh

The command ./script.sh <file_name> is used to run a script named script.sh located in the current directory and pass <file_name> as an argument to the script.

To use the script, run it with the path to a file containing usernames; it will delete users not listed in the file, add users from the file who are not already in the system, and ensure that admin users remain unchanged.

To use the script, run it with the path to a file containing usernames; it will remove users from the `sudo` group who are not listed in the file and add users from the file to the `sudo` group if they are not already members.

To use the script, run it with the name of a package; it will stop related services, list any installed related packages, remove the specified package along with its configuration files, clean up unused dependencies, delete remaining files, and remove the associated group.

To use the script, run it with the name of the service you want to disable; it will stop, disable, and mask the specified service, ensuring it cannot be started again.
