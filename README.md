# 🗺️ BSRP Map HUD

A modern and optimized map HUD system built exclusively for the **BSRP Framework**.

BSRP Map HUD provides a clean and futuristic navigation interface designed to enhance the player experience while exploring the BSRP world. Built with performance and customization in mind, it delivers an improved HUD layout while maintaining smooth gameplay performance.

Designed to integrate seamlessly with the BSRP ecosystem, BSRP Map HUD creates a consistent and immersive user interface experience.

---

## 📌 Features

✅ Fully integrated with **BSRP Framework**
✅ Modern HUD design
✅ Enhanced map display
✅ Optimized performance
✅ Lightweight resource usage
✅ Clean and responsive interface
✅ Customizable appearance
✅ Designed for future BSRP expansions

---

## 🔗 Requirements

This resource requires:

* **BSRP Framework**

  * Repository: https://github.com/BSRPFreeRoam/BSRP-FrameWork

* FiveM Server

* GTA V

* OneSync Recommended

---

## 📥 Installation

### 1. Download

Download or clone the resource into your server resources folder:

```bash
cd resources
git clone https://github.com/BSRPFreeRoam/BSRP-Map-Hud.git
```

---

### 2. Add to `server.cfg`

Add the following:

```cfg
ensure BSRP-Map-Hud
```

Make sure the **BSRP Framework** starts before this resource:

```cfg
ensure BSRP-FrameWork
ensure BSRP-Map-Hud
```

---

## ⚙️ Configuration

All settings can be found inside:

```text
config.lua
```

Example:

```lua
Config = {}

Config.Enabled = true

Config.ShowCompass = true

Config.ShowStreetNames = true

Config.Theme = "futuristic"
```

---

## 🎨 Customization

You can customize:

* HUD position
* Map appearance
* Colors
* Compass settings
* Street display
* UI elements
* Visibility options

Modify the configuration and UI files to match your server's branding.

---

## 🖥️ Framework Integration

BSRP Map HUD is designed specifically for:

* BSRP Framework
* BSRP Chat Systems
* BSRP Vehicle Systems
* Future BSRP resources

The resource integrates directly with the BSRP ecosystem to provide a consistent, modern, and immersive player experience.
