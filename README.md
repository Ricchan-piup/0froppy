# Froppy

A small arcade-style **PICO-8** game made by Robin Berteloot.

## What it is

In **Froppy**, you control a frog on the ground and use your tongue to catch falling enemies before they hit you or destroy the floor.

- Enemies: water, fire, and plant
- Catching enemies increases score
- Catching them higher on the screen gives more points

## Controls

Default PICO-8 controls:

- **Move**: Left / Right (`⬅️` / `➡️` or D-pad)
- **Tongue**: `Z` (button 4)
- **Start / Confirm**: `X` (button 5)

Notes:

- Press and hold `Z` to extend the tongue.
- Release `Z` to pull the tongue back.
- Press `X` on the title screen to start.
- Press `X` on game over to restart.

## Scoring

Points are based on enemy height when caught:

- High catch: **1000**
- Mid catch: **100**
- Low catch: **10**

## Project files

- `0main.p8` – main PICO-8 cartridge file
- `1froppy.lua` – game states / main loop
- `2level.lua` – level setup, spawn logic, floor management
- `3actors.lua` – actor/enemy data and movement
- `4player.lua` – player state machine and tongue behavior
- `5ui.lua` – score popups and gauges
- `6sfx.lua` – type-based sound effects
- `0main.html`, `0main.js` – web export files

## Run the game

### In PICO-8

1. Put this folder in your PICO-8 carts directory (already done in your setup).
2. Open PICO-8.
3. Load and run:

```txt
load 0main.p8
run
```

### In a browser (export)

Open `0main.html` in a browser (or serve it with a simple local server if your browser blocks local file scripts).

## Status

This is an actively iterated personal project and has a straightforward, prototype-friendly code structure.