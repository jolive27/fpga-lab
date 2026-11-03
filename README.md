# fpga-lab

Learning Verilog and implementing increasingly tougher programs on a Tang Nano 20K seated on a breadboard.

## Projects

- **blink** — first program: blinks the onboard LEDs, and pauses while the button is held
- **off** — turns all the LEDs off (mostly so I don't go blind)
- **counter** — a simple counter, with a testbench
- **toggle** — an external button switches an LED on and off; includes a debouncer, so one press counts exactly once
- **lfsr** — a button-stepped 8-bit LFSR (a hardware pseudo-random generator); each press steps it to the next value, shown on the LEDs

## Building

`./build.sh <name>` builds a project and flashes it to the board (e.g. `./build.sh lfsr`). Saves a lot of typing during setup

Designs are checked in simulation with a testbench before they go on the board. The LFSR's full 255-step cycle was verified that way, since the board only shows part of each value.

## Logic analyzer

Working on getting it to work with my Macbook, actually turning out to be a huge pain in the behind, probably a PICNIC error...
