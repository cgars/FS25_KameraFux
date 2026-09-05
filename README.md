# KameraFux 0.2.1.0

KameraFux adds independent movement to the active third-person vehicle camera
in Farming Simulator 25. Mouse look, mouse-wheel zoom, vehicle controls and
AutoDrive controls remain unchanged.

## Controls

| Default key | Action |
|---|---|
| Numpad 8 / Numpad 2 | Move forward / backward |
| Numpad 4 / Numpad 6 | Move left / right |
| Numpad 9 / Numpad 3 | Move up / down |
| Numpad 0 | Reset the additional camera offset |

These are only the default bindings. Every KameraFux action can be reassigned
in the regular Farming Simulator menu under **Settings → Controls → Vehicle**.
This also makes the mod usable on laptops without a numeric keypad.

Camera movement is intentionally limited to exterior vehicle cameras. Num Lock
may need to be enabled when using the default bindings.

## Installation

1. Download or build `FS25_KameraFux.zip`.
2. Copy the ZIP without extracting it to
   `Documents/My Games/FarmingSimulator2025/mods`.
3. Enable KameraFux when loading the savegame.
4. Reassign its controls in **Settings → Controls → Vehicle** if desired.

## Building the mod ZIP

Create a ZIP containing the files from the repository root. `modDesc.xml` must
be located directly at the root of the archive, not inside an additional
folder.

## Compatibility and test status

Version 0.2 registers its actions directly on the active FS25 vehicle camera.
The mod has been tested successfully in Farming Simulator 25. It is currently
intended for single-player use.

If the mod does not react, check `log.txt` in the Farming Simulator 2025 user
directory for entries beginning with `[FS25_KameraFux]`.

## License

MIT. See `LICENSE`.
