#!/bin/sh -x

which systemctl && systemctl reboot &
which systemctl || reboot &

sleep 60;
