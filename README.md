ArchLinux-Installer
Script to install ArchLinux

#
# WARNING:
This script will without confirmation wipe first available disk (/dev/sda). Modify the scripts to make adjustments.

Purpose of this script is to reduce manual input during install. This could change in future to make the scripts more user friendly but the intention of these scripts are to be example template for your own script to automate the process as much as possible.


The script will ask user for username, user password, root password, hostname and local timezone. Everything else is automated and needs to be adjusted in the script as per requirement.

#
# Instructions to run this *(very specific to my hardwares and overly bloated for some)* installation script:


(1) Edit and adjust the file "pkgs" for desired packages to be installed (don't worry about any extra white spaces or new lines or comments as they will be omitted using sed and tr)

(2) Make the "install" script executable

    chmod a+x ./install
#
(3) Execute "install"

    ./install
#
(4) Sit back and wait for the installation to finish (depending on your internet speed). The config script will run automatically at the end of base install process. System will automatically reboot after setup is complete.
