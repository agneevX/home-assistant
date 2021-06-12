#!/bin/bash
# shellcheck disable=SC2086,2206
set -e
DISABLE=no

# if [[ "$1" == "-d" ]] || [[ "$1" == "--debug" ]]; then 
#   set -x
#   DEBUG=true
# fi

PASSWORD="XXXXX"
SSH_COMMAND="-p $PASSWORD ssh -o StrictHostKeyChecking=no root@10.0.0.1"

if [[ "$1" == "wan_live" ]]; then
  o=$(curl -s "http://10.0.0.1:19999/api/v1/data?chart=net.brwan&points=1&options=jsonwrap&format=json" | jq '.latest_values[]')
  receive=$(echo "$o"|sed -n '1p'| awk '{print int($1+0.5)}')
  sent=$(echo "$o"| sed -n '2p'|sed 's/-//g'| awk '{print int($1+0.5)}')
cat << EOF
{"index": "0","receive": "$receive","sent": "$sent"}
EOF
exit
fi

# if [[ "$1" == "vnstat_live" ]]; then
#   o="$(sshpass $SSH_COMMAND /opt/bin/vnstat --json -tr 2)"
#   echo "$o"
#   exit
# fi

if [[ "$1" == "vnstat_total" ]]; then
  if ! ping -c 1 -W 1 10.0.0.1 &> /dev/null; then exit; fi

  o="$(sshpass $SSH_COMMAND /opt/bin/vnstat -i eth0 --json d)"
  o="$(echo "$o" | jq '.interfaces[] | select(.id=="eth0")' | jq '.traffic.days[] | select(.id==0)')"
  echo "$o"; exit
fi

if [[ "$1" == "wan_monthly_usage" ]]; then
  o="$(sshpass $SSH_COMMAND /opt/bin/vnstat --json m)"
  upload="$(echo "$o"|jq '.interfaces[0].traffic.months[0].tx')"
  download="$(echo "$o"|jq '.interfaces[0].traffic.months[0].rx')"
  total=$(( $upload + $download ))
cat << EOF
{"index":"0","upload":"$upload","download":"$download","total":"$total"}
EOF
  exit
fi

if [[ $DISABLE == "yes" ]]; then
cat << EOF
{"status": "disabled"}
EOF
exit; fi

if ! ping -c 1 -W 1 10.0.0.1 &> /dev/null; then
cat << EOF
{"status": "timeout"}
EOF
exit; fi

#command="(/bin/cat /sys/devices/virtual/net/brwan/statistics/tx_bytes && \
#/bin/cat /sys/devices/virtual/net/brwan/statistics/rx_bytes)"

command="(/bin/cat /proc/loadavg)"

i="$(sshpass $SSH_COMMAND $command)"; i=($i)

#set -- $i
#WAN_IN="$(echo $2)"
#WAN_OUT="$(echo $1)"

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
{"status": "unknown"}
EOF
exit; fi

STAGE2="$(echo "$INPUT"|grep "var"|grep '='|grep '"')"

if [[ $DEBUG == "true" ]]; then
  echo "$INPUT"; echo "-----"
  echo "$STAGE2"
exit 1; fi

UPTIME="$(echo "$STAGE2" | grep sys_uptime | grep -o '".*"' | sed 's/"//g')"
UPTIME=$(timecalc "$UPTIME")

WAN_UPTIME="$(echo "$STAGE2" | grep wan_systime | grep -o '".*"' | sed 's/"//g')"
WAN_UPTIME=$(timecalc "$WAN_UPTIME")

WAN_PORT_SPEED="$(echo "$STAGE2" | grep wan_status | grep -o '".*"' | sed 's/"//g')"
if [[ $WAN_PORT_SPEED == *"Full"* ]]; then
  WAN_STATUS="Link up"
else WAN_STATUS="$WAN_PORT_SPEED"; fi

LAN_PORT_1_SPEED="$(echo "$STAGE2" | grep lan_status0 | grep -o '".*"' | sed 's/"//g')"
LAN_PORT_2_SPEED="$(echo "$STAGE2" | grep lan_status1 | grep -o '".*"' | sed 's/"//g')"
LAN_PORT_3_SPEED="$(echo "$STAGE2" | grep lan_status2 | grep -o '".*"' | sed 's/"//g')"

cat << EOF
{
  "status": "$WAN_STATUS",
  "Uptime": "$UPTIME",
  "System load": "${i[0]} ${i[1]} ${i[2]}",
  "WAN Uptime": "$WAN_UPTIME",
  "WAN Port": "$WAN_PORT_SPEED",
  "LAN Port 1": "$LAN_PORT_1_SPEED",
  "LAN Port 2": "$LAN_PORT_2_SPEED",
  "LAN Port 3": "$LAN_PORT_3_SPEED"
}
EOF
