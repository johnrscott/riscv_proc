set output_dir ./output
file mkdir $output_dir

create_project -in_memory -part xc7a35ticsg324-1L

read_verilog [ glob ./src/*.v ]
read_xdc ./src/constraints.xdc
read_ip ./.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci

generate_target all [get_ips]

#synth_design -top debug_uart -part xc7a35ticsg324-1L
synth_design -top debug_uart

# write_checkpoint -force $output_dir/post_synth
# report_timing_summary -file $output_dir/post_synth_timing_summary.rpt
# report_power -file $output_dir/post_synth_power.rpt

opt_design
place_design
phys_opt_design

# write_checkpoint -force $output_dir/post_place
# report_timing_summary -file $output_dir/post_place_timing_summary.rpt

route_design

# write_checkpoint -force $output_dir/post_route
# report_timing_summary -file $output_dir/post_route_timing_summary.rpt
# report_timing -sort_by group -max_paths 100 -path_type summary -file $output_dir/post_route_timing.rpt
# report_clock_utilization -file $output_dir/clock_util.rpt
# report_utilization -file $output_dir/post_route_util.rpt
# report_power -file $output_dir/post_route_power.rpt
# report_drc -file $output_dir/post_imp_drc.rpt
# write_verilog -force $output_dir/bft_impl_netlist.v
# write_xdc -no_fixed_only -force $output_dir/bft_impl.xdc

write_bitstream -force $output_dir/bft.bit

# Connect to the Digilent Cable on localhost:3121
open_hw_manager
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210319B0C665A]
open_hw_target

# Program and Refresh the XC7K325T Device
set device [lindex [get_hw_devices] 0]
current_hw_device $device
refresh_hw_device -update_hw_probes false $device
set_property PROGRAM.FILE $output_dir/bft.bit  $device

#set_property PROBES.FILE "C:/design.ltx" $device

program_hw_devices $device
refresh_hw_device $device
