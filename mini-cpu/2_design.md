# Design

The design is based on the simple single-cycle design described in PH2018:Chap4. Refer to Figure 4.17 while reading the following notes.

There are three storage elements in the design:
* the program counter, `pc`
* the register file, x0-x32
* the data memory

For the purposes of this design, the instruction memory is considered read-only and combinational, even if it is implemented in registers (writing the program counter to its address port will immediately load the instruction, as if it were combinational).

All instructions of the computer operate in a single-cycle, meaning that the calculation is combinational; the operating of the computer involves three stages:
1. The program counter register is updated on a rising clock edge. Immediately (combinationally), the instruction appears at the output of the instruction memory.
2. Immediately, the datapath "executes" the instruction (really, propagates the calculation through combinational logic), and the output stabilises at the input to the storage elements of the design (the register file and data memory).
3. The instruction completes on the next rising clock edge, where the output data are clocked into the register file and data memory. This rising edge is also the start of the next instruction.

The combinational logic of the datapath must stabilise at least a *setup time* before the next rising clock edge (so that the results stored into the registers and data memory are valid). The datapath must hold the data in place for at least a *hold time* after the rising clock edge (so that the loading of the next instruction's program counter does not disturb the storing of data from the last instruction, which both happen at the same clock edge).

The following sections describe the requirements of the modules that make up the datapath.

## Program counter

The program counter is the main state register that defines what will happen in the next instruction cycle. It has the following behaviour:

* **State**
  * `pc`: 64-bit register
* **Inputs**
  * `immediate`: value to add to `pc` if `pc_src` = 1
  * `clk`: rising-edge clock
  * `rstn`: synchronous active-low reset. 
  * `pc_src`: 1 bit
	* 0: add 4 to `pc` on next clock edge
	* 1: add `immediate` to `pc`
* **Outputs**
  * `pc`: 64-bit read-only net of `pc`





