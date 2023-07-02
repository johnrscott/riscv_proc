set output_dir ./output
file mkdir $output_dir

read_verilog [ glob ./src/*.v ]

synth_design -top full_adder -part xc7a35ticsg324-1L
