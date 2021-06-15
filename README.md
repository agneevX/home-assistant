<!-- markdownlint-disable MD024 MD033 MD036 -->
# Home Assistant setup

Layout designed mobile-first, fully optimized for all screen sizes.

![hero_shot](https://user-images.githubusercontent.com/19761269/97078051-b3f93280-1606-11eb-86ba-9b1e0292af4f.png)

- [Home Assistant setup](#home-assistant-setup)
  - [Background](#background)
  - [Themes](#themes)
  - [Custom implementations](#custom-implementations)
    - [Alexa devices control](#alexa-devices-control)
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
    - [Sensor cards](#sensor-cards)
  - [Tile view](#tile-view)
    - [Graph row](#graph-row-1)
    - [Info cards](#info-cards)
  - [Remote control view](#remote-control-view)
    - [Spotify player](#spotify-player)
    - [Alexa players](#alexa-players)
  - [Plex/TV view](#plextv-view)
    - [TV state row](#tv-state-row)
    - [Graph rows](#graph-rows-1)
    - [Plex/TV cards](#plextv-cards)
  - [Custom plugins used](#custom-plugins-used)
    - [Integrations](#integrations)
    - [Lovelace](#lovelace)
  - [secrets.yaml code](#secretsyaml-code)
  - [Notes](#notes)
  - [Special thanks](#special-thanks)

## Background

Home Assistant Core installation on Raspberry Pi 4, with MySQL database.

More details [here](https://github.com/agneevX/server-setup#nas-server).

## Themes

<img src="https://img.shields.io/badge/HACS-Custom-orange.svg?style=for-the-badge" href="https://github.com/custom-components/hacs" alt="HACS badge" align="right">

The [themes](../themes) in this repository can be [added](https://hacs.xyz/docs/faq/custom_repositories) to Home Assistant via HACS as a custom repository (select `Themes` as category).

| **Milky White** | **Kinda Dark** | **Pure Black** |
| :-: | :-: | :-: |
| ![Milky White](https://user-images.githubusercontent.com/19761269/114695988-cf353700-9d39-11eb-92d9-9a4a5c181f32.PNG) | ![Kinda Dark](https://user-images.githubusercontent.com/19761269/114695994-d0666400-9d39-11eb-9f05-a03f7793c7f9.PNG) | ![Pure Black](https://user-images.githubusercontent.com/19761269/114695952-c9d7ec80-9d39-11eb-9632-628cb446678e.PNG) |

Three individual themes + two combined light/dark themes (requires Home Assistant 2021.6+).

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

With custom firmware and using bash scripts, router stats like internet usage can be integrated into Home Assistant.

<details><summary>Expand</summary>

Requires [Voxel's firmware](https://www.voxel-firmware.com/Downloads/Voxel/html/index.html) and `entware` to be installed.

**To get live WAN stats**

Using `netdata`:

```sh
opkg install netdata
```

Add to Home Assistant via Netdata integration.

**To get daily total WAN usage**

Using `vnstat`:

```sh
opkg install vnstat
vnstat --create -i brwan
reboot
```

```yaml
# configuration.yaml
sensor:
  - platform: command_line
    name: Orbi Router vnstat (total)
    command: "/bin/bash /home/homeassistant/scripts/orbi_router.sh vnstat_total"
    # Script in ./bash_scripts/orbi_router.sh
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
        value_template: "{{ (state_attr('sensor.orbi_router_total_vnstat','rx')|float/1000)|round }}"
        icon_template: mdi:arrow-down
      orbi_router_wan_out_total:
        friendly_name: Orbi Router WAN Out (total)
        unit_of_measurement: 'MB'
        value_template: "{{ (state_attr('sensor.orbi_router_total_vnstat','tx')|float/1000)|round }}"
        icon_template: mdi:arrow-up
```

</details>

### Soundbar control

Controls the volume of ALSA - 3.5mm port on the Raspberry Pi.

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

### Lo-fi beats

Plays Lo-fi beats live stream from YouTube.

Requires `screen`, `mpv` and `youtube-dl`/`youtube-dlc` to be installed.

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

[`socat`](https://linux.die.net/man/1/socat) runs in the background ([systemd unit file](./hass_socket.service)) and listens for commands.

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

---

# Lovelace layout

## Dashboard

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L27)

![dashboard](https://user-images.githubusercontent.com/19761269/122021355-38d9cc00-cde3-11eb-8d34-7bee796123c2.png "Dashboard")

<!-- ![home_view](https://user-images.githubusercontent.com/19761269/97078367-7649d900-1609-11eb-9fb1-4f5ff511c39c.png "Home view") -->

### State row

- Person presence
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
- Lofi beats/2/Jazz radio
- Sleep mode
- Bedroom AC
- AdGuard Home
- Refresh Plex

### Now Playing card

- Automatically lists all active media players

---

## Controls view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L551)

![controls_view](https://user-images.githubusercontent.com/19761269/97079009-202b6480-160e-11eb-9fcd-c82dad5ff0c6.png "Controls view")

- Front gate camera
- Bedroom AC HVAC
  - Controls
  - Automations

---

## Info view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L698)

![info_view](https://user-images.githubusercontent.com/19761269/97078363-721dbb80-1609-11eb-8a87-a9b477705d37.png "Info view")

### Graph rows

- Internet health
- Download speed (Speedtest.net)
- Upload speed (Speedtest.net)

Custom-made sensor that uses the official [Speedtest.net CLI](https://www.speedtest.net/apps/cli) instead of the rather inaccurate `speedtest-cli`.

### Network stats

- Router state/system load
- Router live traffic in/out [<sup>⬆<sup>](#netgear-orbi-integration)
- Total router traffic [<sup>⬆<sup>](#netgear-orbi-integration)

Custom implementations that poll data via Netdata, and `vnstat`.

### Sensor cards

- HACS
- qBittorrent card
- Radarr/Sonarr card
- Storage stats card

---

## Tile view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1049)

![tile_view](https://user-images.githubusercontent.com/19761269/97079345-bfe9f200-1610-11eb-8d9a-067a70ea137c.png "Tile view")

### Graph row

- ISP node state
- Current server network in/out
- Total server traffic in/out (today)

A combined card that graphs server network usage within the last half hour.

### Info cards

- Monthly internet traffic card
- LAN clients card

Using the nmap integration, this card shows all network-connected devices.

Dynamically sorted such that the last-updated device is always on top.

---

## Remote control view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1291)

![rc_view](https://user-images.githubusercontent.com/19761269/97078368-76e26f80-1609-11eb-82ef-3746e93b556d.png "Remote control view")

### Spotify player

- Spotify media player
  - Playlist shortcuts
  - Soundbar source
  - Amazon Echo sources

### Alexa players

- Echo media players & switches
- Alexa Everywhere media player

---

## Plex/TV view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1552)

![plex_view](https://user-images.githubusercontent.com/19761269/97078754-e0637d80-160b-11eb-8b52-b58072150705.png "Plex view")

### TV state row

Tracks states of specific TVs.

### Graph rows

- Plex currently watching
- Tautulli current bandwidth

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
- [`vertical-stack-in-card`](https://github.com/ofekashery/vertical-stack-in-card) by [ofekashery](https://github.com/ofekashery)

---

## secrets.yaml code

```yaml
radarr_queue: curl -s 'http://127.0.0.1:7878/api/v3/queue?apikey=<API_KEY>&pageSize=100&includeUnknownMovieItems=false'
radarr4k_queue: curl -s 'http://127.0.0.1:7879/api/v3/queue?apikey=<API_KEY>&pageSize=100&includeUnknownMovieItems=false'
reboot_orbi_satellite: sshpass -p <PASSWORD> ssh -o StrictHostKeyChecking=no root@10.0.0.2 /sbin/reboot
```

---

## Notes

- `int` are "internal" entities that are used inside templates.
- The header that is used for separating cards is from [soft-ui](https://github.com/N-l1/lovelace-soft-ui).

---

## Special thanks

- to all authors above,
- and all the very helpful folks over at the Discord.
