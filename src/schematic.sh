#!/usr/bin/env bash

# Use this script to view a verilog module schematic. Invoke as
#
#   ./schematic.sh top_module_name top_module_file.v
#
# You need to run . settings.sh first.

yosys -p "read -sv $2; prep -top $1 -flatten; write_json output.json"
netlistsvg output.json

# sudo apt install imagemagick
display out.svg

