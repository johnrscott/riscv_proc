# Simple UART Module

This folder contains a UART module for interfacing the Arty-A7 FT2232 UART bridge. The UART pins are
* **TXD** Data from host PC to FPGA (FPGA `rx`). Tied to pin A9.
* **RXD** Data from FPGA to host PC (FPGA `tx`). Tied to pin D10.

For debugging using an oscilloscope, these two pins are duplicated to `rx_debug` on pin G13 and `tx_debug` on pin D13 (respectively, pin 1 and pin 7 on jumper JA).


