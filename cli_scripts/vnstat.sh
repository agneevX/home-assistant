#!/bin/bash
# Many thanks to Troon(https://community.home-assistant.io/u/Troon). 
# https://community.home-assistant.io/t/unable-to-parse-json/209520

vnstat -i eth0 --json d | jq '.interfaces[] | select(.id=="eth0")' | jq '.traffic.days[] | select(.id==0)'
