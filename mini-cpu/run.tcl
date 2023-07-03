set output_dir ./output
file mkdir $output_dir


read_verilog [ glob ./src/ripple_carry_adder.v ]

synth_design -top ripple_carry_adder -part xc7a35ticsg324-1L
