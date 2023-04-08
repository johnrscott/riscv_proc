# FPGA-based RISC-V processor

## Installing Vivado

Download the installer for the latest version, mark it as executable, and run it:

```bash
chmod u+x Xilinx_Unified_2022.2_1014_8888_Lin64.bin
./Xilinx_Unified_2022.2_1014_8888_Lin64.bin
```

Ignore the warning about unsupported OS if you get it (tested on Linux Mint 20.1 Cinnamon). Put in your login details, and progress to install Vivado. Choose to install Vivado ML Standard. Choose the devices you want to install (at least Artix-7), and progress to choose an install location. By installing less devices, the download size and disk space requirement will be minimised. Pick `/tools/Xilinx` and begin the download/install.

## Project Mode Notes

The project is tested on the Arty A7 (containing the Artix-A7 35T FPGA) development board. In project mode, the BSP is called `Arty A7-35`, file revision 1.1. You can create a new project by opening Vivado and walking through the new project wizard. You do not need to add any sources.

Once the project is open, add files using the `Add Sources` button. New verilog files will appear in the `Design Sources` section of the `Sources` window. For the purpose of this example, create a module called `demo` with the following contents:

```verilog
module demo(
    input button_input,
    output led_output
    );
    assign led_output = button_input;
endmodule
```

Click `Create Block Design`. Create two new ports (right click, `Create Port`) and call them `button_in` and `led_out` (set to type `data`). Right click the block design and create an HDL wrapper. Then drag and drop the demo module onto the block design and connect it to the input and output ports.

Click `Open Elaborated Design`. The schematic will show the `demo` TL in the block design replaced with a single wire joining the output to the input. Open `I/O planning` and connect `button_in` to port D9 (`BTN0` on the board) and `led_out` to H5 (`LD4` on the board). Pick the default `LVCMOS18` I/O type for both pins. Save the changes to a new constraints file (call it `constraints`).

Click `Open Synthesized Design`. The synthesized design contains buffers for the input and output in addition to the wire. Click `Open Implemented Design`. The implementation will lay out the circuit on the FPGA and compute timing analysis. Click `Generate Bitstream`, and use the `Hardware Manager` to program the device. When programming, if the bitstream is not detected automatically, locate it in the `demo.runs/impl_1` folder. 

For another simple example, the following module will will count up over 4-bits at the rising edge of the button (a button press):

```verilog
module binary_counter(
    input button_input,
    output reg[3:0] led_output
    );
    always @(posedge button_input) begin
        led_output <= led_output + 1;
    end
endmodule
```

In the block design, replace the single LED output port with a vector port of width four. Map the connections (least-significant-bit first) to H5, J5, T9, T10 in the synthesized design, and then implement and run. Even with no button de-bouncing, the result is reasonably robust.

## Non-project Mode Notes

To add `vivado` and other design tools to the PATH, source `/tools/Xilinx/Vivado/2022.2/settings64.sh` (run `. settings.sh`). To open a Vivado prompt for Tcl commands, run `vivado -mode tcl`.

At any time, you can run `start_gui` to open the Vivado GUI with the current state of the system (e.g. after synthesis). Run `stop_gui` in the GUI Tcl console to go back to the `Vivado%` prompt. Do not click the red x; that will close the program (including the `Vivado%` prompt), losing the state of the in-memory project.

### Synthesis

After running the synthesis command, you can run `start_gui` and press F4 to view the schematic of the top level module. Run `stop_gui` to exit back to the console.
