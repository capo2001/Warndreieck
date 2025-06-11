# 🚧 Warning Triangle Script for FiveM (ESX)

A realistic warning triangle system that allows players to place a triangle on the ground using an item and pick it back up later. Fully integrated with ESX and inventory systems.

---

## 🚧 Description

- 🧰 Use a `warndreieck` item to place a triangle on the ground
- ↩️ Can be picked up again by the same player
- 📦 Item is consumed on use, returned on pickup
- 🎞️ Includes placement animation and props
- 🧠 Fully configurable
- 🔋 0.00ms resmon idle

---

## 🧰 Requirements

- [`es_extended`](https://github.com/esx-framework/es_extended)
- [`esx_inventory`](https://github.com/esx-framework/esx_inventory)
- Progress bar (e.g. [`ox_lib`](https://overextended.github.io/ox_lib/docs/client/UI/Progress))

---

## 🚀 Features

- 🔻 Place a physical triangle prop on the ground
- 🎞️ Animated placement
- 🔁 Pickup functionality with progress bar
- 🧾 Item removed on use, returned when picked up
- 🌐 Networked entity (visible to others)
- 🔧 Configurable prop model and behavior

---

## ⚙️ Configuration (`config.lua`)

```lua
Config = {}

-- Model for the warning triangle
Config.PropModel = 'prop_tri_pod' -- or 'prop_warning_triangle_01'

-- Progress duration (in ms)
Config.PlaceDuration = 2500
Config.PickupDuration = 1500

-- Notification function
Config.Notify = function(msg)
    lib.notify({ description = msg, type = 'inform' })
end
