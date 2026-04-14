# LED Ping-Pong

VHDL/FPGA project for the Nexys A7-50T board.

## Team members
- Jakub Křiva
- Jonáš Salich
- Pavel Stastny

## Project goal
The goal of this project is to implement a simple two-player LED Ping-Pong game on the Nexys A7-50T FPGA board.

The ball is represented by a moving LED across the 16 onboard LEDs. The players use push buttons to return the ball when it reaches the edge on their side. If a player fails to react in time, the round is lost and the LEDs flash.

## Planned features
- Ball movement across 16 LEDs
- Left and right player button input
- Ball direction change after a successful hit
- Miss detection
- Reset/start logic

## Hardware
- Nexys A7-50T
- 16 onboard LEDs
- Push buttons
- 7 segment display

## Project structure
- `src/` – VHDL source files
- `sim/` – simulation files and testbenches
- `constr/` – XDC constraints files
- `docs/` – images, poster, video link, and documentation
- `vivado/` – Vivado project files

## Current status
The repository structure has been created. The next step is to implement the VHDL modules and prepare simulations.
