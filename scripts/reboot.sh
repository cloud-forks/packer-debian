#!/bin/sh -x

grep -q "Debian GNU/Linux 8" /etc/os-release && nohup /bin/sh -c 'reboot;' &
grep -q "Debian GNU/Linux 7" /etc/os-release && reboot
