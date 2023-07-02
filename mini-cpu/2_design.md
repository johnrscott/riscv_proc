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
* **Outputs (combinational)**
  * `pc`: 64-bit read-only net of `pc`

The program counter is used to address the `instruction_memory`

## Instruction memory `instruction_memory`

The instruction memory is a read-only view of the instructions. It is addressed with 64 bits, but is only 1KiB in size. It is combinational, in the sense that changes on the address input immediately translate to changes on the output port. It has the following behaviour:

* **State** 
  * `im`: the instruction memory, 256 4-byte words, pre-loaded with an instruction at synthesis-time.
* **Inputs**
  * `pc`: the program counter (output of `program_counter`). Must be 4-byte aligned.
* **Outputs (combinational)**
  * `instr`: `im[pc]`, the 32-bit instruction word at address `pc` (immediately updated on `pc` change).
  
## Register file `register_file`

The register file requires two combinational paths to read `rs1` and `rs2`, and a sequential input to update `rd`. The behaviour is as follows:

* **State**
  * `registers`: an array of 32 64-bit registers, initialised to zero
* **Inputs**
  * `rs1`: a 5-bit integer identifying the register `rs1` to read
  * `rs2`: a 5-bit integer identifying the register `rs2` to read
  * `rd`: a 5-bit integer identifying the register `rd` to write (if `rd` is zero, no write is performed)
  * `rd_data`: the data to write to `rd`, if `write_en` is set
  * `clk`: clock; on rising edge, `rd_data` written to `rd` if `write_en` is set
  * `rstn`: synchronous active-low reset; sets all `registers` to zero 
  * `write_en`: determines whether to write `rd_data` to `rd`
* **Outputs (combinational)**
  * `rs1_data`: 64-bit read-only net of the register referred to by `rs1`
  * `rs2_data`: 64-bit read-only net of the register referred to by `rs2`

The register file propagates the values of the read-registers immediately when `rs1` and `rs2` are set; these values propagate through the rest of the datapath, eventually providing the input `rd_data`, which is loaded into `rd` on the next rising clock edge.

## Data memory `data_memory`

The data memory is 1KiB (byte-addressable), and requires one port which is used for both writing and reading. The read path is combinational (the output is immediately available on setting the address), but data is only written on a rising clock edge. 

Since the read output is combinational, a read enable flag is used to prevent junk on the output port when a write is being performed.

The behaviour is as follows:

* **State**
  * `dm`: an array of 1024 bytes, initialised to zero
* **Inputs**
  * `address`: a 64-bit integer identifying the 
  * `write_data`: 64-bit data to write, if `write_en` is set
  * `clk`: clock; on rising edge, `write_data` written to `dm` if `write_en` is set
  * `rstn`: synchronous active-low reset; sets all bytes in`dm` to zero 
  * `write_en`: determines whether to write `write_data` to `dm`
  * `read_en`: 1 bit.
	* 0: set `read_data` to zero
	* 1: set `read_data` to the 64-bit word starting at `address`
* **Outputs (combinational)**
  * `read_data`: 64-bit word starting at `address`; updated immediately when `address` and `read_en` are changed



