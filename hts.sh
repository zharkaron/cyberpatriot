#!/bin/bash

# Check if a package name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <package_name>"
    exit 1
fi

# Set the package name
package_name="$1"

# Stop any services related to the package
systemctl stop "$package_name"* 2>/dev/null

# Find and list related packages
related_packages=$(apt list --installed | grep "$package_name" | awk -F/ '{print $1}')

# Output related packages to be uninstalled
if [ -n "$related_packages" ]; then
    echo "Related packages to be uninstalled:"
    echo "$related_packages"
else
    echo "No related packages found for '$package_name'."
fi
# Remove the main package and its configuration files, suppressing output
apt-get remove --purge *$package_name* -y > /dev/null 2>&1

# Automatically remove unused dependencies, suppressing output
apt-get autoremove -y > /dev/null 2>&1

# Find and delete any remaining files related to the package, suppressing output
find / -name *$package_name* -exec rm -rf {} + > /dev/null 2>&1

# Remove the group associated with the package, suppressing output
delgroup "$package_name" 2>/dev/null
