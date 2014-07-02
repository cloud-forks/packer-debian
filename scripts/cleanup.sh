#!/bin/sh -ex

# Clean up

apt-get -y --force-yes purge $(dpkg --list |grep '^rc' |awk '{print $2}')
apt-get -y --force-yes purge $(dpkg --list |egrep 'linux-image-[0-9]' |awk '{print $3,$2}' |sort -nr |tail -n +2 |grep -v $(uname -r) |awk '{ print $2}')
apt-get -y --force-yes autoremove --purge
apt-get -y --force-yes clean
apt-get -y --force-yes autoclean
update-grub

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

# Make sure Udev doesn't block our network
echo "cleaning up udev rules"
rm  -f /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules

# Zero out the free space to save space in the final image:
echo "Zeroing device to make space..."

fstrim -v / || echo dummy
dd if=/dev/zero of=/EMPTY bs=1M || echo dummy
rm -f /EMPTY

sync

