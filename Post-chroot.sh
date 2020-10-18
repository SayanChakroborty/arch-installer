#!/bin/sh


echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nModifying Pacman Configuration...\n"

sed -i 's/#Color/Color/; s/#\[multilib\]/\[multilib\]/; /\[multilib\]/{N;s/#Include/Include/}' /etc/pacman.conf

pacman -Syy

echo -e "\nDone.\n\n"

sleep 2


echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nSetting Localtime...\n"

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

hwclock --systohc

echo -e "\nDone.\n\n"

sleep 2


echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nConfiguring Locale...\n"

sed -i 's/#en_US/en_US/; s/#en_IN/en_IN/' /etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "laptop" >> /etc/hostname

echo -e "\nDone.\n\n"

sleep 2


echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nAccount Management...\n"

echo -e "\nEnter Password for ROOT\n"

passwd root

echo -e "\nCreating New User...\n"

useradd -m -G wheel -s /bin/zsh ron

echo -e "\nEnter Password for New User\n"

passwd ron

cat << EOT >> /etc/polkit-1/rules.d/49-nopasswd_global.rules
/* Allow members of the wheel group to execute any actions
 * without password authentication, similar to "sudo NOPASSWD:"
 */
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOT

cat << EOT >> /etc/polkit-1/rules.d/50-udisks.rules
// Original rules: https://github.com/coldfix/udiskie/wiki/Permissions
// Changes: Added org.freedesktop.udisks2.filesystem-mount-system, as this is used by Dolphin.

polkit.addRule(function(action, subject) {
  var YES = polkit.Result.YES;
  // NOTE: there must be a comma at the end of each line except for the last:
  var permission = {
    // required for udisks1:
    "org.freedesktop.udisks.filesystem-mount": YES,
    "org.freedesktop.udisks.luks-unlock": YES,
    "org.freedesktop.udisks.drive-eject": YES,
    "org.freedesktop.udisks.drive-detach": YES,
    // required for udisks2:
    "org.freedesktop.udisks2.filesystem-mount": YES,
    "org.freedesktop.udisks2.encrypted-unlock": YES,
    "org.freedesktop.udisks2.eject-media": YES,
    "org.freedesktop.udisks2.power-off-drive": YES,
    // Dolphin specific
    "org.freedesktop.udisks2.filesystem-mount-system": YES,
    // required for udisks2 if using udiskie from another seat (e.g. systemd):
    "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
    "org.freedesktop.udisks2.filesystem-unmount-others": YES,
    "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
    "org.freedesktop.udisks2.eject-media-other-seat": YES,
    "org.freedesktop.udisks2.power-off-drive-other-seat": YES
  };
  if (subject.isInGroup("storage")) {
    return permission[action.id];
  }
});
EOT

echo -e "\nDone.\n\n"

sleep 2


echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nConfiguring AUR...\n"

mkdir ~/Downloads/AUR/

cd ~/Downloads/AUR/

git clone https://aur.archlinux.org/yay-bin.git

cd ./yay-bin

makepkg -si --noconfirm

yay -Syyu --noconfirm

echo -e "\nDone.\n\n"

sleep 2


echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nConfiguring Bootloader...\n"

mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\nDone.\n\n"

sleep 2


echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nFinishing Touch...\n"

systemctl enable sddm NetworkManager dhcpcd dnsmasq bluetooth cpupower haveged

pkgfile --update

appstreamcli refresh-cache --force --verbose

echo -e "\nFinally Done.\n\n"

exit
