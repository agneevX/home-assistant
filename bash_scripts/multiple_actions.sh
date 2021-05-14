#!/bin/bash

if [[ "$1" == "orbi_vnstat" ]]; then
  o="$(sshpass -p <password> ssh -o StrictHostKeyChecking=no root@10.0.0.1 /opt/bin/vnstat -i eth0 --json d)"
  o="$(echo "$o" | jq '.interfaces[] | select(.id=="eth0")' | jq '.traffic.days[] | select(.id==0)')"
  echo "$o"; exit
fi
if [[ "$1" == 'spdtst' ]]; then
  if ping -c 3 -W 1 1.1.1.1 &> /dev/null; then
    if ping -c 1 -W 1 sp.indinet.co.in &> /dev/null; then
      o=$(/usr/bin/speedtest -s 26195 -f json)
    else o=$(/usr/bin/speedtest -f json); fi
    echo "$o"
  else exit
  fi
fi
if [[ "$1" == 'drive_state' ]]; then
  mount_state=$(systemctl is-active mfs-drive.service)
  drive_state=$(systemctl is-active rclone-drive.service)
  crypt_state=$(systemctl is-active rclone-crypt.service)
  if [[ $mount_state == "active" ]]; then
    if [[ $drive_state == "active" ]]; then
      if [[ $crypt_state == "active" ]]; then
        echo "on"
      else echo "crypt_off"; fi
    elif [[ $crypt_state == "active" ]]; then
      echo "drive_off"
    else echo "drive_crypt_off"; fi
  else echo "mount_off"; fi
fi
