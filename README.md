<!-- markdownlint-disable MD024 -->
# My Home Assistant setup

This layout was designed mobile-first.

![header](web_assets/header.jpg)

## Background

Home Assistant is running in a Python `venv` on a Raspberry Pi 4 (4GB), with an SSD (Crucial MX500).

## Lovelace layout

## Dashboard (home view)

![home_view](web_assets/home_view.jpg "Home view")

All cards in this view are in a vertical stack...

### Badges

* System Load
* Network In
* Network Out
* SSD used %
* mergerFS free %

*This is the only view that contain badges.*

<details><summary>Show code</summary>

```yaml
badges:
  - entity: sensor.load_1m
    name: Load (1m)
    style: |
      :host {--label-badge-red: #07b265;}
  - entity: sensor.eth0_in
    name: eth0 in
    style: |
      :host {--label-badge-red: #07b265;}
  - entity: sensor.eth0_out
    name: eth0 out
    style: |
      :host {--label-badge-red: #07b265;}
  - entity: sensor.disk_use_percent_home_agneev
    name: SSD used
    style: |
      :host {--label-badge-red: #0091c8;}
  - entity: sensor.mergerfs_free_percent
    name: mFS free
    style: |
      :host {--label-badge-red: #07b265;}
```

</details>

<p align="center">
  <b>Vertical stack 1</b>
</p>

### Switch card

* Desk Lamp
* TV Lamp

<details><summary>Show code</summary>

```yaml
entities:
  - attribute: color_temp
    entity: light.desk_light
    haptic: success
    hide_when_off: true
    step: 15
    toggle: true
    type: 'custom:slider-entity-row'
  - entity: light.bedside_lamp
    haptic: success
    hide_when_off: true
    name: Orb Lamp
    step: 1
    toggle: true
    type: 'custom:slider-entity-row'
show_header_toggle: false
type: entities
```

</details>

### Switch row 1

* Night Lamp switch
* Color Flow switch
* Lo-Fi Beats switch
* Lo-Fi Beats 2 switch
* Jazz Radio switch

<details><summary>Show code</summary>

```yaml
cards:
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.nightlamp
    hold_action:
      action: more-info
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: toggle
      haptic: success
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.lofi_beats
    hold_action:
      action: more-info
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: toggle
      haptic: success
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.lofi_beats2
    hold_action:
      action: more-info
    icon: 'mdi:music-circle-outline'
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: toggle
      haptic: success
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.jazz_radio
    hold_action:
      action: more-info
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: toggle
      haptic: success
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.circadian_lighting_circadian_lighting
    hold_action:
      action: more-info
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: toggle
      haptic: success
    type: 'custom:button-card'
type: horizontal-stack
```

</details>

### Switch row 2

* AdGuard Home switch
* Reboot `Always-On Server`
* [Circadian Lighting](https://github.com/claytonjn/hass-circadian_lighting) switch
* Shut Down X200M (secondary laptop used occasionally)
* Restart X200M

<details><summary>Show code</summary>

```yaml
cards:
  - color: auto
    color_type: card
    entity: switch.adguard_filtering
    hold_action:
      action: more-info
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: toggle
      haptic: success
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.always_on_restart
    hold_action:
      action: more-info
    icon: 'mdi:server-security'
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: more-info
    type: 'custom:button-card'
  - color: auto
    color_type: card
    entity: switch.circadian_lighting_circadian_lighting
    hold_action:
      action: more-info
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: toggle
      haptic: success
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.x200m_shutdown
    hold_action:
      action: more-info
    icon: 'mdi:power'
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: none
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.x200m_restart
    hold_action:
      action: more-info
    icon: 'mdi:restart'
    show_name: false
    size: 35%
    styles:
      card:
        - height: 56px
    tap_action:
      action: none
    type: 'custom:button-card'
type: horizontal-stack
```

</details>

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Graph row I

* CPU use
* Network Health

<details><summary>Show code</summary>

```yaml
cards:
  - align_state: center
    animate: true
    color_thresholds:
      - color: '#ff0000'
        value: 80
      - color: '#ff8600'
        value: 50
      - color: '#04e700'
        value: 30
    decimals: 0
    entities:
      - entity: sensor.processor_use
        state_adaptive_color: true
    font_size: 105
    hours_to_show: 2
    icon: 'mdi:cpu-64-bit'
    line_width: 4
    name: CPU
    points_per_hour: 4
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      name_adaptive_color: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px
        14px !important
      }
    type: 'custom:mini-graph-card'
  - align_state: center
    animate: true
    color_thresholds:
      - color: '#ff0000'
        value: 95
      - color: '#ff8600'
        value: 97
      - color: '#04e700'
        value: 99
    entities:
      - entity: sensor.internet_health
        state_adaptive_color: true
    font_size: 105
    hours_to_show: 1
    upper_bound: 100.1
    line_width: 4
    name: Internet
    points_per_hour: 8
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      name_adaptive_color: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 16px 0 16px !important
      }
      ha-card > .info {
        padding: 0 16px 0px 16px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

### Graph row II

* Hidden/conditional qBittorrent download card
* Hidden/conditional qBittorrent upload card

<details><summary>Show code</summary>

```yaml
default: idle
entity: sensor.qbt_status
states:
  downloading:
    cards:
      - align_icon: state
        animate: true
        decimals: 0
        entities:
          - color: '#317ACC'
            entity: sensor.qbt_down_speed
            state_adaptive_color: true
        hours_to_show: 1
        icon: 'mdi:arrow-down'
        line_width: 4
        name: qBt Down
        points_per_hour: 20
        show:
          fill: false
          icon_adaptive_color: true
          labels: false
          name: false
          name_adaptive_color: true
          points: false
        style: |
          ha-card > div:nth-child(-n+2) {
            padding: 0 14px 0 14px !important
          }
          ha-card > .info {
            padding: 0 14px 0px 14px !important
          }
        type: 'custom:mini-graph-card'
        unit: KB/s
      - align_icon: state
        animate: true
        decimals: 0
        entities:
          - color: '#317ACC'
            entity: sensor.qbt_up_speed
            state_adaptive_color: true
        hours_to_show: 1
        icon: 'mdi:arrow-up'
        line_width: 4
        name: qBt Up
        points_per_hour: 20
        show:
          fill: false
          icon_adaptive_color: true
          labels: false
          name: false
          name_adaptive_color: true
          points: false
        style: |
          ha-card > div:nth-child(-n+2) {
            padding: 0 14px 0 14px !important
          }
          ha-card > .info {
            padding: 0 14px 0px 14px !important
          }
        type: 'custom:mini-graph-card'
        unit: KB/s
    type: horizontal-stack
  seeding:
    cards:
      - align_icon: state
        animate: true
        decimals: 0
        entities:
          - color: '#F08B32'
            entity: sensor.qbt_down_speed
            state_adaptive_color: true
        hours_to_show: 1
        icon: 'mdi:arrow-down'
        line_width: 4
        name: qBt Down
        points_per_hour: 20
        show:
          fill: false
          icon_adaptive_color: true
          labels: false
          name: false
          name_adaptive_color: true
          points: false
        style: |
          ha-card > div:nth-child(-n+2) {
            padding: 0 14px 0 14px !important
          }
          ha-card > .info {
            padding: 0 14px 0px 14px !important
          }
        type: 'custom:mini-graph-card'
        unit: KB/s
      - align_icon: state
        animate: true
        decimals: 0
        entities:
          - color: '#F08B32'
            entity: sensor.qbt_up_speed
            state_adaptive_color: true
        hours_to_show: 1
        icon: 'mdi:arrow-up'
        line_width: 4
        name: qBt Up
        points_per_hour: 20
        show:
          fill: false
          icon_adaptive_color: true
          labels: false
          name: false
          name_adaptive_color: true
          points: false
        style: |
          ha-card > div:nth-child(-n+2) {
            padding: 0 14px 0 14px !important
          }
          ha-card > .info {
            padding: 0 14px 0px 14px !important
          }
        type: 'custom:mini-graph-card'
        unit: KB/s
    type: horizontal-stack
  up_down:
    cards:
      - align_icon: state
        animate: true
        decimals: 0
        entities:
          - color: '#317ACC'
            entity: sensor.qbt_down_speed
            state_adaptive_color: true
        hours_to_show: 1
        icon: 'mdi:arrow-down'
        line_width: 4
        name: qBt In
        points_per_hour: 20
        show:
          fill: false
          icon_adaptive_color: true
          labels: false
          name: false
          name_adaptive_color: true
          points: false
        style: |
          ha-card > div:nth-child(-n+2) {
            padding: 0 14px 0 14px !important
          }
          ha-card > .info {
            padding: 0 14px 0px 14px !important
          }
        type: 'custom:mini-graph-card'
        unit: KB/s
      - align_icon: state
        animate: true
        decimals: 0
        entities:
          - color: '#317ACC'
            entity: sensor.qbt_up_speed
            state_adaptive_color: true
        hours_to_show: 1
        icon: 'mdi:arrow-up'
        line_width: 4
        name: qBt Out
        points_per_hour: 20
        show:
          fill: false
          icon_adaptive_color: true
          labels: false
          name: false
          name_adaptive_color: true
          points: false
        style: |
          ha-card > div:nth-child(-n+2) {
            padding: 0 14px 0 14px !important
          }
          ha-card > .info {
            padding: 0 14px 0px 14px !important
          }
        type: 'custom:mini-graph-card'
        unit: KB/s
    type: horizontal-stack
type: 'custom:state-switch'

```

</details>

### Now Playing card

* Automatically shows all active media players

<details><summary>Show code</summary>

```yaml
card:
  type: entities
filter:
  exclude:
    - state: 'off'
    - state: unavailable
    - state: standby
    - state: idle
  include:
    - domain: media_player
show_empty: false
sort:
  method: last_changed
type: 'custom:auto-entities'
```

</details>

***

## Info view

![info_view](web_assets/info_view.jpg "Info view")

Two vertical stacks in this view.

<p align="center">
  <b>Vertical stack 1</b>
</p>

### Graph row I

* System Load - 5 minutes
* System Load - 15 minutes
* Google Drive used space

<details><summary>Show code</summary>

```yaml
cards:
  - color_thresholds:
      - color: '#ff0000'
        value: 4
      - color: '#e1e700'
        value: 3
      - color: '#04e700'
        value: 1
    decimals: 1
    entities:
      - entity: sensor.load_5m
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 2
    icon: 'mdi:numeric-5-box-outline'
    line_width: 5
    name: 5-min
    points_per_hour: 6
    show:
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - color_thresholds:
      - color: '#ff0000'
        value: 3
      - color: '#e1e700'
        value: 2
      - color: '#04e700'
        value: 1
    decimals: 1
    entities:
      - entity: sensor.load_15m
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 2
    line_width: 5
    name: 15-min
    points_per_hour: 6
    show:
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - color_thresholds:
      - color: '#ff0000'
        value: 75
      - color: '#e1e700'
        value: 40
      - color: '#04e700'
        value: 25
    decimals: 1
    entities:
      - entity: sensor.drive_used
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 72
    icon: 'mdi:google-drive'
    line_width: 5
    name: Drive
    points_per_hour: 1
    show:
      fill: true
      icon_adaptive_color: true
      labels: false
      name_adaptive_color: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
    unit: TB
type: horizontal-stack
```

</details>

### Graph row II

* CPU Temperature/Throttled state (host)
* CPU Temperature/Throttled state (Always-On server)
* AdGuard Home processing speed

<details><summary>Show code</summary>

```yaml
cards:
  - card:
      animate: true
      color_thresholds:
        - color: '#ff0000'
          value: 80
        - color: '#e1e700'
          value: 65
        - color: '#04e700'
          value: 50
      decimals: 0
      entities:
        - entity: sensor.cpu_temp
          state_adaptive_color: false
      font_size: 85
      hours_to_show: 3
      line_width: 5
      name: '${ states[''sensor.throttled_state''].state }'
      points_per_hour: 7
      show:
        icon_adaptive_color: true
        labels: false
        points: false
      style: |
        ha-card > div:nth-child(-n+2) {
          padding: 0 14px 0 14px !important
        }
        ha-card > .info {
          padding: 0 14px 0px 14px !important
        }
      type: 'custom:mini-graph-card'
    entities:
      - sensor.throttled_state
    type: 'custom:config-template-card'
  - card:
      animate: true
      color_thresholds:
        - color: '#ff0000'
          value: 70
        - color: '#e1e700'
          value: 60
        - color: '#04e700'
          value: 55
      decimals: 0
      entities:
        - entity: sensor.always_on_cpu_temp
          state_adaptive_color: false
      font_size: 85
      hours_to_show: 3
      line_width: 5
      name: '${ states[''sensor.always_on_throttled_state''].state }'
      points_per_hour: 7
      show:
        icon_adaptive_color: true
        labels: false
        points: false
      style: |
        ha-card > div:nth-child(-n+2) {
          padding: 0 14px 0 14px !important
        }
        ha-card > .info {
          padding: 0 14px 0px 14px !important
        }
      type: 'custom:mini-graph-card'
    entities:
      - sensor.always_on_throttled_state
    type: 'custom:config-template-card'
  - color_thresholds:
      - color: '#ff0000'
        value: 250
      - color: '#e1e700'
        value: 150
      - color: '#04e700'
        value: 100
    decimals: 0
    entities:
      - entity: sensor.adguard_average_processing_speed
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 24
    icon: 'mdi:progress-clock'
    line_width: 5
    name: DNS
    points_per_hour: 1
    show:
      fill: true
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

### Graph row III

* AdGuard Home - % of blocked ads
* mergerFS free space (in GB)

<details><summary>Show code</summary>

```yaml
cards:
  - color_thresholds:
      - color: '#ff0000'
        value: 10
      - color: '#e1e700'
        value: 15
      - color: '#04e700'
        value: 20
    decimals: 1
    entities:
      - entity: sensor.adguard_dns_queries_blocked_ratio
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 72
    line_width: 3
    name: Ads blocked
    points_per_hour: 1
    show:
      fill: true
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - color_thresholds:
      - color: '#04e700'
        value: 60
      - color: '#e1e700'
        value: 40
      - color: '#ff0000'
        value: 25
    decimals: 0
    entities:
      - entity: sensor.disk_free_merged
        name: mergerFS free
        state_adaptive_color: false
        unit: GB
    font_size: 85
    hours_to_show: 72
    line_width: 3
    points_per_hour: 1
    show:
      fill: true
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack

```

</details>

### Network throughput graph

* Graphs network usage in the last hour

<details><summary>Show code</summary>

```yaml
entities:
  - entity: sensor.eth0_in
  - entity: sensor.eth0_out
hours_to_show: 1
refresh_interval: 30
type: history-graph
```

</details>

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Graph row I

* Download speed
* Upload speed

This is a custom sensor that uses the official Speedtest CLI as opposed to the `speedtest-cli` integration, which is very inaccurate.

<details><summary>Show code</summary>

```yaml
cards:
  - align_icon: state
    align_state: center
    animate: false
    color_thresholds:
      - color: '#ff0000'
        value: 60
      - color: '#e1e700'
        value: 75
      - color: '#04e700'
        value: 95
    decimals: 0
    entities:
      - entity: sensor.speedtest_net_download
        state_adaptive_color: true
    hours_to_show: 6
    icon: 'mdi:arrow-down'
    line_width: 4
    points_per_hour: 2
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      name: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - align_icon: state
    align_state: center
    animate: false
    color_thresholds:
      - color: '#ff0000'
        value: 60
      - color: '#e1e700'
        value: 75
      - color: '#04e700'
        value: 95
    decimals: 0
    entities:
      - entity: sensor.speedtest_net_upload
        state_adaptive_color: true
    hours_to_show: 6
    icon: 'mdi:arrow-up'
    line_width: 4
    points_per_hour: 2
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      name: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

### Graph row II

* Latency - Speedtest.net
* Jitter - Speedtest.net

<details><summary>Show code</summary>

```yaml
cards:
  - align_icon: state
    align_state: center
    animate: false
    color_thresholds:
      - color: '#ff0000'
        value: 15
      - color: '#e1e700'
        value: 10
      - color: '#04e700'
        value: 5
    decimals: 0
    entities:
      - entity: sensor.speedtest_net_latency
        state_adaptive_color: true
    hours_to_show: 6
    line_width: 4
    name: Latency
    points_per_hour: 2
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - align_icon: state
    align_state: center
    animate: false
    color_thresholds:
      - color: '#ff0000'
        value: 5
      - color: '#e1e700'
        value: 2
      - color: '#04e700'
        value: 1
    entities:
      - entity: sensor.speedtest_net_jitter
        state_adaptive_color: true
    hours_to_show: 6
    line_width: 4
    name: Jitter
    points_per_hour: 2
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

### Sensor graph

Pings my local ISP node and Cloudflare DNS.
Helps isolate network issues.

<details><summary>Show code</summary>

```yaml
entities:
  - entity: binary_sensor.node_ping
    name: Node
  - entity: binary_sensor.cloudflare_dns_ping
    name: Internet
hours_to_show: 1
refresh_interval: 30
type: history-graph
```

</details>

### Entity card

This is another custom sensor that gets daily network usage from `vnstat` instead of using the rather [buggy](https://github.com/home-assistant/core/issues/34804) internal integration.

<details><summary>Show code</summary>

```yaml
cards:
  - entity: sensor.eth0_in_total
    type: entity
  - entity: sensor.eth0_out_total
    type: entity
type: horizontal-stack
```

</details>

<details><summary>Expand vnstat script</summary>

```shell
#!/bin/bash

vnstat -i eth0 --json d | jq '.interfaces[] | select(.id=="eth0")' | jq '.traffic.days[] | select(.id==0)'
```

</details>

***

## Tile view

![tile_view](web_assets/info2_view.jpg "Tile view")

<p align="center">
  <b>Vertical stack 1</b>
</p>

### Radarr/Sonarr cards

<details><summary>Expand</summary>

#### Radarr/Sonarr ongoing commands

<details><summary>Show code</summary>

```yaml
cards:
  - animate: true
    entities:
      - color: '#F5BB41'
        entity: sensor.radarr_commands
        state_adaptive_color: true
    hours_to_show: 6
    icon: 'mdi:console-line'
    line_width: 4
    name: Radarr
    points_per_hour: 5
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      name_adaptive_color: true
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - animate: true
    entities:
      - color: '#23CDFD'
        entity: sensor.sonarr_commands
        state_adaptive_color: true
    hours_to_show: 6
    icon: 'mdi:console-line'
    line_width: 4
    name: Sonarr
    points_per_hour: 5
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      name_adaptive_color: true
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

#### Radarr/Sonarr Upcoming

<details><summary>Show code</summary>

```yaml
cards:
  - entities:
      - color: '#F5BB41'
        entity: sensor.radarr_upcoming
        state_adaptive_color: true
    icon: 'mdi:movie-search'
    name: Upcoming
    show:
      graph: false
      icon_adaptive_color: true
      name_adaptive_color: true
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - entities:
      - color: '#23CDFD'
        entity: sensor.sonarr_upcoming
        state_adaptive_color: true
    icon: 'mdi:calendar'
    name: Upcoming
    show:
      graph: false
      icon_adaptive_color: true
      name_adaptive_color: true
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

#### Sonarr Queue/Wanted

<details><summary>Show code</summary>

```yaml
cards:
  - entities:
      - color: '#23CDFD'
        entity: sensor.sonarr_queue
        state_adaptive_color: true
    icon: 'mdi:progress-clock'
    name: Queue
    show:
      graph: false
      icon_adaptive_color: true
      name_adaptive_color: true
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - entities:
      - color: '#23CDFD'
        entity: sensor.sonarr_wanted
        state_adaptive_color: true
    icon: 'mdi:timelapse'
    name: Wanted
    show:
      graph: false
      icon_adaptive_color: true
      name_adaptive_color: true
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

#### Radarr Movies/Sonarr Shows

<details><summary>Show code</summary>

```yaml
cards:
  - entities:
      - color: '#F5BB41'
        entity: sensor.radarr_movies
        state_adaptive_color: true
    icon: 'mdi:movie-open'
    name: Radarr
    show:
      graph: false
      icon_adaptive_color: true
      name_adaptive_color: true
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - entities:
      - color: '#23CDFD'
        entity: sensor.sonarr_shows
        state_adaptive_color: true
    name: Sonarr
    show:
      graph: false
      icon_adaptive_color: true
      name_adaptive_color: true
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
    unit: Shows
type: horizontal-stack
```

</details>

</details>

### Specific devices tracking card

<details><summary>Show code</summary>

```yaml
card:
  type: entities
filter:
  include:
    - entity_id: binary_sensor.orbi_satellite
    - entity_id: device_tracker.new_room_tv
      options:
        icon: 'mdi:television'
    - entity_id: device_tracker.old_room_tv
      options:
        icon: 'mdi:television'
    - entity_id: device_tracker.sony_bravia
      options:
        icon: 'mdi:television'
sort:
  method: last_updated
type: 'custom:auto-entities'
```

</details>

<p align="center">
  <b>Vertical stack 2</b>
</p>

### Router devices

Using the Netgear integration, this card shows all devices that are/were connected to my router.
Shows the last updated device on top.

<details><summary>Show code</summary>

```yaml
card:
  type: entities
filter:
  exclude:
    - entity_id: device_tracker.new_room_tv
    - entity_id: device_tracker.old_room_tv
    - entity_id: device_tracker.sony_bravia
    - entity_id: device_tracker.new_room
  include:
    - domain: device_tracker
sort:
  method: last_updated
type: 'custom:auto-entities'
```

</details>

***

## Camera view

This view contains one vertical stack only.

<details><summary>Show code</summary>

```yaml
cards:
  - entity: device_tracker.front_gate_camera
    icon: 'mdi:gate'
    name: Front Gate
    type: entity
  - card:
      aspect_ratio: 75%
      entities: []
      entity: camera.front_gate_camera
# Snapshots maybe broken on Chrome
      image: 'http://username:password@10.0.0.20/image/jpeg.cgi'
      title: Front Gate
      type: picture-glance
    conditions:
      - entity: device_tracker.front_gate_camera
        state: home
    type: conditional
type: vertical-stack
```

</details>

***

### Remote control view

![rc_view](web_assets/rc_view.jpg "Remote control view")

This view contains one vertical stack only.

### Spotify card

<details><summary>Show code</summary>

```yaml
artwork: cover
entity: media_player.spotify
volume_step: 5
hide:
  power: true
idle_view:
  when_idle: true
  when_standby: true
shortcuts:
attribute: source
buttons:
  - icon: 'mdi:sunglasses'
    id: 'spotify:playlist:5IUxvS0U3ZL2NwKoybYEmD'
    type: playlist
  - icon: 'mdi:city'
    id: 'spotify:playlist:5FmmxErJczcrEwIFGIviYo'
    type: playlist
  - icon: 'mdi:trending-up'
    id: 'spotify:playlist:xxxxx'
    type: playlist
  - icon: 'mdi:numeric-1'
    id: 'spotify:playlist:xxxxx'
    type: playlist
  - icon: 'mdi:numeric-2'
    id: 'spotify:playlist:xxxxx'
    type: playlist
  - icon: 'mdi:amazon-alexa'
    id: Bedroom Echo
    name: 1
    type: source
  - icon: 'mdi:amazon-alexa'
    id: New Room Echo
    name: 2
    type: source
  - icon: 'mdi:surround-sound'
    id: Soundbar
    type: source
  - icon: 'mdi:silverware-fork-knife'
    ids: Dining Hall
    type: source
columns: 5
type: 'custom:mini-media-player'
volume_step: 5
```

</details>

#### Header

<details><summary>Show code</summary>

```yaml
content: |
  # Level 1
style:
  .: |
    ha-card {
      --ha-card-background: none !important;
      box-shadow: none !important;
    }
  ha-markdown:
    $: |
      h1 {
        font-size: 20px;
        font-weight: bold;
        font-family: Helvetica;
        letter-spacing: '-0.01em';
      }
type: markdown
```

</details>

### Media player cards for Alexa devices

Conditional cards for each device

<details><summary>Show code</summary>

* Do Not Disturb button
* Shuffle button
* Repeat button

```yaml
card:
  cards:
    - artwork: cover
      entity: media_player.bedroom_echo
      hide:
        power: true
        source: true
      icon: 'mdi:amazon-alexa'
      idle_view:
        when_idle: true
        when_standby: true
      type: 'custom:mini-media-player'
      volume_step: 5
    - cards:
        - color: auto
          color_type: card
          double_tap_action:
            action: more-info
          entity: switch.bedroom_echo_do_not_disturb_switch
          name: DND
          show_name: true
          size: 20%
          styles:
            card:
              - height: 60px
              - font-size: 12px
              - font-weight: bold
          tap_action:
            action: toggle
            haptic: success
          type: 'custom:button-card'
        - color: auto
          color_type: card
          double_tap_action:
            action: more-info
          entity: switch.bedroom_echo_shuffle_switch
          name: SHUFFLE
          show_name: true
          size: 20%
          styles:
            card:
              - height: 60px
              - font-size: 12px
              - font-weight: bold
          tap_action:
            action: toggle
            haptic: success
          type: 'custom:button-card'
        - color: auto
          color_type: card
          double_tap_action:
            action: more-info
          entity: switch.bedroom_echo_repeat_switch
          name: REPEAT
          show_name: true
          size: 20%
          styles:
            card:
              - height: 60px
              - font-size: 12px
              - font-weight: bold
          tap_action:
            action: toggle
            haptic: success
          type: 'custom:button-card'
      type: horizontal-stack
  type: vertical-stack
conditions:
  - entity: media_player.bedroom_echo
    state_not: unavailable
type: conditional

```

```yaml
card:
  cards:
    - artwork: cover
      entity: media_player.new_room_echo
      hide:
        power: true
        source: true
      icon: 'mdi:amazon-alexa'
      idle_view:
        after: 15
        when_idle: true
        when_standby: true
      type: 'custom:mini-media-player'
      volume_step: 5
    - cards:
        - color: auto
          color_type: card
          double_tap_action:
            action: more-info
          entity: switch.new_room_echo_do_not_disturb_switch
          name: DND
          show_name: true
          size: 20%
          styles:
            card:
              - height: 60px
              - font-size: 12px
              - font-weight: bold
          tap_action:
            action: toggle
            haptic: success
          type: 'custom:button-card'
        - color: auto
          color_type: card
          double_tap_action:
            action: more-info
          entity: switch.new_room_echo_shuffle_switch
          name: SHUFFLE
          show_name: true
          size: 20%
          styles:
            card:
              - height: 60px
              - font-size: 12px
              - font-weight: bold
          tap_action:
            action: toggle
            haptic: success
          type: 'custom:button-card'
        - color: auto
          color_type: card
          double_tap_action:
            action: more-info
          entity: switch.new_room_echo_repeat_switch
          name: REPEAT
          show_name: true
          size: 20%
          styles:
            card:
              - height: 60px
              - font-size: 12px
              - font-weight: bold
          tap_action:
            action: toggle
            haptic: success
          type: 'custom:button-card'
      type: horizontal-stack
  type: vertical-stack
conditions:
  - entity: media_player.new_room_echo
    state_not: unavailable
type: conditional
```

</details>

***

## Plex view

![plex_view](web_assets/plex_view.jpg "Plex view")

This view contains one vertical stack only.

These two graph rows provide an overview of network activity and helps track if a Plex client is buffering.

### Graph row I

* Plex Watching sensor
* Tautulli current bandwidth

<details><summary>Show code</summary>

```yaml
cards:
  - decimals: 0
    entities:
      - entity: sensor.plex
        color: '#F0A400'
        state_adaptive_color: true
    font_size: 85
    hours_to_show: 6
    line_width: 4
    name: Home Server
    points_per_hour: 4
    show:
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - decimals: 1
    entities:
      - entity: sensor.tautulli_total_bw
        state_adaptive_color: true
        color: '#F0A400'
    font_size: 85
    hours_to_show: 6
    icon: 'mdi:waveform'
    line_width: 4
    name: Bandwidth
    points_per_hour: 10
    show:
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

### Graph row II

* Network In sensor
* Network Out sensor

<details><summary>Show code</summary>

```yaml
cards:
  - entities:
      - entity: sensor.eth0_in
        state_adaptive_color: true
        color: '#F0A400'
    font_size: 85
    hours_to_show: 1
    icon: 'mdi:arrow-down'
    line_width: 4
    points_per_hour: 30
    show:
      extrema: true
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
  - entities:
      - entity: sensor.eth0_out
        state_adaptive_color: true
        color: '#F0A400'
    font_size: 85
    hours_to_show: 1
    icon: 'mdi:arrow-up'
    line_width: 4
    points_per_hour: 30
    show:
      extrema: true
      icon_adaptive_color: true
      labels: false
      points: false
    style: |
      ha-card > div:nth-child(-n+2) {
        padding: 0 14px 0 14px !important
      }
      ha-card > .info {
        padding: 0 14px 0px 14px !important
      }
    type: 'custom:mini-graph-card'
type: horizontal-stack
```

</details>

### Entities card

* Refresh Plex switch

<details><summary>Show code</summary>

```yaml
entities:
  - entity: switch.refresh_plex
show_header_toggle: false
type: entities
```

</details>

### Media player cards

* Conditional header cards with Plex media player cards

<details><summary>Show code</summary>

```yaml
card:
  cards:
    - content: |
        # Bedroom
      style:
        .: |
          ha-card {
            --ha-card-background: none !important;
            box-shadow: none !important;
          }
        ha-markdown:
          $: |
            h1 {
              font-size: 20px;
              font-weight: bold;
              font-family: Helvetica;
              letter-spacing: '-0.01em';
            }
      type: markdown
    - artwork: cover
      entity: media_player.plex_plex_for_lg_lg_49uf690t_tc
      hide:
        power: true
      idle_view:
        when_idle: true
        when_standby: true
      name: Plex Media Player
      type: 'custom:mini-media-player'
  type: vertical-stack
conditions:
  - entity: media_player.plex_plex_for_lg_lg_49uf690t_tc
    state: unavailable
  - entity: media_player.plex_plex_for_lg_lg_49uf690t_tc
    state: idle
type: conditional
```

```yaml
card:
  cards:
    - content: |
        # Bedroom
      style:
        .: |
          ha-card {
            --ha-card-background: none !important;
            box-shadow: none !important;
          }
        ha-markdown:
          $: |
            h1 {
              font-size: 20px;
              font-weight: bold;
              font-family: Helvetica;
              letter-spacing: '-0.01em';
            }
      type: markdown
    - artwork: cover
      entity: media_player.plex_xplay_lg_49uf690t_tc
      hide:
        power: true
      idle_view:
        when_idle: true
        when_standby: true
      name: XPlay
      type: 'custom:mini-media-player'
  type: vertical-stack
conditions:
  - entity: media_player.plex_xplay_lg_49uf690t_tc
    state_not: unavailable
  - entity: media_player.plex_xplay_lg_49uf690t_tc
    state_not: idle
type: conditional
```

```yaml
card:
  cards:
    - content: |
        # Level 1
      style:
        .: |
          ha-card {
            --ha-card-background: none !important;
            box-shadow: none !important;
          }
        ha-markdown:
          $: |
            h1 {
              font-size: 20px;
              font-weight: bold;
              font-family: Helvetica;
              letter-spacing: '-0.01em';
            }
      type: markdown
    - artwork: cover
      entity: media_player.plex_plex_for_lg_lg_oled55c9pta
      hide:
        power: true
      idle_view:
        when_idle: true
        when_standby: true
      name: 'Plex: Old Room TV'
      type: 'custom:mini-media-player'
  type: vertical-stack
conditions:
  - entity: media_player.plex_plex_for_lg_lg_oled55c9pta
    state_not: unavailable
  - entity: media_player.plex_plex_for_lg_lg_oled55c9pta
    state_not: idle
type: conditional
```

```yaml
card:
  cards:
    - content: |
        # Level 2
      style:
        .: |
          ha-card {
            --ha-card-background: none !important;
            box-shadow: none !important;
          }
        ha-markdown:
          $: |
            h1 {
              font-size: 20px;
              font-weight: bold;
              font-family: Helvetica;
              letter-spacing: '-0.01em';
            }
      type: markdown
    - artwork: cover
      entity: media_player.plex_plex_for_android_tv_sony_bravia
      hide:
        power: true
      idle_view:
        when_idle: true
        when_standby: true
      name: Plex Media Player
      type: 'custom:mini-media-player'
  type: vertical-stack
conditions:
  - entity: media_player.plex_plex_for_android_tv_sony_bravia
    state_not: unavailable
  - entity: media_player.plex_plex_for_android_tv_sony_bravia
    state_not: idle
type: conditional
```

```yaml
card:
  cards:
    - content: |
        # Level 2
      style:
        .: |
          ha-card {
            --ha-card-background: none !important;
            box-shadow: none !important;
          }
        ha-markdown:
          $: |
            h1 {
              font-size: 20px;
              font-weight: bold;
              font-family: Helvetica;
              letter-spacing: '-0.01em';
            }
      type: markdown
    - artwork: cover
      entity: media_player.plex_mrmc_localhost
      hide:
        power: true
        progress: true
      idle_view:
        when_idle: true
        when_standby: true
      name: MrMC
      type: 'custom:mini-media-player'
  type: vertical-stack
conditions:
  - entity: media_player.plex_mrmc_localhost
    state_not: unavailable
  - entity: media_player.plex_mrmc_localhost
    state_not: idle
type: conditional
```

</details>

***

## Television view

![tv_view](web_assets/tv_view.jpg "TV view")

### Media player cards

* Header card for floors
* TV media player cards

<details><summary>Show code</summary>

```yaml
- content: |
    # Level 1
  style:
    .: |
      ha-card {
        --ha-card-background: none !important;
        box-shadow: none !important;
      }
    ha-markdown:
      $: |
        h1 {
          font-size: 20px;
          font-weight: bold;
          font-family: Helvetica;
          letter-spacing: '-0.01em';
        }
  type: markdown
```

```yaml
- entity: media_player.bedroom_tv
  hide:
    play_stop: false
    power: true
    progress: true
    source: true
  idle_view:
    when_idle: true
    when_standby: true
  shortcuts:
    attribute: source
    buttons:
      - icon: 'mdi:plex'
        id: Plex
        type: source
      - icon: 'mdi:netflix'
        id: Netflix
        type: source
      - icon: 'mdi:amazon'
        id: Amazon Prime Video
        type: source
      - icon: 'mdi:youtube'
        id: YouTube
        type: source
      - icon: 'mdi:alpha-x-box'
        id: XPlay
        type: source
      - icon: 'mdi:video-input-hdmi'
        id: HDMI1
        name: HDMI 1
        type: source
      - icon: 'mdi:video-input-hdmi'
        id: HDMI2
        name: HDMI 2
        type: source
      - icon: 'mdi:set-top-box'
        id: Cable
        name: Cable
        type: source
    columns: 5
    hide_when_off: true
  type: 'custom:mini-media-player'
```

```yaml
- entity: media_player.old_room_tv
  hide:
    play_stop: false
    power: true
    progress: true
    source: true
  idle_view:
    when_idle: true
    when_standby: true
  shortcuts:
    attribute: source
    buttons:
      - icon: 'mdi:plex'
        id: Plex
        type: source
      - icon: 'mdi:netflix'
        id: Netflix
        type: source
      - icon: 'mdi:amazon'
        id: Amazon Prime Video
        type: source
      - icon: 'mdi:youtube'
        id: YouTube
        type: source
      - icon: 'mdi:alpha-x-box'
        id: XPlay
        type: source
    columns: 5
    hide_when_off: true
  source: full
  type: 'custom:mini-media-player'
```

```yaml
- entity: media_player.new_room_tv
  hide:
    play_stop: false
    power: true
    progress: true
    source: true
  idle_view:
    when_idle: true
    when_standby: true
  shortcuts:
    attribute: source
    buttons:
      - icon: 'mdi:plex'
        id: Plex
        type: source
      - icon: 'mdi:netflix'
        id: Netflix
        type: source
      - icon: 'mdi:amazon'
        id: Amazon Prime Video
        type: source
      - icon: 'mdi:youtube'
        id: YouTube
        type: source
      - icon: 'mdi:alpha-x-box'
        id: XPlay
        type: source
    columns: 5
    hide_when_off: true
  type: 'custom:mini-media-player'
```

```yaml
- entity: media_player.dining_hall_tv
  hide:
    power: true
    progress: true
    source: true
  idle_view:
    when_idle: true
    when_standby: true
  shortcuts:
    attribute: source
    buttons:
      - icon: 'mdi:plex'
        id: Plex
        type: source
      - icon: 'mdi:netflix'
        id: Netflix
        type: source
      - icon: 'mdi:amazon'
        id: Amazon Prime Video
        type: source
      - icon: 'mdi:youtube'
        id: YouTube
        type: source
    columns: 5
    hide_when_off: true
  type: 'custom:mini-media-player'
```

```yaml
- content: |
    # Level 2
  style:
    .: |
      ha-card {
        --ha-card-background: none !important;
        box-shadow: none !important;
      }
    ha-markdown:
      $: |
        h1 {
          font-size: 20px;
          font-weight: bold;
          font-family: Helvetica;
          letter-spacing: '-0.01em';
        }
  type: markdown
```

```yaml
- entity: media_player.sony_bravia_tv
  hide:
    power: true
    progress: true
    source: true
  idle_view:
    when_idle: true
    when_standby: true
  shortcuts:
    attribute: source
    buttons:
      - icon: 'mdi:plex'
        id: Plex
        type: source
      - icon: 'mdi:alpha-m-box'
        id: Mr MC Lite
        type: source
      - icon: 'mdi:netflix'
        id: Netflix
        type: source
      - icon: 'mdi:youtube'
        id: YouTube
        type: source
    columns: 4
    hide_when_off: true
  type: 'custom:mini-media-player'
```

</details>

***

### Custom plugins

#### Custom Components

* [`HACS`](https://github.com/hacs/integration) by [ludeeus](https://github.com/ludeeus)
* [`Alexa Media Player`](https://github.com/custom-components/alexa_media_player)
* [`Circadian Lighting`](https://github.com/claytonjn/hass-circadian_lighting) by [claytonjn](https://github.com/claytonjn)

#### Lovelace

* [`card-mod`](https://github.com/thomasloven/lovelace-card-mod) by [thomasloven](https://github.com/thomasloven)
* [`mini-graph-card`](https://github.com/kalkih/mini-graph-card) by [kalkih](https://github.com/kalkih)
* [`mini-media-player`](https://github.com/kalkih/mini-media-player) by kalkih
* [`slider-entity-row`](https://github.com/thomasloven/lovelace-slider-entity-row) by thomasloven
* [`state-switch`](https://github.com/thomasloven/lovelace-state-switch) by thomasloven
* [`auto-entities`](https://github.com/thomasloven/lovelace-auto-entities) by thomasloven
* [`slider-entity-row`](https://github.com/iantrich/config-template-card) by [iantrich](https://github.com/iantrich)
* [`custom-header`](https://github.com/maykar/custom-header) by [maykar](https://github.com/maykar)
* [`lovelace-swipe-navigation`](https://github.com/maykar/lovelace-swipe-navigation) by maykar
* [`button-card`](https://github.com/custom-cards/button-card)
* [`config-template-card`](https://github.com/iantrich/config-template-card) by maykar

***

## Notes

* Entities beginning with `int` are "internal" entities that are used inside templates.
* Shutting down/Rebooting X200M involves Assistant Computer Control that runs on the laptop.
  The cURL request calls a IFTTT webhook which in turn writes a specific word in a file inside OneDrive that the software is able to recognize and perform actions.
* Screenshots or snippet code may not be up-to-date
* The header that is used for separating cards is from the theme, [soft-ui](https://github.com/N-l1/lovelace-soft-ui).

***

## Special thanks

* to all the authors above,
* and all the very helpful folks over at the HA Discord.

