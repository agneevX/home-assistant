#!/bin/bash
set -e

if hping3 1.0.0.1 -c 1 -S -p 80 &> /dev/null; then
  o=$(/usr/bin/speedtest -f json)
  download_data_used="$(echo "$o" | jq '.download.bytes')"
  upload_data_used="$(echo "$o" | jq '.upload.bytes')"
  data_used=$((( upload_data_used + download_data_used ) / 1048786 ))

#  download_time="$(echo $o | jq '.download.elapsed')"
#  upload_time="$(echo $o | jq '.upload.elapsed')"
#  total_test_time=$(( $download_time + $upload_time ))
cat << EOF
{
  "download_speed": "$(echo "$o" | jq -r '.download.bandwidth')",
  "upload_speed": "$(echo "$o" | jq '.upload.bandwidth')",
  "Ping": "$(echo "$o" | jq -r '.ping.latency') ms",
  "Server": "$(echo "$o" | jq '.server.name'|sed -e 's/^"//' -e 's/"$//')",
  "Data used": "$data_used MB"
}
EOF
  exit
fi
