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
