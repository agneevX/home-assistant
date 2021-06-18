#!/bin/bash
# shellcheck disable=SC2206,2046
set -e

# Enable debug mode
if [[ "$1" == "-d" ]] || [[ "$1" == "--debug" ]]; then set -x; fi

HOST=""
SSH_PASSWORD=""
WEB_AUTH=""

ssh_command () {
  sshpass -p $SSH_PASSWORD ssh -o StrictHostKeyChecking=no root@$HOST "$1"
}

vnstat_current () {
  ssh_command '/opt/bin/vnstat -i brwan --json -tr 2'
}

vnstat_daily_total () {
  o="$(ssh_command '/opt/bin/vnstat -i eth0 --json d')"

  echo "$o"|jq '.interfaces[]|select(.id=="eth0")'|jq '.traffic.days[]|select(.id==0)'
}

vnstat_month_total () {
  o="$(ssh_command '/opt/bin/vnstat -i eth0 --json m')"

  upload="$(echo "$o" | jq '.interfaces[0].traffic.months[0].tx')"
  download="$(echo "$o" | jq '.interfaces[0].traffic.months[0].rx')"
  total=$(( upload + download ))
cat << EOF
{"index":"0","upload":"$upload","download":"$download","total":"$total"}
EOF
}

netdata_net () {
  o=$(curl -s "http://$HOST:19999/api/v1/data?chart=$1&points=1&options=jsonwrap&format=json")
  receive="$(echo "$o" | jq '.latest_values[0]' | awk '{printf "%.0f\n", $1}')"
  sent="$(echo "$o" | jq '.latest_values[1]' | sed 's/-//g' | awk '{printf "%.0f\n", $1}')"
cat << EOF
{"index": "0","receive": "$receive","sent": "$sent"}
EOF
}

ping_router () {
  if ! ping -c 1 -W 1 $HOST &> /dev/null; then exit; fi
}

web_scrape () {
  echo "$WEB_SCRAPE" | grep var | grep '=' | grep '"' | grep "$1" | grep -o '".*"' | sed 's/"//g'
}

calculate_time () {
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

# Exit script if router cannot be reached
if [[ $(ping_router) ]]; then
cat << EOF
{"status": "timeout"}
EOF
exit
fi

# Get current WAN stats from Netdata via it's API
if [[ "$1" == "wan_current" ]]; then 
  netdata_net "net.brwan"
exit; fi

# Get current stats from wireless backhaul
if [[ "$1" == "backhaul_current" ]]; then 
  netdata_net "net.ath2"
exit; fi

# Get daily WAN stats from vnstat over SSH
if [[ "$1" == "wan_daily" ]]; then 
  ping_router
  vnstat_daily_total
  exit
fi

# Get monthly WAN stats from vnstat over SSH
if [[ "$1" == "wan_month" ]]; then
  ping_router
  vnstat_month_total
  exit
fi

#####################################################

WEB_SCRAPE=$(curl -s --http0.9 "http://$HOST/RST_statistic.htm" \
  -H 'Content-Type: application/octet-stream' \
  -H "Authorization: Basic $WEB_AUTH")

# Exit script if logged in on another device
if [[ "$WEB_SCRAPE" == *multi_login.html* ]]; then
cat << EOF
{"status": "logged-in"}
EOF
exit
fi

# Get WAN port speed/state
WAN_PORT_SPEED="$(web_scrape wan_status)"

if [[ $WAN_PORT_SPEED == *"Full"* ]]; then
  WAN_STATUS="Link up"
else
  WAN_STATUS="Link DOWN"
fi

LOAD_AVG="$(ssh_command '/bin/cat /proc/loadavg')"; LOAD_AVG=($LOAD_AVG)

# Print router stats
cat << EOF
{
  "status": "$WAN_STATUS",
  "Uptime": "$(calculate_time $(web_scrape sys_uptime))",
  "System load": "${LOAD_AVG[0]} ${LOAD_AVG[1]} ${LOAD_AVG[2]}",
  "WAN Uptime": "$(calculate_time $(web_scrape wan_systime))",
  "WAN Port": "$WAN_PORT_SPEED",
  "LAN Port 1": "$(web_scrape lan_status0)",
  "LAN Port 2": "$(web_scrape lan_status1)",
  "LAN Port 3": "$(web_scrape lan_status2)"
}
EOF
