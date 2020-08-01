# My Home Assistant Lovelace setup

This layout was designed mobile-first.

![header](assets/header.jpg)

# Background

Home Assistant is running inside a python virtual environment on a Raspberry Pi 4 (4GB model).

# Dashboard (home view)

![home_view](assets/home_view.jpg "Home view")

All cards in this view are in a vertical stack...

Contains:
* Entities card
* Switch rows
* Graph cards
* Now Playing card

## Badges

This is the only view that contain badges.

<details><summary>Show code</summary>

```yaml
- badges:
  - entity: sensor.load_1m
    name: ' '
    style: |
      :host {--label-badge-red: #07b265;}
  - entity: sensor.eth0_in
    name: ' '
    style: |
      :host {--label-badge-red: #07b265;}
  - entity: sensor.eth0_out
    name: ' '
    style: |
      :host {--label-badge-red: #07b265;}
  - entity: sensor.pyload_speed
    name: ' '
    style: |
      :host {--label-badge-red: #3974A4;}
```
</details>

## Entities row 

* Desk Lamp
* TV Lamp

<details><summary>Show code</summary>

```yaml
- entities:
  - attribute: color_temp
    entity: light.desk_light
    haptic: success
    step: 15
    toggle: true
    type: 'custom:slider-entity-row'
  - entity: light.bedside_lamp
    haptic: success
    hide_when_off: true
    name: TV Lamp
    toggle: true
    type: 'custom:slider-entity-row'
show_header_toggle: false
type: entities
```
</details>

## Switch row 1

* Night Lamp switch
* Lo-Fi Beats switch (using command line integration and omxplayer)
* Lo-Fi Beats 2 switch
* Jazz Radio switch
* [Circadian Lighting](https://github.com/claytonjn/hass-circadian_lighting) switch

<details><summary>Show code</summary>

```yaml
- cards:
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: light.bedside_lamp_nightlight
    hold_action:
      action: more-info
    icon: 'mdi:power-sleep'
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

## Switch row 2

* Shut Down Always-On Server
* Reboot Always-On Server
* AdGuard Home switch
* Shut Down X200M (secondary laptop occasionally used)
* Restart X200M

<details><summary>Show code</summary>

```yaml
- cards:
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.always_on_shutdown
    hold_action:
      action: more-info
    icon: 'mdi:power'
    name: ALWAYS
    show_name: true
    size: 35%
    styles:
      card:
        - height: 56px
        - font-size: 12px
        - font-weight: bold
    tap_action:
      action: none
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.always_on_restart
    hold_action:
      action: more-info
    icon: 'mdi:restart'
    name: 'ON'
    show_name: true
    size: 35%
    styles:
      card:
        - height: 56px
        - font-size: 12px
        - font-weight: bold
    tap_action:
      action: none
    type: 'custom:button-card'
  - color: auto
    color_type: card
    double_tap_action:
      action: toggle
      haptic: success
    entity: switch.adguard_protection
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
    name: X200M
    show_name: true
    size: 35%
    styles:
      card:
        - height: 56px
        - font-size: 12px
        - font-weight: bold
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
    name: X200M
    show_name: true
    size: 35%
    styles:
      card:
        - height: 56px
        - font-size: 12px
        - font-weight: bold
    tap_action:
      action: none
    type: 'custom:button-card'
type: horizontal-stack
```
</details>

## Graph row 1

* CPU usage
* Network Health (using ping integration)
    
<details><summary>Show code</summary>

```yaml
- cards:
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
    hours_to_show: 1
    icon: 'mdi:cpu-64-bit'
    line_width: 4
    name: CPU
    points_per_hour: 8
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
    upper_bound: 100.1
type: horizontal-stack
```
</details>

## Graph row 2 (depending upon state)

* Conditional qBittorrent download card
* Conditional qBittorrent upload card

<details><summary>Show code</summary>

```yaml
- default: idle
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
          legend: false
          name: false
          name_adaptive_color: true
          points: false
          state: true
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
          legend: false
          name: false
          name_adaptive_color: true
          points: false
          state: true
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
  idle:
    cards:
      - entity: sensor.mergerfs
        type: entity
        unit: free
      - entity: sensor.drive_used
        icon: 'mdi:google-drive'
        name: Google Drive
        type: entity
        unit: used
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
          legend: false
          name: false
          name_adaptive_color: true
          points: false
          state: true
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
          legend: false
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
          legend: false
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

## Now Playing card

<details><summary>Show code</summary>

```yaml
- card:
  type: entities
filter:
  exclude:
    - state: 'off'
    - state: unavailable
    - state: standby
    - state: idle
    - entity_id: media_player.new_room_echo
  include:
    - domain: media_player
show_empty: false
sort:
  method: last_changed
type: 'custom:auto-entities'
```
</details>

***

# Info view

![info_view](assets/info_view.jpg "Info view")

Two vertical stacks in this view.

### Vertical stack 1:

## Graph row 1

* System Load - 1 minute
* System Load - 5 minutes
* System Load - 15 minutes

<details><summary>Show code</summary>

```yaml
- cards:
  - align_state: left
    animate: false
    color_thresholds:
      - color: '#ff0000'
        value: 4
      - color: '#e1e700'
        value: 2
      - color: '#04e700'
        value: 1
    decimals: 1
    entities:
      - entity: sensor.load_1m
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 1
    line_width: 5
    name: 1-min
    points_per_hour: 12
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
  - align_icon: right
    align_state: left
    animate: false
    color_thresholds:
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
    hours_to_show: 1
    line_width: 5
    name: 5-min
    points_per_hour: 12
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
  - align_icon: right
    align_state: left
    animate: false
    color_thresholds:
      - color: '#ff0000'
        value: 4
      - color: '#e1e700'
        value: 3
      - color: '#04e700'
        value: 1
    decimals: 1
    entities:
      - entity: sensor.load_15m
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 6
    line_width: 5
    name: 15-min
    points_per_hour: 2
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

## Graph row 2

* AdGuard Home Processing Speed
* AdGuard Home % of blocked ads
* SSD Usage

<details><summary>Show code</summary>

```yaml
- cards:
  - animate: false
    color_thresholds:
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
    hours_to_show: 3
    line_width: 5
    name: DNS
    points_per_hour: 4
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
  - animate: false
    color_thresholds:
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
    hours_to_show: 3
    line_width: 5
    name: Ads Blocked
    points_per_hour: 6
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
  - animate: false
    color_thresholds:
      - color: '#ff0000'
        value: 75
      - color: '#e1e700'
        value: 40
      - color: '#04e700'
        value: 25
    decimals: 0
    entities:
      - entity: sensor.disk_use_percent_home_agneev
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 6
    line_width: 5
    name: SSD
    points_per_hour: 3
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
type: horizontal-stack
```
</details>

## Graph row 3

* CPU Temperature (host)
* CPU Temperature (Always-On server)

<details><summary>Show code</summary>

```yaml
- cards:
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
      line_width: 3
      name: '${ states[''sensor.throttled_state''].state }'
      points_per_hour: 6
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
      line_width: 3
      name: '${ states[''sensor.always_on_throttled_state''].state }'
      points_per_hour: 6
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
    entities:
      - sensor.always_on_throttled_state
    type: 'custom:config-template-card'
type: horizontal-stack
```
</details>

## Network throughput graph

<details><summary>Show code</summary>

```yaml
- entities:
  - entity: sensor.eth0_in
  - entity: sensor.eth0_out
hours_to_show: 1
refresh_interval: 30
type: history-graph
```
</details>

### Vertical stack 2:


## Graph row 1

* Download Speed
* Upload Speed

<details><summary>Show code</summary>

```yaml
- cards:
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
    name: ' '
    points_per_hour: 2
    show:
      fill: false
      icon: true
      icon_adaptive_color: true
      labels: false
      legend: false
      name: false
      points: false
      state: true
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
    name: ' '
    points_per_hour: 2
    show:
      fill: false
      icon: true
      icon_adaptive_color: true
      labels: false
      legend: false
      name: false
      points: false
      state: true
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

## Graph row 2

* Ping 
* Jitter

<details><summary>Show code</summary>

```yaml
- cards:
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
      - entity: sensor.speedtest_net_ping
        state_adaptive_color: true
    hours_to_show: 6
    line_width: 4
    name: Ping
    points_per_hour: 2
    show:
      fill: false
      icon_adaptive_color: true
      labels: false
      legend: false
      name: true
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
      legend: false
      name: true
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

## Binary Sensor Graph

<details><summary>Show code</summary>

```yaml
- entities:
  - entity: binary_sensor.operator
  - entity: binary_sensor.google_dns_ping
    name: Internet
hours_to_show: 1
refresh_interval: 30
type: history-graph
```
</details>

## Daily total network transfer - `vnstat`

<details><summary>Show code</summary>

```yaml
- cards:
  - entity: sensor.eth0_in_total
    type: entity
  - entity: sensor.eth0_out_total
    type: entity
type: horizontal-stack
```
</details>

***

# Info 2 view 

![info2_view](assets/info2_view.jpg "Info 2 view")

Three vertical stacks in this view

## Radarr/Sonarr cards

<details><summary>Expand</summary>

## Radarr/Sonarr ongoing commands

<details><summary>Show code</summary>

```yaml
- cards:
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

### Radarr/Sonarr upcoming

<details><summary>Show code</summary>

```yaml
- cards:
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

### Sonarr Queue/Wanted

<details><summary>Show code</summary>

```yaml
- cards:
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

### Radarr Movies/Sonarr Shows

<details><summary>Show code</summary>

```yaml
- cards:
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


## Entities card to track specific TVs.

<details><summary>Show code</summary>

```yaml
- card:
  type: entities
filter:
  include:
    - entity_id: device_tracker.new_room_tv
      options:
        icon: 'mdi:television'
    - entity_id: device_tracker.old_room_tv
      options:
        icon: 'mdi:television'
    - entity_id: device_tracker.dining_hall_tv
      options:
        icon: 'mdi:television'
    - entity_id: device_tracker.sony_bravia
      options:
        icon: 'mdi:television'
sort:
  method: last_changed
type: 'custom:auto-entities'
```
</details>


## Router devices

<details><summary>Show code</summary>

```yaml
- card:
  type: entities
filter:
  exclude:
    - entity_id: device_tracker.new_room_tv
    - entity_id: device_tracker.old_room_tv
    - entity_id: device_tracker.dining_hall_tv
    - entity_id: device_tracker.sony_bravia
    - entity_id: device_tracker.new_room
  include:
    - domain: device_tracker
sort:
  ignore_case: true
  method: last_changed
type: 'custom:auto-entities'
```
</details>

***

# Camera view 

This view contains one vertical stack only.

<details><summary>Show code</summary>

```yaml
- cards:
  - entity: device_tracker.front_gate_camera
    icon: 'mdi:gate'
    name: Front Gate
    type: entity
  - card:
      aspect_ratio: 75%
      entities: []
      entity: camera.front_gate_camera
      image: 'http://admin:admina@10.0.0.20/image/jpeg.cgi'
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

# Remote control view 

![rc_view](assets/rc_view.jpg "Remote control view")

This view contains one vertical stack only.

## Media player card for Spotify 

<details><summary>Show code</summary>

```yaml
    - artwork: cover
    entity: media_player.spotify
    hide:
      power: true
    idle_view:
      when_idle: true
      when_standby: true
    shortcuts:
      buttons:
        - icon: 'mdi:sunglasses'
          id: 'spotify:playlist:5IUxvS0U3ZL2NwKoybYEmD'
          type: playlist
        - icon: 'mdi:city'
          id: 'spotify:playlist:32hJXySZtt9YvnwcYINGZ0'
          type: playlist
        - icon: 'mdi:trending-up'
          id: 'spotify:playlist:37i9dQZF1DXcBWIGoYBM5M'
          type: playlist
        - icon: 'mdi:numeric-1'
    # Change xxxxx to your Daily Mix 1 playlist ID
          id: 'spotify:playlist:xxxxx'
          type: playlist
        - icon: 'mdi:numeric-2'
    # Change xxxxx to your Daily Mix 2 playlist ID
          id: 'spotify:playlist:xxxxx'
          type: playlist
      columns: 6
    type: 'custom:mini-media-player'
```
</details>

## Media player cards for Alexa devices

<details><summary>Show code</summary>

```yaml
- card:
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
- card:
  cards:
    - artwork: cover
      entity: media_player.new_room_echo
      hide:
        power: true
        sources: true
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

# Plex view 

![plex_view](assets/plex_view.jpg "Plex view")

## Graph row 1

* Plex Watching sensor
* Tautulli Bandwidth

<details><summary>Show code</summary>

```yaml
- cards:
  - decimals: 0
    entities:
      - entity: sensor.plex
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 12
    line_width: 4
    name: Home Server
    points_per_hour: 2
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
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 12
    icon: 'mdi:arrow-up'
    line_width: 4
    name: Bandwidth
    points_per_hour: 5
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

## Graph row 2

* Network In sensor
* Network Out sensor

<details><summary>Show code</summary>

```yaml
- cards:
  - entities:
      - entity: sensor.eth0_in
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 1
    icon: 'mdi:arrow-down'
    line_width: 4
    points_per_hour: 20
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
        state_adaptive_color: false
    font_size: 85
    hours_to_show: 1
    icon: 'mdi:arrow-up'
    line_width: 4
    points_per_hour: 20
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

## Entities card

* Refresh Plex switch

<details><summary>Show code</summary>

```yaml
  - entities:
      - entity: switch.refresh_plex
    show_header_toggle: false
    type: entities
```
</details>

## Plex media player cards

* Conditional header cards
* Conditional media player cards

<details><summary>Show code</summary>

```yaml
  - card:
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
  - card:
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
  - card:
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
  - card:
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
  - card:
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
type: vertical-stack
```
</details>

***

# Television view 

![tv_view](assets/tv_view.jpg "TV view")

* Header card for rooms/floors
* Media player cards

<details><summary>Show code</summary>

```yaml
- cards:
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
  - entity: media_player.bedroom_tv
    hide:
      power: true
      progress: true
    idle_view:
      when_idle: true
      when_standby: true
    info: scroll
    sound_mode: icon
    type: 'custom:mini-media-player'
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
  - entity: media_player.old_room_tv
    hide:
      power: true
      progress: true
    idle_view:
      when_idle: true
      when_standby: true
    info: scroll
    sound_mode: icon
    type: 'custom:mini-media-player'
  - entity: media_player.new_room_tv
    hide:
      power: true
      progress: true
    idle_view:
      when_idle: true
      when_standby: true
    info: scroll
    sound_mode: icon
    type: 'custom:mini-media-player'
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
  - entity: media_player.sony_bravia_tv
    hide:
      power: true
      progress: true
    idle_view:
      when_idle: true
      when_standby: true
    info: scroll
    sound_mode: icon
    type: 'custom:mini-media-player'
type: vertical-stack
```
</details>

***

# Custom plugins used:

## Custom Components

+ [`HACS`](https://github.com/hacs/integration) by [ludeeus](https://github.com/ludeeus).
+ [`Alexa Media Player`](https://github.com/custom-components/alexa_media_player).
+ [`Circadian Lighting`](https://github.com/claytonjn/hass-circadian_lighting) by [claytonjn](https://github.com/claytonjn).

## Lovelace 

+ [`card-mod`](https://github.com/thomasloven/lovelace-card-mod) by [thomasloven](https://github.com/thomasloven).
+ [`mini-graph-card`](https://github.com/kalkih/mini-graph-card) by [kalkih](https://github.com/kalkih).
+ [`mini-media-player`](https://github.com/kalkih/mini-media-player) by [kalkih](https://github.com/kalkih).
+ [`slider-entity-row`](https://github.com/thomasloven/lovelace-slider-entity-row) by [thomasloven](https://github.com/thomasloven).
+ [`state-switch`](https://github.com/thomasloven/lovelace-state-switch) by [thomasloven](https://github.com/thomasloven).
+ [`auto-entities`](https://github.com/thomasloven/lovelace-auto-entities) by [thomasloven](https://github.com/thomasloven).
+ [`slider-entity-row`](https://github.com/iantrich/config-template-card) by [iantrich](https://github.com/iantrich).
+ [`custom-header`](https://github.com/maykar/custom-header) by [maykar](https://github.com/maykar).
+ [`lovelace-swipe-navigation`](https://github.com/maykar/lovelace-swipe-navigation) by [maykar](https://github.com/maykar).
+ [`button-card`](https://github.com/custom-cards/button-card).

***

# Notes

The Header that is used for separating cards is from the theme [soft-ui](https://github.com/N-l1/lovelace-soft-ui).

***

# Special thanks

+ to all the authors above,
+ JuanMTech for his awesome themes,
+ and the helpful folks over at the HA Discord.


