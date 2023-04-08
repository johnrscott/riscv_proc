# A Vivado script that demonstrates a very simple RTL-to-bitstream non-project batch flow
#
# NOTE: typical usage would be "vivado -mode tcl -source run_design.tcl"
#
# STEP#0: define output directory area.
#
set output_dir ./output
file mkdir $output_dir

# Setup design sources and constraints
#
read_verilog [ glob ./src/*.v ]
read_xdc ./src/constraints.xdc

# Run synthesis, report utilization and timing estimates, write checkpoint design
synth_design -top binary_counter -part xc7a35ticsg324-1L
write_checkpoint -force $output_dir/post_synth
report_timing_summary -file $output_dir/post_synth_timing_summary.rpt
report_power -file $output_dir/post_synth_power.rpt

# Run placement and logic optimzation, report utilization and
# timing estimates, write checkpoint design
opt_design
place_design
phys_opt_design
write_checkpoint -force $output_dir/post_place
report_timing_summary -file $output_dir/post_place_timing_summary.rpt

# Run router, report actual utilization and timing, write
# checkpoint design, run drc, write verilog and xdc out
route_design
write_checkpoint -force $output_dir/post_route
report_timing_summary -file $output_dir/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $output_dir/post_route_timing.rpt
report_clock_utilization -file $output_dir/clock_util.rpt
report_utilization -file $output_dir/post_route_util.rpt
report_power -file $output_dir/post_route_power.rpt
report_drc -file $output_dir/post_imp_drc.rpt
write_verilog -force $output_dir/bft_impl_netlist.v
write_xdc -no_fixed_only -force $output_dir/bft_impl.xdc

# STEP#5: generate a bitstream
write_bitstream -force $output_dir/bft.bit
