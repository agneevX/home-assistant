<!-- markdownlint-disable MD024 MD033 -->
# Home Assistant setup

This layout was designed mobile-first.

![hero_shot](https://user-images.githubusercontent.com/19761269/97078051-b3f93280-1606-11eb-86ba-9b1e0292af4f.png)

- [Home Assistant setup](#home-assistant-setup)
  - [Background](#background)
  - [Custom implementations](#custom-implementations)
    - [Alexa devices control](#alexa-devices-control)
    - [Internet health](#internet-health)
    - [Lo-fi beats](#lo-fi-beats)
    - [Soundbar control](#soundbar-control)
  - [Lovelace layout](#lovelace-layout)
  - [Dashboard](#dashboard)
    - [Badges](#badges)
    - [State row](#state-row)
    - [Lights card](#lights-card)
    - [Switch row I](#switch-row-i)
    - [Switch row II](#switch-row-ii)
    - [Graph row I](#graph-row-i)
    - [Now Playing card](#now-playing-card)
  - [Controls view](#controls-view)
  - [Info view](#info-view)
    - [TV state row](#tv-state-row)
    - [Graph row I](#graph-row-i-1)
    - [Graph row II](#graph-row-ii)
    - [Graph row III](#graph-row-iii)
    - [Graph row IV](#graph-row-iv)
    - [Info row I](#info-row-i)
    - [Graph row V](#graph-row-v)
  - [Tile view](#tile-view)
    - [Internet graphs](#internet-graphs)
    - [Radarr/Sonarr cards](#radarrsonarr-cards)
    - [Info row](#info-row)
    - [Devices card](#devices-card)
  - [Remote control view](#remote-control-view)
    - [Spotify player](#spotify-player)
    - [Alexa players](#alexa-players)
  - [Plex/TV view](#plextv-view)
    - [Graph row I](#graph-row-i-2)
    - [Graph row II](#graph-row-ii-1)
    - [Plex/TV players](#plextv-players)
  - [Custom plugins used](#custom-plugins-used)
    - [Integrations](#integrations)
    - [Lovelace](#lovelace)
  - [Notes](#notes)
  - [Special thanks](#special-thanks)

## Background

Home Assistant Core installation on Raspberry Pi 4, with MySQL.

More details [here](https://github.com/agneevX/server-setup).

---

[<i>Skip to lovelace layout</i>](#dashboard)

## Custom implementations

These are some of my custom implementations using Home Assistant:

### Alexa devices control

With custom component `Alexa Media Player`, Home Assistant is able to control any thing that you're able to speak to Alexa.

This requires the use of `input_boolean` helpers to control the state of the entity.

E.g. to control a plug...

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
          # Preferably set an Echo device that is rarely used as the echo device actually carries out the command in the foreground
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

### Internet health

Shows internet packet loss in `%`, if any. Useful for real-time applications like gaming or VoIP calls.

```yaml
# configuration.yaml
binary_sensor:
  - platform: ping
    name: Cloudflare DNS ping
    host: 1.1.1.1
    count: 1
    scan_interval: 2
sensor:
  - platform: history_stats
    name: int_internet_health
    entity_id: binary_sensor.cloudflare_dns_ping
    state: "on"
    type: ratio
    end: "{{ now() }}"
    duration: 00:05:00
  - platform: template
    sensors: 
      internet_health:
        friendly_name: Internet Health
        value_template: "{{ states('sensor.int_internet_health') | round }}"
        icon_template: mdi:ethernet-cable
        unit_of_measurement: '%'
```

### Lo-fi beats

Plays Lo-fi beats live stream from YouTube.

This requires `screen`, `mpv` and `youtube-dl`/`youtube-dlc` to be installed.

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
# Truncated. Full in ./hass_socket_script.sh
```

### Soundbar control

Controls the volume of ALSA - 3.5mm port on the Raspberry Pi. Requires `alsamixer` to be installed.

This involves a `input_number` helper, an automation and a series of shell commands.

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
# Truncated. Full in ./hass_socket_script.sh
```

---

## Lovelace layout

## Dashboard

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L29)

![home_view](https://user-images.githubusercontent.com/19761269/97078367-7649d900-1609-11eb-9fb1-4f5ff511c39c.png "Home view")

### Badges

- *People presence*
- Network in
- Network out
- HACS updates

_This is the only view that contain badges._

<p align="center">
  <b>Vertical stack 1</b>
</p>

### State row

- `/drive` mount
- ASUS laptop
- `always-on` server
- Front gate camera
- Mesh router satellite

### Lights card

- Desk light
  - ... Color temp card
- TV lamp
  - ... RGB card
- Soundbar volume

Custom implementation that controls alsa volume, using `input_boolean`, `shell_command` and an automation.

### Switch row I

- Night mode
- Adaptive Lighting
- Lo-Fi beats
- Lo-Fi beats 2
- Jazz radio

### Switch row II

- AdGuard Home
- Bedroom AC
- Refresh Plex
- qBittorrent alt. speed mode
- 16A plug

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Graph row I

- Bedroom temperature
- Bedroom humidity

### Now Playing card

- Automatically lists all active media players

---

## Controls view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L648)

![controls_view](https://user-images.githubusercontent.com/19761269/97079009-202b6480-160e-11eb-9fcd-c82dad5ff0c6.png "Controls view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

- Front gate camera

<p align="center">
  <b>Vertical stack 2</b>
</p>

- Bedroom AC
  - ... addl. controls
- Bedroom AC automations

---

## Info view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L816)

![info_view](https://user-images.githubusercontent.com/19761269/97078363-721dbb80-1609-11eb-8a87-a9b477705d37.png "Info view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### TV state row

Tracks states of specific TVs.

### Graph row I

- CPU temp.
- Internet health

### Graph row II

- Download speed (Speedtest.net)
- Upload speed (Speedtest.net)

Custom-made sensor that uses the official [Speedtest.net CLI](https://www.speedtest.net/apps/cli) instead of the rather inaccurate `speedtest-cli`.

### Graph row III

- Router live traffic in/out
- Total router traffic

Custom implementation that polls data from router via SSH.

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Graph row IV

- Current server network in/out
- Total server traffic in/out (today)

A combined card that graphs server network usage within the last hour.

Custom-made sensor that gets network traffic from `vnstat`.

### Info row I

- qBittorrent active torrents
- qBittorrent upload/download speed

### Graph row V

- ISP node state monitor

---

## Tile view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1349)

![tile_view](https://user-images.githubusercontent.com/19761269/97079345-bfe9f200-1610-11eb-8d9a-067a70ea137c.png "Tile view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### Internet graphs

- Node ping
- Internet ping

Graphs pings to local ISP node and Cloudflare DNS. This card is very helpful in isolating network issues.

### Radarr/Sonarr cards

- Radarr/Sonarr ongoing commands
- Radarr/Sonarr queue

### Info row

- SSD free %
- `/knox` free %
- Orbi router info

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Devices card

- Network devices list

Using the Netgear integration, this card shows all network-connected devices. Dynamically sorted such that the last updated device is always on top.

---

## Remote control view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1568)

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

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1843)

![plex_view](https://user-images.githubusercontent.com/19761269/97078754-e0637d80-160b-11eb-8b52-b58072150705.png "Plex view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### Graph row I

- Plex currently watching
- Tautulli current bandwidth

### Graph row II

- Network in
- Network out

The four graph cards provide an overview of Plex/network activity in one place and indicates potential network issues.

<p align="center">
  <b>Vertical stack 2</b>
</p>

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
- [`vertical-stack-in-card`](https://github.com/ofekashery/vertical-stack-in-card) by [ofekashery](https://github.com/ofekashery)

---

## Notes

- `int` are "internal" entities that are used inside templates.
- Shutting down/Rebooting X200M involves a program named `Assistant Computer Control` that runs on the laptop.
  - A cURL request calls a IFTTT webhook which writes a specific phrase in a file inside OneDrive that the software is able to recognize and perform actions accordingly.
- The header that is used for separating cards is from [soft-ui](https://github.com/N-l1/lovelace-soft-ui).

---

## Special thanks

- to all authors above,
- and all the very helpful folks over at the Discord.
