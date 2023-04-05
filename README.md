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

Once the project is open, add files using the `Add Sources` button. New verilog files will appear in the `Design Sources` section of the `Sources` window.
