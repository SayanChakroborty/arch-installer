#!/bin/sh


echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nEnter username to be created:\n"

read name

echo -e "\nEnter root password:\n"

read rp

echo -e "\nEnter user password:\n"

read up

echo -e "$name $rp $up" > ./passwords

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nStarting NTP Daemon...\n"

sleep 2

timedatectl set-ntp true

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nAdding Fastest Mirror in Pacman Mirrorlist...\n"

sleep 2

echo -e "Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nModifying Pacman Configuration...\n"

sleep 2

sed -i 's/#Color/Color/; s/#TotalDownload/TotalDownload/; s/#\[multilib\]/\[multilib\]/; /\[multilib\]/{N;s/#Include/Include/}' /etc/pacman.conf

pacman -Syy

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nPerforming Initialization of Pacman Keyring...\n"

sleep 2

pacman-key --init

pacman-key --populate archlinux

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nFormatting Partitions\n"

sleep 2

mkfs.fat -F 32 -n "ESP" /dev/sda1

mkfs.ext4 -L "ROOT" /dev/sda2

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nMounting Partitions...\n"

sleep 2

mount /dev/sda2 /mnt

rm -rf /mnt/lost*

mkdir /mnt/efi

mount /dev/sda1 /mnt/efi

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nPerforming Pacstrap Operation...\n"

sleep 2

pacstrap /mnt base base-devel linux-zen linux-zen-docs linux-zen-headers linux-firmware linux-tools-meta btrfs-progs dosfstools fatresize exfat-utils exfat-utils f2fs-tools e2fsprogs ntfs-3g jfsutils nilfs-utils reiserfsprogs udftools xfsprogs squashfs-tools fuse2 fuse3 squashfuse btfs fuseiso kio-fuse mtpfs sshfs p7zip unrar unarchiver lzop lrzip unzip zip nano man-db man-pages texinfo dialog dhcpcd dnsmasq wpa_supplicant grub efibootmgr intel-ucode pacman-contrib pkgstats pkgfile neofetch htop git make xorg mesa lib32-mesa intel-media-driver libva-intel-driver lib32-libva-intel-driver libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau xf86-video-amdgpu vulkan-icd-loader lib32-vulkan-icd-loader vulkan-intel lib32-vulkan-intel vulkan-radeon lib32-vulkan-radeon amdvlk lib32-amdvlk plasma-meta kde-applications-meta kdepim-addons telepathy telepathy-kde-meta packagekit-qt5 fwupd ffmpeg gst-libav gst-plugins-base lib32-gst-plugins-base gst-plugins-good lib32-gst-plugins-good gst-plugins-bad gst-plugins-ugly libde265 gstreamer-vaapi ttf-dejavu ttf-liberation ttf-droid gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-roboto ttf-ubuntu-font-family ttf-opensans cantarell-fonts inter-font wqy-microhei wqy-zenhei wqy-bitmapfont otf-ipafont cpupower haveged android-tools hunspell hunspell-en_US xdg-user-dirs xdg-desktop-portal xdg-desktop-portal-kde libappindicator-gtk2 libappindicator-gtk3 lib32-libappindicator-gtk2 lib32-libappindicator-gtk3 zsh zsh-doc grml-zsh-config zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting zsh-lovers zsh-theme-powerlevel10k powerline firefox

echo -e "\nDone.\n\n"




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nGenerating FSTab...\n"

sleep 2

genfstab -U /mnt >> /mnt/etc/fstab

echo -e "\nDone.\n\nPre-chroot step is now complete.\n\n"

sleep 2




echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nStarting Post-chroot step...\n"

sleep 2

cp ./passwords /mnt/root/

cp ./Post-chroot.sh /mnt/root/

chmod a+x /mnt/root/Post-chroot.sh

arch-chroot /mnt /root/Post-chroot.sh

umount -a

sleep 2

echo -e "\nInstallation Complete.\n\n"

sleep 10

poweroff
