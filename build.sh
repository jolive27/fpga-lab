#!/bin/sh
# Created build script so I didn't spend half my time typing in commands to flash script onto hardware
set -e
TOP=${1:-blink}
yosys -q -p "read_verilog $TOP.v; synth_gowin -family gw2a -top $TOP -json $TOP.json"
nextpnr-himbaechel -q --json $TOP.json --write pnr.json --device GW2AR-LV18QN88C8/I7 --vopt family=GW2A-18C --vopt cst=tangnano20k.cst
gowin_pack -d GW2A-18C -o $TOP.fs pnr.json
openFPGALoader -b tangnano20k $TOP.fs
