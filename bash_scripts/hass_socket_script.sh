#!/bin/bash
read -r MESSAGE

if [[ $MESSAGE == 'lofi_on' ]]; then 
  screen -S lofi -d -m /usr/bin/mpv --ao=alsa --no-video --no-config --really-quiet "$(/home/agneev/.local/bin/youtube-dlc -g -f 95 5qap5aO4i9A)"; fi
if [[ $MESSAGE == 'lofi_off' ]]; then screen -S lofi -X quit; fi
if [[ $MESSAGE == 'lofi2_on' ]]; then 
  screen -S lofi2 -d -m /usr/bin/mpv --ao=alsa --no-video --no-config --really-quiet "$(/home/agneev/.local/bin/youtube-dlc -g -f 95 DWcJFNfaw9c)"; fi
if [[ $MESSAGE == 'lofi2_off' ]]; then screen -S lofi2 -X quit; fi
if [[ $MESSAGE == 'jazz_radio_on' ]]; then 
  screen -S jazz_radio -d -m /usr/bin/mpv --ao=alsa --no-video --no-config --really-quiet "$(/home/agneev/.local/bin/youtube-dlc -g -f 95 fEvM-OUbaKs)"; fi
if [[ $MESSAGE == 'jazz_radio_off' ]]; then screen -S jazz_radio -X quit; fi

if [[ $MESSAGE == 'amixer_0' ]]; then amixer -q cset numid=1 -- -10239; fi
if [[ $MESSAGE == 'amixer_5' ]]; then amixer -q cset numid=1 -- -7399; fi
if [[ $MESSAGE == 'amixer_10' ]]; then amixer -q cset numid=1 -- -5595; fi
if [[ $MESSAGE == 'amixer_15' ]]; then amixer -q cset numid=1 -- -4538; fi
if [[ $MESSAGE == 'amixer_20' ]]; then amixer -q cset numid=1 -- -3788; fi
if [[ $MESSAGE == 'amixer_25' ]]; then amixer -q cset numid=1 -- -3206; fi
if [[ $MESSAGE == 'amixer_30' ]]; then amixer -q cset numid=1 -- -2729; fi
if [[ $MESSAGE == 'amixer_35' ]]; then amixer -q cset numid=1 -- -2326; fi
if [[ $MESSAGE == 'amixer_40' ]]; then amixer -q cset numid=1 -- -1976; fi
if [[ $MESSAGE == 'amixer_45' ]]; then amixer -q cset numid=1 -- -1667; fi
if [[ $MESSAGE == 'amixer_50' ]]; then amixer -q cset numid=1 -- -1392; fi
if [[ $MESSAGE == 'amixer_55' ]]; then amixer -q cset numid=1 -- -1142; fi
if [[ $MESSAGE == 'amixer_60' ]]; then amixer -q cset numid=1 -- -914; fi
if [[ $MESSAGE == 'amixer_65' ]]; then amixer -q cset numid=1 -- -704; fi
if [[ $MESSAGE == 'amixer_70' ]]; then amixer -q cset numid=1 -- -548; fi
if [[ $MESSAGE == 'amixer_75' ]]; then amixer -q cset numid=1 -- -364; fi
if [[ $MESSAGE == 'amixer_80' ]]; then amixer -q cset numid=1 -- -193; fi
if [[ $MESSAGE == 'amixer_85' ]]; then amixer -q cset numid=1 -- -32; fi
if [[ $MESSAGE == 'amixer_90' ]]; then amixer -q cset numid=1 -- 120; fi
if [[ $MESSAGE == 'amixer_95' ]]; then amixer -q cset numid=1 -- 263; fi
if [[ $MESSAGE == 'amixer_100' ]]; then amixer -q cset numid=1 -- 400; fi

