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

## Program counter `program_counter`

The program counter is the main state register that defines what will happen in the next instruction cycle. It has the following behaviour:

* **State**
  * `pc`: 64-bit register
* **Inputs**
  * `immediate`: value to add to `pc` if `pc_src` = 1
  * `clk`: rising-edge clock
  * `rstn`: synchronous active-low reset. 
  * `pc_src`: 1 bit
	* 0: add 4 to `pc` on clock edge
	* 1: add `immediate` to `pc` on clock edge
* **Outputs**
  * `pc`: 64-bit read-only net of `pc`


The program counter is used to address the `instruction_memory`

## Instruction memory `instruction_memory`

The instruction memory is a read-only view of the instructions. It is addressed with 64 bits, but is only 1KiB in size. It is combinational, in the sense that changes on the address input immediately translate to changes on the output port. It has the following behaviour:

* **State** 
  * `im`: the instruction memory, 256 4-byte words, pre-loaded with an instruction at synthesis-time.
* **Inputs**
  * `pc`: the program counter (output of `program_counter`). Must be 4-byte aligned.
* **Outputs**
  * `instr`: `im[pc]`, the 32-bit instruction work at address `pc` (immediately updated on `pc` change).
  
