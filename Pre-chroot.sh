#!/bin/bash

timedatectl set-ntp true

sed -i 's/#Color/Color/; s/#TotalDownload/TotalDownload/; s/#\[multilib\]/\[multilib\]/; /\[multilib\]/{N;s/#Include/Include/}' /etc/pacman.conf

sed -i '1s/^/Server \= https\:\/\/mirror.osbeck.com\/archlinux\/\$repo\/os\/\$arch\n/' /etc/pacman.d/mirrorlist

pacman-key --init

pacman-key --populate archlinux

mount /dev/sda2 /mnt

mkdir /mnt/efi

mount /dev/sda1 /mnt/efi

pacstrap /mnt base base-devel linux-zen linux-zen-docs linux-zen-headers linux-firmware linux-tools-meta btrfs-progs dosfstools exfat-progs exfat-utils f2fs-tools e2fsprogs ntfs-3g jfsutils milfs-utils reiserfsprogs udftools xfsprogs squashfs-tools fuse2 fuse3 squashfuse btfs fuseiso kio-fuse mtpfs sshfs nano man-db man-pages texinfo dialog dhcpcd dnsmasq wpa_supplicant grub efibootmgr intel-ucode pacman-contrib pkgstats pkgfile neofetch htop git make xorg mesa lib32-mesa intel-media-driver libva-intel-driver lib32-libva-intel-driver libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau xf86-video-amdgpu vulkan-icd-loader lib32-vulkan-icd-loader vulkan-intel lib32-vulkan-intel vulkan-radeon lib32-vulkan-radeon amdvlk lib32-amdvlk plasma-meta kde-applications-meta kdepim-addons telepathy telepathy-kde-meta packagekit-qt5 fwupd ffmpeg gst-libav gst-plugins-base lib32-gst-plugins-base gst-plugins-good lib32-gst-plugins-good gst-plugins-bad gst-plugins-ugly libde265 gstreamer-vaapi ttf-dejavu ttf-liberation ttf-droid gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-roboto ttf-ubuntu-font-family ttf-opensans cantarell-fonts inter-font wqy-microhei wqy-zenhei wqy-bitmapfont otf-ipafont cpupower haveged android-tools hunspell hunspell-en_US xdg-user-dirs xdg-desktop-portal xdg-desktop-portal-kde libappindicator-gtk2 libappindicator-gtk3 lib32-libappindicator-gtk2 lib32-libappindicator-gtk3 zsh zsh-doc grml-zsh-config zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting zsh-lovers zsh-theme-powerlevel10k powerline

genfstab -U /mnt >> /mnt/etc/fstab
