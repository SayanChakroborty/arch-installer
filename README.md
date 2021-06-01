# ArchLinux-Installer
# Script to install ArchLinux

# First cd into the folder
cd Arch-Installer

# Make both files executable
chmod a+x ./*.sh

# Execute Pre-chroot.sh
./Pre-chroot.sh

# Wait till everything is finished. Post-chroot.sh will run automatically at the end of Pre-chroot process. System will automatically reboot after setup is complete.

# NOTE: This script will without confirmation wipe fist available disk (/dev/sda). Edit the script to make adjustments. Purpose of this script is to reduce manual input during install. The script will ask user for username, user password, root password and hostname. Everything else is automated and needs to be adjusted in the script as per requirement.
