#!/bin/bash
read -r MESSAGE

docker_start () {
	docker run \
	--detach \
	--name="$1" \
	--restart=unless-stopped \
	--env="VIDEO_ID=$2" \
	--env="MPV_ARGS=--ao=alsa --no-video --no-config --really-quiet --demuxer-readahead-secs=30 --demuxer-max-back-bytes=0" \
	--device=/dev/snd:/dev/snd \
	agneev/mpv-ytdl:lofi > /dev/null \
	&& echo "Started the $1 container"
}

docker_stop () {
	docker stop "$1" > /dev/null \
	&& echo "Stopped the $1 container"

	docker rm --volumes "$1" > /dev/null \
	&& echo "Removed the $1 container"
}
if [[ $MESSAGE == 'purrple_cat_on' ]]; then
  docker_start purrple-cat bJUO1WnjXQY
fi
if [[ $MESSAGE == 'purrple_cat_off' ]]; then
  docker_stop purrple-cat
fi

if [[ $MESSAGE == 'lofi_on' ]]; then
  docker_start lofi-beats jfKfPfyJRdk
fi
if [[ $MESSAGE == 'lofi_off' ]]; then
  docker_stop lofi-beats
fi

if [[ $MESSAGE == 'lofi2_on' ]]; then
  docker_start lofi-beats2 rUxyKA_-grg
fi
if [[ $MESSAGE == 'lofi2_off' ]]; then
  docker_stop lofi-beats2
fi

if [[ $MESSAGE == 'the_good_life_radio_on' ]]; then
  docker_start the-good-life-radio 36YnV9STBqc
fi

if [[ $MESSAGE == 'the_good_life_radio_off' ]]; then
  docker_stop the-good-life-radio
fi

sound_level[0]="-10239"
sound_level[5]="-7399"
sound_level[10]="-5595"
sound_level[15]="-4538"
sound_level[20]="-3788"
sound_level[25]="-3206"
sound_level[30]="-2729"
sound_level[35]="-2326"
sound_level[36]="-2252"
sound_level[37]="-2180"
sound_level[38]="-2110"
sound_level[39]="-2042"
sound_level[40]="-1976"
sound_level[41]="-1911"
sound_level[42]="-1848"
sound_level[43]="-1786"
sound_level[44]="-1726"
sound_level[45]="-1667"
sound_level[46]="-1610"
sound_level[47]="-1554"
sound_level[48]="-1499"
sound_level[49]="-1445"
sound_level[50]="-1392"
sound_level[51]="-1340"
sound_level[52]="-1289"
sound_level[53]="-1239"
sound_level[54]="-1190"
sound_level[55]="-1142"
sound_level[56]="-1095"
sound_level[57]="-1049"
sound_level[58]="-1003"
sound_level[59]="-958"
sound_level[60]="-914"
sound_level[61]="-871"
sound_level[62]="-828"
sound_level[63]="-786"
sound_level[64]="-745"
sound_level[65]="-704"
sound_level[66]="-664"
sound_level[67]="-625"
sound_level[68]="-586"
#
sound_level[70]="-548"
sound_level[71]="-510"
sound_level[72]="-473"
sound_level[73]="-436"
sound_level[74]="-400"
sound_level[75]="-364"
sound_level[76]="-329"
sound_level[77]="-294"
sound_level[78]="-260"
sound_level[79]="-226"
sound_level[80]="-193"
sound_level[81]="-160"
sound_level[82]="-127"
sound_level[83]="-95"
sound_level[84]="-63"
sound_level[85]="-32"
sound_level[86]="-1"
sound_level[87]="30"
sound_level[88]="60"
sound_level[89]="90"
sound_level[90]="120"
sound_level[91]="149"
sound_level[92]="178"
sound_level[93]="207"
sound_level[94]="235"
sound_level[95]="263"
sound_level[96]="291"
sound_level[97]="319"
sound_level[98]="346"
sound_level[99]="373"
sound_level[100]="400"

if [[ $MESSAGE == *"amixer"* ]]; then
    amixer -q cset numid=1 -- $(echo ${sound_level[$(echo $MESSAGE | sed 's/amixer_//')]})
#    amixer -q cset numid=1 -- $(echo $MESSAGE | sed 's/amixer_//')%
    # echo "Set output to $(echo $MESSAGE | sed 's/amixer_//')%"
fi
