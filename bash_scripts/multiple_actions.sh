#!/bin/bash

if [[ "$1" == 'drive_state' ]]; then
  mount_state=$(systemctl is-active mfs-drive.service)
  drive_state=$(systemctl is-active rclone-drive.service)
  crypt_state=$(systemctl is-active rclone-crypt.service)
  if [[ $mount_state == "active" ]]; then
    if [[ $drive_state == "active" ]]; then
      if [[ $crypt_state == "active" ]]; then
        echo "all_mounted"
      else echo "crypt_umount"; fi
    elif [[ $crypt_state == "active" ]]; then
      echo "drive_umount"
    else echo "all_umount"; fi
  else echo "mfs_umount"; fi
fi
