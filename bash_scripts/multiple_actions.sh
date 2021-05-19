#!/bin/bash

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
