# Set voltage signalling level
set_property IOSTANDARD LVCMOS18 [get_ports {rstn}]
set_property IOSTANDARD LVCMOS18 [get_ports {clk}]
set_property IOSTANDARD LVCMOS18 [get_ports {main_alu_zero}]

# Set pins for btn0 (reset) and btn1 (clock), and
# the (led4) main_alu_zero
set_property PACKAGE_PIN D9 [get_ports {rstn}]
set_property PACKAGE_PIN C9 [get_ports {clk}]
set_property PACKAGE_PIN H5 [get_ports {main_alu_zero}]

