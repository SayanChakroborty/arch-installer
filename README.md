# ArchLinux-Installer
# Script to install ArchLinux

# First cd into the folder
cd Arch-Installer

# Make both files executable
chmod a+x ./*.sh

# Execute Pre-chroot.sh
./Pre-chroot.sh

# Wait till everything is finished. Post-chroot.sh will run automatically at the end of Pre-chroot process. System will automatically reboot after setup is complete.
