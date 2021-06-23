#!/bin/sh


echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nEnter username to be created:\n"

read user

echo -e "\nEnter new password for $user:\n"

read uspw

echo -e "\nEnter new password for root:\n"

read rtpw

echo -e "\nEnter new hostname (device name):\n"

read host

# save these inputs in a file from which the respective fields will be sourced later
echo -e "$user $uspw $rtpw $host" > ./passwords

echo -e "\nDone.\n\n"



echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nFormatting Partitions...\n"

# wipe file system of the installation destination disk
wipefs --all /dev/sda

# create a new EFI system partition of size 512 MiB with partition label as "BOOT"
sgdisk -n 0:0:+512M -t 0:ef00 -c 0:BOOT /dev/sda

# create a new Linux x86-64 root (/) partition of size 30 GiB with partition label as "ROOT"
sgdisk -n 0:0:+30G -t 0:8304 -c 0:ROOT /dev/sda

# create a new Linux /home partition on the remaining space of the disk with partition label as "HOME"
sgdisk -n 0:0:0 -t 0:8302 -c 0:HOME /dev/sda

# format partition 1 as FAT32 with file system label "ESP"
mkfs.fat -F 32 -n "ESP" /dev/sda1

# format partition 2 as EXT4 with file system label "System"
mkfs.ext4 -L "System" -F /dev/sda2

# format partition 3 as EXT4 with file system label "Home"
mkfs.ext4 -L "Home" -F /dev/sda3

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nStarting NTP Daemon...\n"

timedatectl set-ntp true

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nModifying Pacman Configuration...\n"

# enable options "color", "ParallelDownloads", "multilib (32-bit) repository"
sed -i 's #Color Color ; s #ParallelDownloads ParallelDownloads ; s #\[multilib\] \[multilib\] ; /\[multilib\]/{n;s #Include Include }' /etc/pacman.conf

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nPerforming Initialization of Pacman Keyring...\n"

pacman-key --init

pacman-key --populate archlinux

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nMounting Partitions...\n"

# mount the ROOT partition on "/mnt"
mount /dev/sda2 /mnt

# create necessary directories
mkdir /mnt/{boot,home}

# mount the EFI system partition on "/mnt/boot"
mount /dev/sda1 /mnt/boot

# mount the HOME partition on "/mnt/home"
mount /dev/sda3 /mnt/home

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nAdding Fastest Mirror in Pacman Mirrorlist...\n"

# save preferred configuration for the reflector systemd service
echo -e "--save /etc/pacman.d/mirrorlist\n--country Sweden,Denmark\n--protocol https\n--score 10\n" > /etc/xdg/reflector/reflector.conf

reflector --save /etc/pacman.d/mirrorlist --country Sweden,Denmark --protocol https --score 10 --verbose

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nPerforming Pacstrap Operation...\n"

# edit and adjust the "pkgs" file for desired packages (don't worry about any extra white spaces or new lines as they will be omitted using sed and tr)
pacstrap /mnt $(cat pkgs | sed 's #.*$  g' | tr '\n' ' ')

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nGenerating FSTab...\n"

genfstab -U /mnt >> /mnt/etc/fstab

echo -e "\nDone.\n\nPre-chroot step is now complete.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nStarting post-chroot step...\n"

# copy the passwords file to destination system's root partition so that post-chroot script can access the file from within chroot
cp ./passwords /mnt/root/

# copy the post-chroot script to destination system's root partition
cp ./post-chroot.sh /mnt/root/

# change file permission of post-chroot script to make it executable
chmod a+x /mnt/root/post-chroot.sh

# run post-chroot script from inside chroot
arch-chroot /mnt /root/post-chroot.sh

# remove files that are unnecessary now
rm /mnt/root/{passwords,post-chroot.sh}

umount -a

echo -e "\nInstallation Complete.\n\nSystem will now reboot in 10 seconds..."

sleep 10

reboot
