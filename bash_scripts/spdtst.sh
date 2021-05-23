#!/bin/bash
set -e

if ping -c 3 -W 1 1.1.1.1 &> /dev/null; then
  if ping -c 1 -W 1 sp.indinet.co.in &> /dev/null; then
    o=$(/usr/bin/speedtest -s 26195 -f json)
  else o=$(/usr/bin/speedtest -f json); fi
  echo "$o"
else exit
fi
