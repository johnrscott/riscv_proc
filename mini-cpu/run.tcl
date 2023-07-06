set output_dir ./output
file mkdir $output_dir

read_verilog [ glob ./src/*.sv ]

# Elaborate design
synth_design -rtl -top processor -part xc7a35ticsg324-1L

# Synthesize design
synth_design -top processor -part xc7a35ticsg324-1L
