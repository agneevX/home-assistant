#!/bin/bash
# shellcheck disable=SC2086
set -e

if hping3 1.0.0.1 -c 1 -S -p 80 &> /dev/null; then
  if ping -c 1 -W 1 sp.indinet.co.in &> /dev/null; then
    o=$(/usr/bin/speedtest -s 26195 -f json)
  else o=$(/usr/bin/speedtest -f json); fi
  download_data_used="$(echo $o | jq '.download.bytes')"
  upload_data_used="$(echo $o | jq '.upload.bytes')"
  data_used=$(( upload_data_used + download_data_used ))
  data_used=$(( data_used / 1048786 ))
cat << EOF
{
  "download_speed": "$(echo $o | jq -r '.download.bandwidth')",
  "upload_speed": "$(echo $o | jq '.upload.bandwidth')",
  "Ping": "$(echo $o | jq -r '.ping.latency')ms",
  "Jitter": "$(echo $o | jq -r '.ping.jitter')ms",
  "Server": "$(echo $o | jq '.server.name'|sed -e 's/^"//' -e 's/"$//') ($(echo $o | jq '.server.id'))",
  "Data used": "$data_used MB"
}
EOF
else exit
fi
