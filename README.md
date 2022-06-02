<!-- markdownlint-disable MD024 MD033 MD036 -->

# <img width="24px" src="https://github.com/NX211/homer-icons/raw/7cae0e85b9b822f884e81e657c1b2b49c8189b50/png/home-assistant.png" alt="Home Assistant"></img> Home Assistant setup

Layout designed mobile-first, fully optimized for all screen sizes.

![mobile_hero](https://user-images.githubusercontent.com/19761269/97078051-b3f93280-1606-11eb-86ba-9b1e0292af4f.png)

- [<img width="24px" src="https://github.com/NX211/homer-icons/raw/7cae0e85b9b822f884e81e657c1b2b49c8189b50/png/home-assistant.png" alt="Home Assistant"></img> Home Assistant setup](#img-home-assistant-setup)
  - [Hardware](#hardware)
  - [Themes](#themes)
  - [Implementations](#implementations)
    - [Control Alexa-connected devices](#control-alexa-connected-devices)
    - [Netgear Orbi integration](#netgear-orbi-integration)
    - [Soundbar control](#soundbar-control)
    - [Lo-fi beats](#lo-fi-beats)
- [Lovelace layout](#lovelace-layout)
  - [Dashboard](#dashboard)
    - [State row](#state-row)
    - [Graph row](#graph-row)
    - [Lights card](#lights-card)
    - [Switch rows](#switch-rows)
    - [Now Playing card](#now-playing-card)
  - [Controls view](#controls-view)
  - [Info view](#info-view)
    - [Graph rows](#graph-rows)
    - [Network stats](#network-stats)
  - [Tile view](#tile-view)
    - [Graph row](#graph-row-1)
    - [Info card](#info-card)
  - [Remote control view](#remote-control-view)
    - [Spotify player](#spotify-player)
    - [Voice assistant players](#voice-assistant-players)
  - [Plex/TV view](#plextv-view)
    - [Graph rows](#graph-rows-1)
    - [Plex/TV cards](#plextv-cards)
  - [Custom plugins used](#custom-plugins-used)
    - [Integrations](#integrations)
    - [Lovelace](#lovelace)

## Hardware

Home Assistant Container install on Raspberry Pi 4 with PostgreSQL database.

Full setup [here](https://github.com/agneevX/server-setup#nasmedia-server).

## Themes

For themes, head over to the [themes](themes/) folder.

---

[<i>Skip to lovelace layout</i>](#dashboard)

## Implementations

These are some of my custom implementations using Home Assistant:

### Control Alexa-connected devices

With custom component [`Alexa Media Player`](https://github.com/custom-components/alexa_media_player), Home Assistant is able to control any thing that you're able to speak to Alexa.

<details><summary>Expand</summary>

This requires the use of `input_boolean` helpers to control the state of the entity.

Since this uses the smart speaker, an internet connection is unfortunately required for this to work.

E.g. to control a smart plug...

```yaml
# configuration.yaml
switch:
  platform: template
  switches: 
    6a_plug:
      value_template: "{{ is_state('input_boolean.6a_plug_state', 'on') }}"
      turn_on:
        - service: input_boolean.turn_on
          entity_id: input_boolean.16a_plug_state
        - service: media_player.play_media
          entity_id: media_player.new_room_echo
          data:
            media_content_id: 'turn on 6a plug'
            media_content_type: custom

      turn_off:
        - service: input_boolean.turn_off
          entity_id: input_boolean.6a_plug_state
        - service: media_player.play_media
          entity_id: media_player.new_room_echo
          data:
            media_content_id: 'turn off 6a plug'
            media_content_type: custom
```

</details>

### Netgear Orbi integration

With custom firmware and bash scripts, statistics from router like current internet usage or monthly usage can be integrated into Home Assistant.

<details><summary>Expand</summary>

Requires [Voxel's firmware](https://www.voxel-firmware.com/Downloads/Voxel/html/index.html) and `entware` to be installed.

**Get current WAN usage**

Using `netdata`:

```sh
# ssh root@routerlogin.net
opkg install netdata
```

Add the Netdata integration to Home Assistant.

**Using `vnstat` to get total daily/monthly usage**

```sh
# Install on router
opkg install vnstat2

# Initialize WAN interface
vnstat2 --create -i eth0

# Restart vnstat daemon
/opt/etc/init.d/S32vnstat restart
```

```yaml
# configuration.yaml
# Daily usage
sensor:
 - platform: command_line
   name: Router daily WAN usage
   command: "/bin/bash /config/scripts/orbi_router.sh wan_daily"
   # Script in ./bash_scripts/orbi_router.sh
   scan_interval: 120
   value_template: "{{ value_json.id }}"
   json_attributes:
     - rx
     - tx

 - platform: template
   sensors:
    wan_daily_usage_up:
    friendly_name: WAN daily usage (upload)
    unit_of_measurement: 'MB'
    icon_template: mdi:arrow-down
    value_template: >-
      {% if state_attr('sensor.router_daily_wan_usage','tx') != None %}
        {{ (state_attr('sensor.router_daily_wan_usage','tx')|float/1000)|round }}
      {% else %} NaN {% endif %}

  wan_daily_usage_down:
    friendly_name: WAN daily usage (download)
    unit_of_measurement: 'MB'
    icon_template: mdi:arrow-up
    value_template: >-
      {% if state_attr('sensor.router_daily_wan_usage','rx') != None %}
        {{ (state_attr('sensor.router_daily_wan_usage','rx')|float/1000)|round }}
      {% else %} NaN {% endif %}
```

```yml
# configuration.yaml

# Monthly internet usage
sensor:
  - platform: command_line
    name: Router monthly WAN usage
    command: "/bin/bash /config/scripts/orbi_router.sh wan_monthly"
    scan_interval: 00:30:00
    value_template: "{{ value_json.index }}"
    json_attributes:
      - upload
      - download

  - platform: template
    sensors:
    wan_monthly_usage_up:
      friendly_name: WAN monthly usage (upload)
      unit_of_measurement: GB
      icon_template: mdi:upload
      value_template: >-
        {% if state_attr('sensor.router_monthly_wan_usage','upload') != None %}
          {{ (state_attr('sensor.router_monthly_wan_usage','upload') | float/976563)|round(1) }}
        {% else %} NaN {% endif %}

    wan_monthly_usage_down:
      friendly_name: WAN monthly usage (download)
      unit_of_measurement: GB
      icon_template: mdi:download
      value_template: >-
        {% if state_attr('sensor.router_monthly_wan_usage','download') != None %}
          {{ (state_attr('sensor.router_monthly_wan_usage','download') | float/976563)|round(1) }}
```

 </details>

### Soundbar control

Controls the volume of the Alsa mixer - 3.5mm headphone port on the Raspberry Pi.

<details><summary>Expand</summary>

This involves a `input_number` helper, an automation and a series of shell commands.

Requires `alsamixer` to be installed.

```yaml
# configuration.yaml
input_number:
  pi_volume:
    min: 0
    max: 100
    step: 5

automation: 
  - alias: Set soundbar volume
    trigger:
      - platform: state
        entity_id: input_number.pi_volume
    action:
      - service_template: shell_command.pi_volume_{{ trigger.to_state.state | int }

shell_command:
  pi_volume_0: echo amixer_0 | netcat localhost 7900
  pi_volume_5: echo amixer_5 | netcat localhost 7900

# Truncated. Full in ./config
```

Similar to above, the script calls the command `amixer` to increase or decrease the volume...

`hass_socket_script.sh`:

```bash
#!/bin/bash

if [[ $MESSAGE == 'amixer_0' ]]; then
  amixer -q cset numid=1 -- -10239
fi
if [[ $MESSAGE == 'amixer_5' ]]; then
  amixer -q cset numid=1 -- -7399
fi
# Truncated. Full in ./bash_scripts/hass_socket_script.sh
```

</details>

### Lo-fi beats

Stream lofi-beats from YouTube.

<details><summary>Expand</summary>

Compile Docker image:

```sh
# Clone repository
git clone https://github.com/agneevX/mpv-ytdl-docker
cd mpv-ytdl-docker
git checkout testing

# Build Docker image 
docker build -t mpv-ytdl:latest .
```

```yaml
# configuration.yaml
switch:
  platform: command_line
  switches:
    lofi_beats:
      command_on: echo "lofi_on" | nc localhost 7900
      command_off: echo "lofi_off" | nc localhost 7900
```

[`socat`](https://linux.die.net/man/1/socat) runs as a daemon in the background ([systemd unit file](./hass_socket.service)) and listens for commands.

Once a switch is turned on, this script is called that starts the playback...

`hass_socket_script.sh`:

```bash
#!/bin/bash
read MESSAGE

if [[ $MESSAGE == 'lofi_on' ]]; then 
  docker run -d --rm --name=lofi-beats -e "VIDEO_ID=abcdef" --device=/dev/snd:/dev/snd mpv-ytdl:latest
if [[ $MESSAGE == 'lofi_off' ]]; then
  docker stop lofi-beats
fi
# Truncated. Full in ./bash_scripts/hass_socket_script.sh
```

</details>

---

# Lovelace layout

## Dashboard

<!-- <img src="https://user-images.githubusercontent.com/19761269/125283392-02d22e00-e336-11eb-84db-ccd2ff87036d.PNG" alt="Dashboard view" align="right" width="270"> -->

![hero](https://user-images.githubusercontent.com/19761269/122021355-38d9cc00-cde3-11eb-8d34-7bee796123c2.png)

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L28)

### State row

- People presence
- ASUS laptop
- Front gate camera
- Mesh router satellite/reboot

### Graph row

- Bedroom temperature
- Bedroom humidity

### Lights card

- Desk light
  - ... Color temp card
- TV lamp
  - ... RGB card
- Soundbar volume

Custom implementation that controls alsa volume, using `input_boolean`, `shell_command` and an automation.

### Switch rows

- Adaptive Lighting
- Lofi beats/2/music radio
- Adaptive Lighting Sleep mode
- Bedroom AC/swing
- Bulb

### Now Playing card

- Automatically lists all active media players

---

<img src="https://user-images.githubusercontent.com/19761269/97079009-202b6480-160e-11eb-9fcd-c82dad5ff0c6.png" alt="Controls view" align="center" width="600">

## Controls view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L551)

- Front gate camera
- Bedroom AC HVAC
  - Controls

---

## Info view

<img src="https://user-images.githubusercontent.com/19761269/125282540-2183f500-e335-11eb-9ead-44e163a05383.PNG" alt="Info view" align="center" width="300">

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L630)

### Graph rows

- Internet download speed
- Internet upload speed

Custom sensors that fetch data from self-hosted [Speedtest-tracker](https://github.com/henrywhitaker3/Speedtest-Tracker) API.

### Network stats

- Router card
- Router live traffic in/out
- Total router traffic in/out (today)

Custom implementations that fetch data from Netdata and `vnstat`.

An `iframe` from Netdata is used for the live traffic graph.

---

<img src="https://user-images.githubusercontent.com/19761269/125281878-62c7d500-e334-11eb-839f-28de087fe30f.PNG" alt="Tile view" align="center" width="300">

## Tile view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L895)

### Graph row

- Orbi Satellite uptime
- Server network traffic in/out
- Total server traffic in/out (daily)

A combined card that graphs server network usage within the last half hour.

### Info card

- LAN clients card

Using the Netgear integration, this card shows all network-connected devices.

Dynamically sorted such that the last-updated device is always on top.

---

<img src="https://user-images.githubusercontent.com/19761269/125283407-0796e200-e336-11eb-8202-22b896f082f1.PNG" alt="Remote control view" align="center" width="300">

## Remote control view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1145)

### Spotify player

- Spotify media player
  - Playlist shortcuts
  - Soundbar source
  - Google Home source
  - Amazon Echo sources

**Self-hosted Spotify Connect using [`librespot`](https://github.com/spocon/spocon)**

<details><summary>Expand</summary>

```sh
# Pull Docker image
docker pull agneev/librespot-alsa

# 
docker run --network host -d /dev/snd:/dev/snd agneev/librespot-alsa

# Customize config file:
nano /opt/spocon/config.toml
```

</details>

### Voice assistant players

- Alexa media players
- Google Home media players

Custom integrations used for Alexa and Google Home.

---

<img src="https://user-images.githubusercontent.com/19761269/97078754-e0637d80-160b-11eb-8b52-b58072150705.png" alt="Plex view" align="center" width="600">

## Plex/TV view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1454)

### Graph rows

- Plex currently watching

This figure is obtained using the Plex integration.

### Plex/TV cards

- Plex media players
- TV media player

---

## Custom plugins used

### Integrations

- [`HACS`](https://github.com/hacs/integration) by [ludeeus](https://github.com/ludeeus)
- [`adaptive_lighting`](https://github.com/basnijholt/adaptive-lighting) by [basnijholt](https://github.com/basnijholt)
- [`Alexa Media Player`](https://github.com/custom-components/alexa_media_player)
- [`Smart IR`](https://github.com/smartHomeHub/SmartIR) by [smartHomeHub](https://github.com/smartHomeHub)

### Lovelace

- [`auto-entities`](https://github.com/thomasloven/lovelace-auto-entities) by [thomasloven](https://github.com/thomasloven)
- [`button-card`](https://github.com/custom-cards/button-card) by [RomRider](https://github.com/RomRider)
- [`card-mod`](https://github.com/thomasloven/lovelace-card-mod) by thomasloven
- [`custom-header`](https://github.com/maykar/custom-header) by [maykar](https://github.com/maykar)
- [`layout-card`](https://github.com/thomasloven/lovelace-layout-card) by thomasloven
- [`lovelace-swipe-navigation`](https://github.com/maykar/lovelace-swipe-navigation) by maykar
- [`mini-graph-card`](https://github.com/kalkih/mini-graph-card) by [kalkih](https://github.com/kalkih)
- [`mini-media-player`](https://github.com/kalkih/mini-media-player) by kalkih
- [`rgb-light-card`](https://github.com/bokub/rgb-light-card) by [bokub](https://github.com/bokub)
- [`simple-thermostat`](https://github.com/nervetattoo/simple-thermostat) by [nervetattoo](https://github.com/nervetattoo)
- [`slider-entity-row`](https://github.com/thomasloven/lovelace-slider-entity-row) by thomasloven
- [`template-entity-row`](https://github.com/thomasloven/lovelace-template-entity-row) by thomasloven
- [`uptime-card`](https://github.com/dylandoamaral/uptime-card) by [dylandoamaral](https://github.com/dylandoamaral)
