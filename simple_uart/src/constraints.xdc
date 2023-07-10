# Set voltage signalling level
set_property IOSTANDARD LVCMOS18 [get_ports {tx}]
set_property IOSTANDARD LVCMOS18 [get_ports {rx}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_debug}]
set_property IOSTANDARD LVCMOS18 [get_ports {rx_debug}]

# Set the correct pins to connect to FT2232
set_property PACKAGE_PIN D10 [get_ports {tx}]
set_property PACKAGE_PIN A9 [get_ports {rx}]

# Duplicate the rx/tx signals to pins 1 and 7 on jumper JA
# (the two rightmost pins on the board, looking into the jumpers)
set_property PACKAGE_PIN D13 [get_ports {tx_debug}]
set_property PACKAGE_PIN G13 [get_ports {rx_debug}]
