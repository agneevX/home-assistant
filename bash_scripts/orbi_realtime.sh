#!/bin/bash
# shellcheck disable=SC2086,SC2116,SC2003
set -e

DISABLE=no
if [[ $DISABLE == "yes" ]]; then
cat << EOF
{"sent": 0,"receive": 0}
EOF
exit 1; fi

if ! ping -c 1 10.0.0.1 &> /dev/null; then
cat << EOF
{"sent": 0,"receive": 0}
EOF
exit 1; fi

command="(/bin/cat /sys/class/net/brwan/statistics/tx_bytes && \
/bin/cat /sys/class/net/brwan/statistics/rx_bytes && \
/bin/sleep 1 && \
/bin/cat /sys/class/net/brwan/statistics/tx_bytes && \
/bin/cat /sys/class/net/brwan/statistics/rx_bytes)"

execute=yes;
if [[ $execute == "yes" ]]; then
  o=$(sshpass -p XXXXX ssh -o StrictHostKeyChecking=no root@10.0.0.1 "$command")
  set -- $o

  transmit="$(echo $1)"
  receive="$(echo $2)"
  transmit2="$(echo $3)"
  receive2="$(echo $4)"

  transmit=$(expr "$transmit2" - "$transmit")
  receive=$(expr "$receive2" - "$receive")
else exit 1
fi

cat << EOF
{
  "receive": "$receive",
  "sent": "$transmit"
}
EOF
