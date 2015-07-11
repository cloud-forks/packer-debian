#!/bin/sh -x

nohup "/bin/sh -c 'sleep 2s; ip link set down eth0; reboot;'" &
