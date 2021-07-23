#!/bin/bash
# shellcheck disable=SC2046,2005,2206

if [[ "$1" == "vnstat_daily_receive" ]]; then
  ssh -i /config/scripts/falcon.key -o StrictHostKeyChecking=no agneev@127.0.0.1 \
  vnstat -i eth0 --json d | jq '.interfaces[] | select(.name=="eth0")' | jq '.traffic.day[]' | grep 'rx' | tail -1 | echo $(tr -dc '0-9')
fi

if [[ "$1" == "vnstat_daily_sent" ]]; then
  ssh -i /config/scripts/falcon.key -o StrictHostKeyChecking=no agneev@127.0.0.1 \
  vnstat -i eth0 --json d | jq '.interfaces[] | select(.name=="eth0")' | jq '.traffic.day[]' | grep 'tx' | tail -1 | echo $(tr -dc '0-9')
fi

if [[ "$1" == "drive_state" ]]; then

  o=$(ssh -i /config/scripts/falcon.key -o StrictHostKeyChecking=no agneev@127.0.0.1 "systemctl is-active mfs-drive.service && systemctl is-active rclone-drive.service && systemctl is-active rclone-drive.service")
  o=($o)

  mount_state=${o[0]}
  drive_state=${o[1]}
  crypt_state=${o[2]}

  if [[ $mount_state == "active" ]]; then
    if [[ $drive_state == "active" ]]; then
      if [[ $crypt_state == "active" ]]; then
        echo "Online"
      else
        echo "Crypt down"
      fi
    elif [[ $crypt_state == "active" ]]; then
      echo "Drive down"
    else
      echo "Drive/Crypt down"
    fi
  else echo "Mount down"
  fi
fi
