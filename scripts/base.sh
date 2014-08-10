#!/bin/sh -ex

apt-get -y --force-yes update
apt-get -y --force-yes dist-upgrade
apt-get -y --force-yes upgrade

#ls -Rlo /boot/

#sed -i 's,UUID=[^[:blank:]]*,/dev/sda1,' /etc/fstab
#sed -i 's,UUID=[^[:blank:]]*,/dev/sda1,' /boot/grub/menu.lst

