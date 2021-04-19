#!/bin/bash
# shellcheck disable=SC2034,SC2086,SC2219,SC2116
set -e

DISABLE=no
if [[ $DISABLE == "yes" ]]; then
cat << EOF
{"status": "disabled"}
EOF
exit 1; fi

if ! ping -c 1 -W 1 10.0.0.1 &> /dev/null; then
cat << EOF
{"status": "timeout"}
EOF
exit 1; fi

command="(/bin/cat /sys/devices/virtual/net/brwan/statistics/tx_bytes && \
/bin/cat /sys/devices/virtual/net/brwan/statistics/rx_bytes)"

execute=yes
if [[ $execute == "yes" ]]; then
  i=$(sshpass -p XXXX ssh -o StrictHostKeyChecking=no root@10.0.0.1 "$command")
else exit 1; fi

set -- $i
WAN_IN="$(echo $2)"
WAN_OUT="$(echo $1)"

timecalc () {
  num="$1"; min=0; hour=0; day=0
  if ((num>59)); then ((num=num/60))
    if ((num>59)); then
      ((min=num%60))
      ((num=num/60))
      if ((num>23)); then
        ((hour=num%24))
        ((day=num/24))
      else ((hour=num)); fi
    else ((min=num))
    fi; fi
  echo "$day"d "$hour"h "$min"m
}

INPUT=$(curl -s --http0.9 "http://10.0.0.1/RST_statistic.htm" -H 'Content-Type: application/octet-stream' -H 'Authorization: Basic XXXXX')
if [[ "$INPUT" == *multi_login.html* ]]; then
cat << EOF
{
  "status": "partial",
  "WAN In (total)": "$WAN_IN",
  "WAN Out (total)": "$WAN_OUT"
}
EOF
exit
fi

STAGE2="$(echo "$INPUT"|grep "var "|grep '='|grep '"')"

DEBUG=false
if [[ $DEBUG == "true" ]]; then
  echo "$INPUT"; echo "-----"
  echo "$STAGE2"
exit 1; fi

SYS_UPTIME="$(echo "$STAGE2" | grep sys_uptime | grep -o '".*"' | sed 's/"//g')"
SYS_UPTIME=$(timecalc "$SYS_UPTIME")

WAN_UPTIME="$(echo "$STAGE2" | grep wan_systime | grep -o '".*"' | sed 's/"//g')"
WAN_UPTIME=$(timecalc "$WAN_UPTIME")

WAN_PORT_SPEED="$(echo "$STAGE2" | grep wan_status | grep -o '".*"' | sed 's/"//g')"
if [[ $WAN_PORT_SPEED != 'down' ]]; then
  WAN_STATUS="online"
else WAN_STATUS="offline"; fi

LAN_PORT_1_SPEED="$(echo "$STAGE2" | grep lan_status0 | grep -o '".*"' | sed 's/"//g')"
LAN_PORT_2_SPEED="$(echo "$STAGE2" | grep lan_status1 | grep -o '".*"' | sed 's/"//g')"
LAN_PORT_3_SPEED="$(echo "$STAGE2" | grep lan_status2 | grep -o '".*"' | sed 's/"//g')"

cat << EOF
{
  "status": "$WAN_STATUS",
  "Uptime": "$SYS_UPTIME",
  "WAN Uptime": "$WAN_UPTIME",
  "WAN Port": "$WAN_PORT_SPEED",
  "LAN Port 1": "$LAN_PORT_1_SPEED",
  "LAN Port 2": "$LAN_PORT_2_SPEED",
  "LAN Port 3": "$LAN_PORT_3_SPEED",
  "WAN In (total)": "$WAN_IN",
  "WAN Out (total)": "$WAN_OUT"
}
EOF
