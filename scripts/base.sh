#!/bin/sh -ex

apt-get -y --force-yes update
apt-get -y --force-yes dist-upgrade
apt-get -y --force-yes upgrade


cat <<EOF > /etc/resolv.conf
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844
nameserver 8.8.8.8
nameserver 8.8.4.4
options timeout:2 attempts:1 rotate
EOF

cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet6 auto
iface eth0 inet dhcp
dns-nameservers 2001:4860:4860::8888 2001:4860:4860::8844 8.8.8.8 8.8.4.4
EOF

export APT_LISTCHANGES_FRONTEND=none
export DEBIAN_FRONTEND=noninteractive

for p in vim-tiny vim-common tcpd debian-faq discover discover-data doc-debian laptop-detect ftp telnet wamerican w3m sudo reportbug procmail mutt mlocate ispell dictionaries-common ; do
    apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy purge $p || :
done

sed -i 's|#GRUB_DISABLE_LINUX_UUID.*|GRUB_DISABLE_LINUX_UUID=true|g' /etc/default/grub
sed -i 's|#GRUB_DISABLE_RECOVERY.*|GRUB_DISABLE_RECOVERY=true|g' /etc/default/grub
update-initramfs -k all -u
update-grub

: <<COMMENT
apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy install cloud-init cloud-initramfs-growroot

cat <<EOF > /etc/cloud/cloud.cfg.d/50_allow_root.cfg
users: []
disable_root: 0
ssh_pwauth: 1
EOF

cat <<EOF >> /etc/cloud/cloud.cfg
# Documentation on data sources configuration options
datasource:
  Ec2:
    timeout : 5
    max_wait : 10
EOF
COMMENT
