<!-- markdownlint-disable MD024 MD033 -->
# My Home Assistant setup

This layout was designed mobile-first.

![hero_shot](https://user-images.githubusercontent.com/19761269/97078051-b3f93280-1606-11eb-86ba-9b1e0292af4f.png)

- [My Home Assistant setup](#my-home-assistant-setup)
  - [Background](#background)
    - [MariaDB install](#mariadb-install)
    - [Home Assistant install](#home-assistant-install)
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
    - [Info row I](#info-row-i)
    - [Info row II](#info-row-ii)
  - [Tile view](#tile-view)
    - [Internet graphs](#internet-graphs)
    - [Radarr/Sonarr cards](#radarrsonarr-cards)
    - [Devices card](#devices-card)
  - [Remote control view](#remote-control-view)
    - [Spotify player](#spotify-player)
    - [MPD player](#mpd-player)
    - [Alexa players](#alexa-players)
  - [Plex view](#plex-view)
    - [Graph row I](#graph-row-i-2)
    - [Graph row II](#graph-row-ii-1)
    - [Plex players](#plex-players)
  - [Television view](#television-view)
    - [TV players](#tv-players)
  - [Custom plugins used](#custom-plugins-used)
    - [Integrations](#integrations)
    - [Lovelace](#lovelace)
  - [Notes](#notes)
  - [Special thanks](#special-thanks)

## Background

Home Assistant Core installation on Raspberry Pi 4, with MariaDB.

More details [here](https://github.com/agneevX/server-setup).

<details><summary>Install steps ⤵️</summary>

### MariaDB install

1. Install MariaDB using APT...

```bash
sudo apt install -yq mariadb-server
```

2. Follow [this](https://kevinfronczak.com/blog/mysql-with-homeassistant#create-mysql-database-for-home-assistant) guide to the end.

### Home Assistant install

1. [Main guide](https://www.home-assistant.io/docs/installation/raspberry-pi/)
2. Start Home Assistant and enable auto-start on boot:

```bash
cd /tmp; curl https://raw.githubusercontent.com/agneevX/my-ha-setup/master/hassio.service > hassio.service
sudo mv hassio.service /etc/systemd/system
sudo systemctl enable --now hassio.service
```

</details>

---

## Lovelace layout

## Dashboard

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L34)

![home_view](https://user-images.githubusercontent.com/19761269/97078367-7649d900-1609-11eb-9fb1-4f5ff511c39c.png "Home view")

All cards in this view are in a single vertical stack.

### Badges

- CPU use
- System load
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

- Night lamp
- Color flow
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
- Internet health

Indicates if there's any packet loss within the last hour.

### Now Playing card

- Automatically lists all active media players

---

## Controls view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L671)

![controls_view](https://user-images.githubusercontent.com/19761269/97079009-202b6480-160e-11eb-9fcd-c82dad5ff0c6.png "Controls view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

- Front gate camera
- Adaptive Lighting switches

<p align="center">
  <b>Vertical stack 2</b>
</p>

- Bedroom AC
  - ... addl. controls

---

## Info view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L888)

![info_view](https://user-images.githubusercontent.com/19761269/97078363-721dbb80-1609-11eb-8a87-a9b477705d37.png "Info view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### TV state row

Tracks states of specific TVs.

### Graph row I

- CPU temp.
- AdGuard Home avg. processing time
- Bedroom humidity

### Graph row II

- Download speed (Speedtest.net)
- Upload speed (Speedtest.net)

Custom-made sensor that uses the official Speedtest.net CLI instead of the rather inaccurate `speedtest-cli`.

### Graph row III

- Current network in
- Current network out
- Today total traffic in
- Today total traffic out

A combined card that graphs network usage within the last hour.

Custom-made sensor that gets network traffic from `vnstat`.

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Info row I

- qBittorrent active torrents
- qBittorrent upload speed
- qBittorrent download speed

### Info row II

- SSD free %
- `/knox` free %
- `/knox` free space

---

## Tile view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1373)

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
- Sonarr wanted episodes

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Devices card

- Network devices list

Using the Netgear integration, this card shows all network-connected devices. Dynamically sorted such that the last updated device is always on top.

---

## Remote control view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1573)

![rc_view](https://user-images.githubusercontent.com/19761269/97078368-76e26f80-1609-11eb-82ef-3746e93b556d.png "Remote control view")

### Spotify player

- Spotify media player
  - Playlist shortcuts
  - Soundbar source
  - Bedroom Echo source

### MPD player

- `Mopidy-mpd` media player

### Alexa players

- Household Echo media players
- *... switches*
  - Do Not Disturb
  - Repeat
  - Shuffle
- Alexa Everywhere media player

---

## Plex view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1859)

![plex_view](https://user-images.githubusercontent.com/19761269/97078754-e0637d80-160b-11eb-8b52-b58072150705.png "Plex view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### Graph row I

- Plex Watching
- Tautulli current bandwidth

### Graph row II

- Network in
- Network out

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Plex players

- Conditional cards...
  - Header cards
  - Plex media players

The four graph cards provide an overview of Plex/network activity in one place and indicates potential network issues.

---

## Television view

[Jump to lovelace code](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L2186)

![tv_view](https://user-images.githubusercontent.com/19761269/97078361-6cc07100-1609-11eb-9c9c-6390ebb47308.png "TV view")

### TV players

- Header cards
- TV media players

---

## Custom plugins used

### Integrations

- [`HACS`](https://github.com/hacs/integration) by [ludeeus](https://github.com/ludeeus)
- [`adaptive_lighting`](https://github.com/basnijholt/adaptive-lighting) by [basnijholt](https://github.com/basnijholt)
- [`Alexa Media Player`](https://github.com/custom-components/alexa_media_player)
- [`Circadian Lighting`](https://github.com/claytonjn/hass-circadian_lighting) by [claytonjn](https://github.com/claytonjn)
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

- Screenshots may not be up-to-date.
- Entities beginning with `int` are "internal" entities that are used inside templates.
- Shutting down/Rebooting X200M involves a program named `Assistant Computer Control` that runs on the laptop.
  - A cURL request calls a IFTTT webhook which writes a specific phrase in a file inside OneDrive that the software is able to recognize and perform actions accordingly.
- The header that is used for separating cards is from [soft-ui](https://github.com/N-l1/lovelace-soft-ui).

---

## Special thanks

- to all authors above,
- and all the very helpful folks over at the Discord.
