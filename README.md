# Framework 16 Custom QMK Firmware - 7mind Edition

Custom QMK firmware for Framework 16 laptop keyboard with finger zone visualization and ergonomic tweaks.

## Features

### Finger Zone RGB Effect

A custom RGB effect that colors each key according to which finger should press it in touch typing:

| Zone | Finger | Color |
|------|--------|-------|
| 0 | Pinkies (both hands) | Pink |
| 1 | Ring fingers | Yellow |
| 2 | Middle fingers | Blue |
| 3 | Left index | Green |
| 4 | Thumbs | Cyan |
| 5 | Right index | Orange |
| 6 | Arrow keys | Red |

### Key Remaps

- **Left Alt ↔ Left GUI swapped** - Alt is now next to Fn, GUI (Super/Win) is next to Space

### Dynamic Lighting

- **Pressed keys glow magenta** - Visual feedback when typing
- **ESC indicates F-row mode**:
  - **Pink** = F-keys mode (F1-F12 default)
  - **Orange** = Media keys mode
- **FN layer highlighting** - When Fn is held, only keys with assigned functions stay lit; unassigned keys turn off

### F-Row Behavior

- **Default: F-keys mode** - F1-F12 are the default, hold Fn for media controls
- **Toggle with Fn+ESC** - Switches between F-keys and media mode for the session
- **Resets on reboot** - Always starts in F-keys mode

## Building

### Prerequisites

- Nix with flakes enabled
- direnv (optional, for automatic environment)

### Build Steps

```bash
cd framework-qmk-7mind

# Enter development environment
direnv allow   # or: nix develop

# Build firmware
./build.sh
```

Output: `framework_ansi_finger_zones.uf2`

## Flashing

### Enter Bootloader Mode

1. Power off the laptop
2. Slide the touchpad down to reveal the QMK keyboard
3. Hold both **left and right Alt** keys
4. While holding, slide the touchpad back up
5. Release Alt keys
6. The keyboard appears as a USB drive

### Flash Firmware

1. Copy `framework_ansi_finger_zones.uf2` to the USB drive
2. Keyboard automatically reboots with new firmware

### Reset EEPROM (if needed)

If settings are corrupted, flash `erase_flash.uf2` first (from Framework's QMK releases), then flash the custom firmware.

## Keymap Layers

| Layer | Description |
|-------|-------------|
| `_BASE` | Media keys on F-row (legacy default) |
| `_FN` | F1-F12 + RGB controls when Fn held |
| `_FN_LOCK` | F-keys default mode (active on boot) |
| `_FM` | Media keys when Fn held in F-keys mode |

## Special Keys (Fn Layer)

| Key | Function |
|-----|----------|
| Fn + ESC | Toggle F-keys/Media mode |
| Fn + W | RGB Toggle |
| Fn + E | RGB Mode Next |
| Fn + S | SysRq |
| Fn + [ | Activate Finger Zones effect |
| Fn + ] | Clear EEPROM |
| Fn + \ | Bootloader mode |
| Fn + Arrows | Home/PgUp/PgDn/End |

## Project Structure

```
framework-qmk-7mind/
├── flake.nix                 # Nix flake (fetches QMK + deps)
├── build.sh                  # Build script
├── .envrc                    # direnv configuration
├── keymaps/finger_zones/
│   ├── keymap.c              # Key mappings and layer definitions
│   ├── rgb_matrix_user.inc   # Custom RGB effect implementation
│   └── rules.mk              # Build configuration
└── README.md
```

## Credits

- Based on [Framework's QMK fork](https://github.com/FrameworkComputer/qmk_firmware) v0.3.1
- QMK Firmware: https://qmk.fm
