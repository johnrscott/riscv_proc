set output_dir ./output
file mkdir $output_dir

read_verilog [ glob ./src/*.sv ]
read_xdc ./src/constraints.xdc

# Elaborate design
synth_design -rtl -top processor -part xc7a35ticsg324-1L

# Synthesize design
synth_design -top processor -part xc7a35ticsg324-1L

#Create the debug core 
create_debug_core u_ila_0 ila
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]

#connect the probe ports in the debug core to the signals being probed in the design
set_property port_width 1 [get_debug_ports u_ila_0/pc]
connect_debug_port u_ila_0/clk [get_nets {pc}]

opt_design
place_design
phys_opt_design
route_design

write_bitstream -force $output_dir/bft.bit

write_debug_probes probes.ltx

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
