#!/bin/bash

if [[ "$1" == 'spdtst' ]]; then
  HC_URL=https://hc-ping.com/XXXXX

  if ping -c 3 10.0.0.1 &> /dev/null; then
    if ping -c 1 sp.indinet.co.in &> /dev/null; then
      o=$(/usr/bin/speedtest -s 26195 -f json)
    else o=$(/usr/bin/speedtest -f json); fi
    pkill speedtest -u homeassistant
    curl -fsS --retry 5 --data-raw "$o" $HC_URL > /dev/null
    echo "$o"
  else exit 0; fi; fi
if [[ "$1" == 'drive_state' ]]; then
  mnt_state=$(systemctl is-active drive.mount)
  drive_state=$(systemctl is-active drive.service)
  crypt_state=$(systemctl is-active crypt.service)
  if [[ $mnt_state == 'active' ]]; then
    if [[ $drive_state == 'active' ]]; then
      if [[ $crypt_state == 'active' ]]; then
        echo 'on'
      else echo 'crypt_off'; fi
    elif [[ $crypt_state == 'active' ]]; then
      echo 'drive_off'
    else echo 'drive_crypt_off'; fi
  else echo 'mount_off'; fi; fi
