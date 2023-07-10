# Simple UART Module

This folder contains a UART module for interfacing the Arty-A7 FT2232 UART bridge. The UART pins are
* **TXD** Data from host PC to FPGA (FPGA `rx`). Tied to pin A9.
* **RXD** Data from FPGA to host PC (FPGA `tx`). Tied to pin D10.

For debugging using an oscilloscope, these two pins are duplicated to `rx_debug` on pin G13 and `tx_debug` on pin D13 (respectively, pin 1 and pin 7 on jumper JA).

## Connecting to the UART

Run the following commands to install the serial utility `cu` and add yourself to the `dialout` group. 

```bash
sudo apt install libusb cu libusb-1.0-0-dev
sudo usermod -aG dialout {your-username}
```

Restart the computer to ensure the group change takes effect. Then plug in the FPGA and check that `ttyUSB0` and `ttyUSB1` are both showing in `/dev/` (one is the programming serial connection and the other is the UART):

```bash
ls /dev/ | grep USB
```

To check everything is working, connect to the default-installed demo program on the Arty A7 by running:

```bash
cu -s 115200 -l /dev/ttyUSB1
```

Type `~.` to exit `cu`.


## FT2232 Behaviour 

The following information was checked by looking at an oscilloscope of the TXD output from the FT2232 chip (`rx_debug`) on an oscilloscope. 

When running `cu -s 115200 -l /dev/ttyUSB1`, the baud is 115200 bits per second, meaning each bit is 8.68us. As a result, 8 bits takes 69.4us and 9 bits takes 78.2us. The measured time of the byte transmission on the oscilloscope is 78.4us, so 9 bits are transmitted. The transmission begins with a start bit, which is low for one bit period. Then the next 8 bytes are the data; the bit order is least-significant bit first  (verified using `@`, code 0x40, which has a single `1` towards the end of the transmission). There are no stop bits.


## Debugging FPGA programming problems

If you get the following message when attempting to connect to the FPGA board:

```
Vivado% current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210319B0C665A]
ERROR: [Labtoolstcl 44-199] No matching targets found on connected servers: localhost
Resolution: If needed connect the desired target to a server and use command refresh_hw_server. Then rerun the get_hw_targets command.
ERROR: [Common 17-39] 'get_hw_targets' failed due to earlier errors.
```

you may be missing [cable drivers](https://support.xilinx.com/s/article/54381?language=en_US). Navigate to the folder `/tools/Xilinx/Vivado/2023.1/data/xicom/cable_drivers/lin64/install_script/install_drivers` (or your equivalent) and run

```bash
sudo ./install_drivers
```

Unplug and plug back in all USB cables, and run `refresh_hw_server` (or restart Vivado TCL console). The connection should now work.
