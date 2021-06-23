ArchLinux-Installer
Script to install ArchLinux

#
# WARNING:
This script will without confirmation wipe first available disk (/dev/sda). Modify the scripts to make adjustments.

Purpose of this script is to reduce manual input during install. This could change in future to make the scripts more user friendly but the intention of these scripts are to be examples template for your own script to automate the process as much as possible.


The script will ask user for username, user password, root password and hostname. Everything else is automated and needs to be adjusted in the script as per requirement.

#
# Instructions to run this *(very specific to my hardwares and overly bloated for some)* installation script:


(1) Make the "pre-chroot.sh" script executable

    chmod a+x ./pre-chroot.sh
#
(2) Execute "pre-chroot.sh"

    ./pre-chroot.sh
#
(3) Sit back and wait for the installation finish. post-chroot steps will run automatically at the end of pre-chroot process. System will automatically reboot after setup is complete.
#
