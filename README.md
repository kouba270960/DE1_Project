# LED Ping-Pong

Digital Electronics 1 project focused on implementing a two-player LED Ping-Pong game in VHDL for the Nexys A7-50T FPGA board.

## Team Members

- Jakub Kriva
- Jonas Salich
- Pavel Stastny

## Problem Description

The goal of the project is to design a simple reaction game for two players using the 16 onboard LEDs and push buttons on the Nexys A7-50T board. A moving light represents the ball. Each player must press their button when the ball reaches their side of the LED row. If the player reacts in time, the ball changes direction. If not, the opponent wins the round and the design indicates the miss using a light effect.

The project practices modular VHDL design, finite-state behavior, input synchronization, and integration of user inputs with visible hardware outputs.

## Block Diagram

![Project block diagram](<../DE_1.drawio (1).png>)

## Planned Architecture

The design is divided into several logical parts:

- `ball_controller`: controls ball position, movement direction, and hit or miss detection
- `button handling`: synchronizes and debounces player inputs
- `game control`: manages reset, round start, and win or lose conditions
- `LED output logic`: displays ball movement and round result on the 16 LEDs

## Hardware

- Development board: Nexys A7-50T
- Outputs: 16 onboard LEDs
- Inputs: push buttons

## Repository Content

Current repository content:

- `README.md`: project description
- `hotove/`: reference or supporting VHDL files used during development

Planned project content according to the assignment:

- `src/`: main VHDL source files
- `sim/`: simulation files and testbenches
- `constr/`: XDC constraint file
- `vivado/`: Vivado project files
- `docs/`: poster, screenshots, video link, and other outputs

## Git Flow

The assignment requires continuous team activity documented through commit history. The Git log in this repository is intended to show how the work was split across the team and how the design evolved during the semester.

## Simulation Results

This section will contain screenshots from Vivado simulations proving the behavior of newly created modules, especially:

- ball movement
- direction switching after a successful hit
- miss detection
- reset and round restart logic

Simulation screenshots are not added yet.

## Resource Utilization

This section will contain the synthesis utilization report from Vivado 2025.2.

| Resource | Used | Available | Utilization |
| --- | ---: | ---: | ---: |
| LUT | TBD | TBD | TBD |
| FF | TBD | TBD | TBD |

## Video and Poster

- Demo video: to be added
- Poster: to be added

## References and Tools

- Course assignment: [VHDL projects 2026](https://github.com/tomas-fryza/vhdl-examples/blob/master/lab8-project/README_2026.md)
- Development environment: Vivado 2025.2
- Language: VHDL
