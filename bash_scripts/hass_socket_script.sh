#!/bin/bash
read -r MESSAGE

docker_start () {
        docker run \
        --rm \
        --detach \
        --name="$1" \
        --device=/dev/snd:/dev/snd \
        agneev/mpv-ytdl:master \
                --really-quiet \
                --no-video \
                --ytdl-format="bestvideo[height<=720]+bestaudio/best[height<=720]" \
                "https://www.youtube.com/watch?v=$2" \
        && echo "Started the $1 container"
}

docker_stop () {
        docker stop "$1" > /dev/null \
        && echo "Stopped the $1 container"
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

if [[ $MESSAGE == 'lofi_synthwave_on' ]]; then
  docker_start lofi-synthwave MVPTGNGiI-4
fi

if [[ $MESSAGE == 'lofi_synthwave_off' ]]; then
  docker_stop lofi-synthwave
fi

if [[ $MESSAGE == 'the_good_life_radio_on' ]]; then
  docker_start the-good-life-radio 36YnV9STBqc
fi

if [[ $MESSAGE == 'the_good_life_radio_off' ]]; then
  docker_stop the-good-life-radio
fi

if [[ $MESSAGE == *"amixer"* ]]; then
    amixer -q -M set Headphone $(echo $MESSAGE | sed 's/amixer_//')%
    echo "Set audio output to $(echo $MESSAGE | sed 's/amixer_//')%"
fi
