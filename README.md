<!-- markdownlint-disable MD024 MD033 -->
# Home Assistant setup

This layout was designed mobile-first.

![hero_shot](https://user-images.githubusercontent.com/19761269/97078051-b3f93280-1606-11eb-86ba-9b1e0292af4f.png)

- [Home Assistant setup](#home-assistant-setup)
  - [Background](#background)
  - [Themes](#themes)
  - [Add to HACS](#add-to-hacs)
  - [Custom implementations](#custom-implementations)
    - [Alexa devices control](#alexa-devices-control)
    - [Netgear Orbi integration](#netgear-orbi-integration)
    - [Soundbar control](#soundbar-control)
    - [Lo-fi beats](#lo-fi-beats)
  - [Lovelace layout](#lovelace-layout)
  - [Dashboard](#dashboard)
    - [Badges](#badges)
    - [State row](#state-row)
    - [Lights card](#lights-card)
    - [Switch rows](#switch-rows)
    - [Graph row](#graph-row)
    - [Now Playing card](#now-playing-card)
  - [Controls view](#controls-view)
  - [Info view](#info-view)
    - [TV state row](#tv-state-row)
    - [Graph row I/II](#graph-row-iii)
    - [Graph row III](#graph-row-iii-1)
    - [Graph row IV](#graph-row-iv)
    - [Info rows](#info-rows)
  - [Tile view](#tile-view)
    - [Graph/info rows](#graphinfo-rows)
    - [Devices card](#devices-card)
  - [Remote control view](#remote-control-view)
    - [Spotify player](#spotify-player)
    - [Alexa players](#alexa-players)
  - [Plex/TV view](#plextv-view)
    - [Graph rows](#graph-rows)
    - [Plex/TV players](#plextv-players)
  - [Custom plugins used](#custom-plugins-used)
    - [Integrations](#integrations)
    - [Lovelace](#lovelace)
  - [`secrets.yaml` code](#secretsyaml-code)
  - [Notes](#notes)
  - [Special thanks](#special-thanks)

## Background

Home Assistant Core installation on Raspberry Pi 4, with MySQL.

More details [here](https://github.com/agneevX/server-setup#nas-server).

## Themes

| **Milky White** | **Kinda Dark** | **Pure Black** |
| ----------- | ----------  | --------- |
| ![Milky White](https://user-images.githubusercontent.com/19761269/114695988-cf353700-9d39-11eb-92d9-9a4a5c181f32.PNG) | ![Kinda Dark](https://user-images.githubusercontent.com/19761269/114695994-d0666400-9d39-11eb-9f05-a03f7793c7f9.PNG) | ![Pure Black](https://user-images.githubusercontent.com/19761269/114695952-c9d7ec80-9d39-11eb-9632-628cb446678e.PNG) |

## Add to HACS

[![hacs_badge](https://img.shields.io/badge/HACS-Custom-orange.svg?style=for-the-badge)](https://github.com/custom-components/hacs)

This repository can be added to HACS as a custom repository. A guide can be found [here](https://hacs.xyz/docs/faq/custom_repositories/).

---

[<i>Skip to lovelace layout</i>](#dashboard)

## Custom implementations

These are some of my custom implementations using Home Assistant:

### Alexa devices control

With custom component [`Alexa Media Player`](https://github.com/custom-components/alexa_media_player), Home Assistant is able to control any thing that you're able to speak to Alexa.

<details><summary>Expand</summary>

This requires the use of `input_boolean` helpers to control the state of the entity.

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
          # Preferably set an Echo device that is rarely used 
          # as the Echo device actually carries out the command
          # in the foreground
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

---

### Netgear Orbi integration

Using custom firmware and bash scripts, I can integrate router stats like internet usage into Home Assistant

<details><summary>Expand for more info</summary>

Requires [Voxel's firmware](https://www.voxel-firmware.com/Downloads/Voxel/html/index.html) and `entware` to be installed.

`vnstat` is required to get usage stats:

```sh
ssh root@orbirouter.net

cd /opt/bin
./opkg install vnstat
./vnstat --create -i eth0
reboot
```

<b>Get live WAN in/out</b>

`configuration.yaml`:

```yaml
sensor:
  - platform: command_line
    name: Orbi Router WAN In
    command: !secret orbi_wan
    scan_interval: 5
    unit_of_measurement: 'Mb/s'
    value_template: "{{ (value_json.rx.bytespersecond|float/125000)|round(1) }}"
    json_attributes:
      - tx
```

`secrets.yaml`:

```yaml
orbi_wan: sshpass -p <password> ssh -o StrictHostKeyChecking=no root@orbirouter.net /opt/bin/vnstat --json -tr 2
```

<b>Get daily WAN usage (total)</b>

`configuration.yaml`:

```yaml
sensor:
  - platform: command_line
    name: Orbi Router vnstat
    command: "/bin/bash /home/homeassistant/.homeassistant/multiple_actions.sh orbi_vnstat"
    # Script in ./bash_scripts/multiple_actions.sh
    scan_interval: 120
    value_template: "{{ (value_json.id) }}"
    json_attributes:
      - rx
      - tx
  - platform: template
    sensors:
      orbi_router_wan_in_total:
        friendly_name: Orbi Router WAN In (total)
        unit_of_measurement: 'MB'
        value_template: "{{ (state_attr('sensor.orbi_router_vnstat','rx')|float/1000)|round }}"
        icon_template: mdi:arrow-down
      orbi_router_wan_out_total:
        friendly_name: Orbi Router WAN Out (total)
        unit_of_measurement: 'MB'
        value_template: "{{ (state_attr('sensor.orbi_router_vnstat','tx')|float/1000)|round }}"
        icon_template: mdi:arrow-up
```

</details>

---

### Soundbar control

Controls the volume of ALSA - 3.5mm port on the Raspberry Pi. Requires `alsamixer` to be installed.

This involves a `input_number` helper, an automation and a series of shell commands.

<details><summary>Expand</summary>

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
    - service_template: shell_command.pi_volume_{{ trigger.to_state.state | int }}
shell_command:
  pi_volume_0: echo amixer_0 | netcat localhost 7900
  pi_volume_5: echo amixer_5 | netcat localhost 7900
# Truncated. Full in ./config
```

Similar to above, the script calls the command `amixer` to increase or decrease the volume...

`hass_socket_script.sh`:

```bash
#!/bin/bash

if [[ $MESSAGE == 'amixer_0' ]]; then amixer -q cset numid=1 -- -10239; fi
if [[ $MESSAGE == 'amixer_5' ]]; then amixer -q cset numid=1 -- -7399; fi
# Truncated. Full in ./bash_scripts/hass_socket_script.sh
```

</details>

---

### Lo-fi beats

Plays Lo-fi beats live stream from YouTube.

This requires `screen`, `mpv` and `youtube-dl`/`youtube-dlc` to be installed.

<details><summary>Expand</summary>

```yaml
# configuration.yaml
switch:
  platform: command_line
  switches:
    lofi_beats:
      command_on: echo "lofi_on" | netcat localhost 7900
      command_off: echo "lofi_off" | netcat localhost 7900
```

[`socat`](https://linux.die.net/man/1/socat) runs in the background ([systemd service file](./hass_socket.service)) and listens for commands.

Once a switch is turned on, this script is called that starts the playback...

`hass_socket_script.sh`:

```bash
#!/bin/bash
read MESSAGE

if [[ $MESSAGE == 'lofi_on' ]]; then 
  screen -S lofi -dm /usr/bin/mpv --no-video $(/path/to/youtube-dlc -g -f 95 5qap5aO4i9A); fi
if [[ $MESSAGE == 'lofi_off' ]]; then screen -S lofi -X quit; fi
# Truncated. Full in ./bash_scripts/hass_socket_script.sh
```

</details>

## Lovelace layout

## Dashboard

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L29)

![home_view](https://user-images.githubusercontent.com/19761269/97078367-7649d900-1609-11eb-9fb1-4f5ff511c39c.png "Home view")

### Badges

- *People presence*
- Router WAN in/out
- HACS updates

_This is the only view that contain badges._

### State row

- `/drive` mount
- ASUS laptop
- `always-on` server
- Front gate camera
- Mesh router satellite/reboot[<sup>⬇️<sup>](#secretsyaml-code)

### Lights card

- Desk light
  - ... Color temp card
- TV lamp
  - ... RGB card
- Soundbar volume

Custom implementation that controls alsa volume, using `input_boolean`, `shell_command` and an automation.

### Switch rows

- Night mode
- Adaptive Lighting
- Lofi beats
- Lofi beats 2
- Jazz radio
- AdGuard Home
- Bedroom AC
- Refresh Plex
- qBittorrent alt. speed mode[<sup>⬇️<sup>](#secretsyaml-code)
- 16A plug

### Graph row

- Bedroom temperature
- Bedroom humidity

### Now Playing card

- Automatically lists all active media players

---

## Controls view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L651)

![controls_view](https://user-images.githubusercontent.com/19761269/97079009-202b6480-160e-11eb-9fcd-c82dad5ff0c6.png "Controls view")

- Front gate camera
- Bedroom AC HVAC
  - Controls
  - Automations

---

## Info view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L819)

![info_view](https://user-images.githubusercontent.com/19761269/97078363-721dbb80-1609-11eb-8a87-a9b477705d37.png "Info view")

### TV state row

Tracks states of specific TVs.

### Graph row I/II

- Internet health
- Download speed (Speedtest.net)
- Upload speed (Speedtest.net)

Custom-made sensor that uses the official [Speedtest.net CLI](https://www.speedtest.net/apps/cli) instead of the rather inaccurate `speedtest-cli`.

### Graph row III

- Router live traffic in/out[<sup>⬆<sup>](#netgear-orbi-integration)
- Total router traffic[<sup>⬆<sup>](#netgear-orbi-integration)

Custom implementation that polls data from router via SSH.

### Graph row IV

- Current server network in/out
- Total server traffic in/out (today)

A combined card that graphs server network usage within the last hour.

Custom-made sensor that gets network traffic from `vnstat`.

### Info rows

- qBittorrent active torrents[<sup>⬇️<sup>](#secretsyaml-code)
- qBittorrent upload/download speed
- SSD free %
- `/knox` free %
- Orbi router info

---

## Tile view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1381)

![tile_view](https://user-images.githubusercontent.com/19761269/97079345-bfe9f200-1610-11eb-8d9a-067a70ea137c.png "Tile view")

### Graph/info rows

- ISP node state
- Radarr/Radarr4K/Sonarr queue[<sup>⬇️<sup>](#secretsyaml-code)
- Sonarr shows/wanted episodes

### Devices card

- LAN clients

Using the Netgear integration, this card shows all network-connected devices. Dynamically sorted such that the last-updated device is always on top.

---

## Remote control view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1563)

![rc_view](https://user-images.githubusercontent.com/19761269/97078368-76e26f80-1609-11eb-82ef-3746e93b556d.png "Remote control view")

### Spotify player

- Spotify media player
  - Playlist shortcuts
  - Soundbar source
  - Bedroom Echo source

### Alexa players

- Household Echo media players
- *... switches*
  - Do Not Disturb
  - Repeat
  - Shuffle
- Alexa Everywhere media player

---

## Plex/TV view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1838)

![plex_view](https://user-images.githubusercontent.com/19761269/97078754-e0637d80-160b-11eb-8b52-b58072150705.png "Plex view")

### Graph rows

- Plex currently watching
- Tautulli current bandwidth
- Network in/out

The four graph cards provide an overview of Plex/network activity in one place and indicates potential network issues.

### Plex/TV players

- Conditional cards...
  - Header cards
  - TV player cards
  - Plex media players

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
- [`config-template-card`](https://github.com/iantrich/config-template-card) by [iantrich](https://github.com/iantrich)
- [`custom-header`](https://github.com/maykar/custom-header) by [maykar](https://github.com/maykar)
- [`lovelace-swipe-navigation`](https://github.com/maykar/lovelace-swipe-navigation) by maykar
- [`mini-graph-card`](https://github.com/kalkih/mini-graph-card) by [kalkih](https://github.com/kalkih)
- [`mini-media-player`](https://github.com/kalkih/mini-media-player) by kalkih
- [`rgb-light-card`](https://github.com/bokub/rgb-light-card) by [bokub](https://github.com/bokub)
- [`simple-thermostat`](https://github.com/nervetattoo/simple-thermostat) by [nervetattoo](https://github.com/nervetattoo)
- [`slider-entity-row`](https://github.com/thomasloven/lovelace-slider-entity-row) by thomasloven
- [`uptime-card`](https://github.com/dylandoamaral/uptime-card) by [dylandoamaral](https://github.com/dylandoamaral)
- [`vertical-stack-in-card`](https://github.com/ofekashery/vertical-stack-in-card) by [ofekashery](https://github.com/ofekashery)

---

## `secrets.yaml` code

```yaml
radarr_queue: curl -s 'http://127.0.0.1:9100/api/v3/queue?apiKey=<password>&pageSize=100&includeUnknownMovieItems=false'
radarr4k_queue: curl -s 'http://127.0.0.1:9200/api/v3/queue?apiKey=<password>&pageSize=100&includeUnknownMovieItems=false'
qbt_alt_limit_state: curl -s http://10.0.0.11:8100/api/v2/transfer/speedLimitsMode
qbt_active_torrents: curl -s http://10.0.0.11:8100/api/v2/torrents/info?filter=active | grep -o -i f_l_piece_prio | wc -l
int_qbt_alt_limit: curl -s http://10.0.0.11:8100/api/v2/transfer/toggleSpeedLimitsMode
reboot_orbi_satellite: sshpass -p <password> ssh -o StrictHostKeyChecking=no root@10.0.0.2 /sbin/reboot
```

---

## Notes

- `int` are "internal" entities that are used inside templates.
- The header that is used for separating cards is from [soft-ui](https://github.com/N-l1/lovelace-soft-ui).

---

## Special thanks

- to all authors above,
- and all the very helpful folks over at the Discord.
