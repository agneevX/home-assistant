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
    - [Switch card](#switch-card)
    - [Switch row I](#switch-row-i)
    - [Switch row II](#switch-row-ii)
    - [Graph row I](#graph-row-i)
    - [Graph row II](#graph-row-ii)
    - [Now Playing card](#now-playing-card)
  - [Info view](#info-view)
    - [Graph row I](#graph-row-i-1)
    - [Graph row II](#graph-row-ii-1)
    - [Graph row III](#graph-row-iii)
    - [Graph row IV](#graph-row-iv)
    - [Network throughput card](#network-throughput-card)
    - [Network traffic card](#network-traffic-card)
    - [Hass.io info](#hassio-info)
    - [Sensor graph](#sensor-graph)
  - [Tile view](#tile-view)
    - [TV state row](#tv-state-row)
    - [Radarr/Sonarr cards](#radarrsonarr-cards)
    - [Router devices](#router-devices)
  - [Camera view](#camera-view)
  - [Remote control view](#remote-control-view)
    - [Spotify card](#spotify-card)
    - [`Mopidy-mpd` card](#mopidy-mpd-card)
    - [Media player cards for Alexa devices](#media-player-cards-for-alexa-devices)
  - [Plex view](#plex-view)
    - [Graph row I](#graph-row-i-2)
    - [Graph row II](#graph-row-ii-2)
    - [Plex players](#plex-players)
  - [Television view](#television-view)
    - [TV media players](#tv-media-players)
  - [Custom plugins](#custom-plugins)
    - [Custom Components](#custom-components)
    - [Lovelace](#lovelace)
  - [Notes](#notes)
  - [Special thanks](#special-thanks)


## Background

Home Assistant core installation on Raspberry Pi 4.

More details [here](https://github.com/agneevX/server-setup).

***

## Lovelace layout

## [Dashboard (home view)](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L41)

![home_view](https://user-images.githubusercontent.com/19761269/91996307-74287400-ed56-11ea-9fc5-b6e393680323.png "Home view")

All cards in this view are in a single vertical stack.

### Badges

* System load
* HACS available updates
* Network in
* Network out
* mergerFS free %

*This is the only view that contain badges.*

<p align="center">
  <b>Vertical stack 1</b>
</p>

### State row

* Tautulli
* `/drive` mount
* `/merged` mount
* Front gate camera
* Satellite (mesh router)

### Switch card

* Desk lamp
* TV lamp

### Switch row I

* Night lamp switch
* Color flow switch
* Lo-Fi beats switch
* Lo-Fi beats 2 switch
* Jazz radio switch

### Switch row II

* AdGuard Home switch
* Reboot `always-on` server
* Refresh Plex switch
* Circadian Lighting switch
* Shut down/restart X200M (secondary laptop)

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Graph row I

* CPU use
* Network health

### Graph row II

* Hidden/conditional qBittorrent download speed
* Hidden/conditional qBittorrent upload speed

### Now Playing card

* Automatically shows all active media players

***

## [Info view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L631)

![info_view](https://user-images.githubusercontent.com/19761269/91996394-8e625200-ed56-11ea-89e2-0f38f37c77dc.png "Info view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### Graph row I

* System load - 5 min.
* SSD used %
* Drive used space

### Graph row II

* AdGuard Home - % of blocked ads
* AdGuard Home processing speed
* Speedtest.net latency

### Graph row III

* CPU Temperature (host)
* CPU Temperature (`always-on` server)
* Speedtest.net jitter

### Graph row IV

* Download speed
* Upload speed

This is a custom sensor that uses the official Speedtest CLI as opposed to the `speedtest-cli` integration, which is very inaccurate.

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Network throughput card

* Graphs network usage within the last hour

### Network traffic card

* Total traffic in (daily)
* Total traffic out (daily)

This is another custom sensor that gets daily network usage from `vnstat` instead of using the rather [buggy](https://github.com/home-assistant/core/issues/34804) internal integration.

### Hass.io info

* Home Assistant latest version
* HACS updates

### Sensor graph

Pings local ISP node and Cloudflare DNS. Helpful in isolating internet issues.

***

## [Tile view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1063)

![tile_view](https://user-images.githubusercontent.com/19761269/91996388-8d312500-ed56-11ea-833b-9e0d807fcbc6.png "Tile view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### TV state row

Shows states of specific TVs.

### Radarr/Sonarr cards

* Radarr/Sonarr ongoing commands
* Radarr/Sonarr upcoming
* Sonarr queue/wanted
* Radarr movies/Sonarr shows

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Router devices

Using the Netgear integration, this card shows all devices that are/were connected to my network.
Shows the last updated device on top.

***

## [Camera view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1334)

*This view contains one vertical stack only.*

***

## [Remote control view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1356)

![rc_view](https://user-images.githubusercontent.com/19761269/91996368-85718080-ed56-11ea-9608-c702c0894938.png "Remote control view")

*This view contains one vertical stack only.*

### Spotify card

Header card

### `Mopidy-mpd` card

### Media player cards for Alexa devices

***

## [Plex view](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1479)

![plex_view](https://user-images.githubusercontent.com/19761269/91996383-8bfff800-ed56-11ea-8f51-3ff119abbcac.png "Plex view")

*This view contains one vertical stack only.*

These two graph rows provide an overview of network activity and helps track if a Plex client is buffering.

### Graph row I

* Plex Watching sensor
* Tautulli current bandwidth

### Graph row II

* Network In sensor
* Network Out sensor

### Plex players

* Conditional header cards with Plex media player cards

***

## Television view

![tv_view](https://user-images.githubusercontent.com/19761269/91996379-8b676180-ed56-11ea-8031-24ee29d855e2.png "TV view")

### [TV media players](https://github.com/agneevX/my-ha-setup/blob/master/lovelace_raw.yaml#L1842)

* Header cards for floors
* TV media player cards

***

## Custom plugins

### Custom Components

* [`HACS`](https://github.com/hacs/integration) by [ludeeus](https://github.com/ludeeus)
* [`Alexa Media Player`](https://github.com/custom-components/alexa_media_player)
* [`Circadian Lighting`](https://github.com/claytonjn/hass-circadian_lighting) by [claytonjn](https://github.com/claytonjn)

### Lovelace

* [`card-mod`](https://github.com/thomasloven/lovelace-card-mod) by [thomasloven](https://github.com/thomasloven)
* [`mini-graph-card`](https://github.com/kalkih/mini-graph-card) by [kalkih](https://github.com/kalkih)
* [`mini-media-player`](https://github.com/kalkih/mini-media-player) by kalkih
* [`slider-entity-row`](https://github.com/thomasloven/lovelace-slider-entity-row) by thomasloven
* [`state-switch`](https://github.com/thomasloven/lovelace-state-switch) by thomasloven
* [`auto-entities`](https://github.com/thomasloven/lovelace-auto-entities) by thomasloven
* [`slider-entity-row`](https://github.com/iantrich/config-template-card) by [iantrich](https://github.com/iantrich)
* [`custom-header`](https://github.com/maykar/custom-header) by [maykar](https://github.com/maykar)
* [`lovelace-swipe-navigation`](https://github.com/maykar/lovelace-swipe-navigation) by maykar
* [`button-card`](https://github.com/custom-cards/button-card) by [RomRider](https://github.com/RomRider)
* [`config-template-card`](https://github.com/iantrich/config-template-card) by maykar

***

## Notes

* Screenshots may not be up-to-date.
* Entities beginning with `int` are "internal" entities that are used inside templates.
* Shutting down/Rebooting X200M involves a program named `Assistant Computer Control` that runs on the laptop.
  The cURL request calls a IFTTT webhook which in turn writes a specific word in a file inside OneDrive that the software is able to recognize and perform actions accordingly.
* The header that is used for separating cards is from [soft-ui](https://github.com/N-l1/lovelace-soft-ui).

***

## Special thanks

* to all authors above,
* and all the very helpful folks over at the Discord.

