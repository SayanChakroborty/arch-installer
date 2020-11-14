wipefs --all /dev/sda

fdisk --wipe always --wipe-partitions always /dev/sda << EOL
g
n
1

+512M
n
2


t
1
1
t
2
24
w
EOL

mkfs.fat -F 32 -n "ESP" /dev/sda1

mkfs.ext4 -L "ROOT" -F /dev/sda2

