<!-- markdownlint-disable MD024 -->
# My Home Assistant setup

This layout was designed mobile-first.

![hero_shot](https://user-images.githubusercontent.com/19761269/91996026-2449ad00-ed56-11ea-85b3-d2d8bcfc4b23.png)

- [My Home Assistant setup](#my-home-assistant-setup)
  - [Background](#background)
  - [Lovelace layout](#lovelace-layout)
  - [Dashboard (home view)](#dashboard-home-view)
    - [Badges](#badges)
    - [State row](#state-row)
    - [Lights card](#lights-card)
    - [Switch row I](#switch-row-i)
    - [Switch row II](#switch-row-ii)
    - [Graph row I](#graph-row-i)
    - [Graph row II](#graph-row-ii)
    - [Now Playing card](#now-playing-card)
  - [Info view](#info-view)
    - [Graph row I](#graph-row-i-1)
    - [Graph row II](#graph-row-ii-1)
    - [Graph row III](#graph-row-iii)
    - [Info row I](#info-row-i)
    - [Info row II](#info-row-ii)
    - [Internet graphs](#internet-graphs)
  - [Tile view](#tile-view)
    - [TV state row](#tv-state-row)
    - [Radarr/Sonarr cards](#radarrsonarr-cards)
    - [Devices card](#devices-card)
  - [Camera view](#camera-view)
  - [Remote control view](#remote-control-view)
    - [Spotify player](#spotify-player)
    - [MPD player](#mpd-player)
    - [Alexa players](#alexa-players)
  - [Plex view](#plex-view)
    - [Graph row I](#graph-row-i-2)
    - [Graph row II](#graph-row-ii-2)
    - [Plex players](#plex-players)
  - [Television view](#television-view)
    - [TV players](#tv-players)
  - [Custom plugins used](#custom-plugins-used)
    - [Integrations](#integrations)
    - [Lovelace](#lovelace)
  - [Notes](#notes)
  - [Special thanks](#special-thanks)

## Background

Home Assistant core installation on Raspberry Pi 4.

More details [here](https://github.com/agneevX/server-setup).

---

## Lovelace layout

## [Dashboard (home view)](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L38)

![home_view](https://user-images.githubusercontent.com/19761269/91996307-74287400-ed56-11ea-9fc5-b6e393680323.png "Home view")

All cards in this view are in a single vertical stack.

### Badges

- System load
- Network in
- Network out
- mergerFS free %

_This is the only view that contain badges._

<p align="center">
  <b>Vertical stack 1</b>
</p>

### State row

- `/drive` mount
- `/knox` mount
- `always-on` server
- Front gate camera
- Mesh router satellite

### Lights card

- Desk light
- TV lamp
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
- `always-on` - restart
- Refresh Plex
- Circadian Lighting
- X200M (secondary laptop) - shut down/restart

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Graph row I

- CPU use
- Internet health

Indicates if there's packet loss within the last hour.

### Graph row II

- qBittorrent download speed
- qBittorrent upload speed

These two cards are hidden by default and show only when there's activity (conditional).

### Now Playing card

- Automatically shows all active media players

---

## [Info view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L621)

![info_view](https://user-images.githubusercontent.com/19761269/91996394-8e625200-ed56-11ea-89e2-0f38f37c77dc.png "Info view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### Graph row I

- CPU temp.
- SSD used %
- `/knox` free space

### Graph row II

- Download speed (Speedtest.net)
- Upload speed (Speedtest.net)

Custom-made sensor that uses the official Speedtest CLI as opposed to `speedtest-cli`, which is very inaccurate.

### Graph row III

- Current network in
- Current network out
- Today total traffic in
- Today total traffic out

Combined card. Graphs network usage within the last hour.

Custom-made sensor that gets network data traffic from `vnstat`.

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Info row I

- `always-on` temp
- qBittorrent active torrents
- qBittorrent all

### Info row II

- Home Assistant update
- HACS updates

### Internet graphs

- Node ping
- Internet ping

Graphs pings to our local ISP node and Cloudflare DNS. This card is very helpful in isolating network issues.

---

## [Tile view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1005)

![tile_view](https://user-images.githubusercontent.com/19761269/91996388-8d312500-ed56-11ea-833b-9e0d807fcbc6.png "Tile view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### TV state row

Shows states of specific TVs.

### Radarr/Sonarr cards

- Radarr/Sonarr ongoing commands
- Radarr/Sonarr upcoming
- Sonarr queue/wanted
- Radarr movies/Sonarr shows

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Devices card

- Network devices list

Using the Netgear integration, this card shows all network-connected devices. Dynamically sorted such that the last updated device is always on top.

---

## [Camera view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1345)

_This view contains one vertical stack only._

---

## [Remote control view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1365)

![rc_view](https://user-images.githubusercontent.com/19761269/91996368-85718080-ed56-11ea-9608-c702c0894938.png "Remote control view")

_This view contains one vertical stack only._

### Spotify player

- Spotify media player
  - Playlists shortcuts
  - Bedroom Echo source

### MPD player

- `Mopidy-mpd` media player

### Alexa players

- Bedroom Echo media player
- ... switches
  - Do Not Disturb
  - Repeat
  - Shuffle
- New Room Echo media player
- ... switches
  - Do Not Disturb
  - Repeat
  - Shuffle
- Alexa Everywhere media player

---

## [Plex view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1619)

![plex_view](https://user-images.githubusercontent.com/19761269/91996383-8bfff800-ed56-11ea-8f51-3ff119abbcac.png "Plex view")

_This view contains one vertical stack only._

### Graph row I

- Plex Watching
- Tautulli current bandwidth

### Graph row II

- Network in
- Network out

### Plex players

- Conditional cards...
  - Header card
  - Plex media player cards

The four graph cards provide an overview of Plex/network activity in one place and indicates potential network issues.

---

## [Television view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1982)

![tv_view](https://user-images.githubusercontent.com/19761269/91996379-8b676180-ed56-11ea-8031-24ee29d855e2.png "TV view")

### TV players

- Header card
- TV media player cards

---

## Custom plugins used

### Integrations

- [`HACS`](https://github.com/hacs/integration) by [ludeeus](https://github.com/ludeeus)
- [`Alexa Media Player`](https://github.com/custom-components/alexa_media_player)
- [`Circadian Lighting`](https://github.com/claytonjn/hass-circadian_lighting) by [claytonjn](https://github.com/claytonjn)

### Lovelace

- [`button-card`](https://github.com/custom-cards/button-card) by [RomRider](https://github.com/RomRider)
- [`card-mod`](https://github.com/thomasloven/lovelace-card-mod) by [thomasloven](https://github.com/thomasloven)
- [`mini-graph-card`](https://github.com/kalkih/mini-graph-card) by [kalkih](https://github.com/kalkih)
- [`mini-media-player`](https://github.com/kalkih/mini-media-player) by kalkih
- [`auto-entities`](https://github.com/thomasloven/lovelace-auto-entities) by thomasloven
- [`slider-entity-row`](https://github.com/thomasloven/lovelace-slider-entity-row) by thomasloven
- [`custom-header`](https://github.com/maykar/custom-header) by [maykar](https://github.com/maykar)
- [`lovelace-swipe-navigation`](https://github.com/maykar/lovelace-swipe-navigation) by maykar
- [`config-template-card`](https://github.com/iantrich/config-template-card) by maykar
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
