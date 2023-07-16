# UART Module Design

The module is based on the design in Section 7.4.1 *Ciletti, 2017, Advanced Digital Design with Verilog HDL*. This file contains the design of the transmitter and receiver.

## UART Transmitter

The transmitter is synchronised with the system clock. It has the following interface:

* **Outputs**
  * `serial_out`: the module serial UART output. 
* **Inputs**
  * `data_bus`: 8-bit data bus input
  * `load_xmt_datareg`: assert to load from `data_bus` into an internal transmit register
  * `byte_ready`: assert to load from internal transmit register to shift register
  * `t_byte`: assert to begin transmission
  * `clk`: the clock
  * `rst_b`: active-low synchronous reset. Resets all internal counters and sets the transmit shift register to all ones. 

### Datapath `uart_tx_datapath`

The datapath consists of a shift register preloaded with the information to be sent out over UART, and the signals required to shift out the data.

* **Parameters**
  * `word_size`: The length of the data being transmitted (e.g. 8 for 1 byte), not including start/stop/parity.
* **Outputs**
  * `serial_out`: The UART serial output
  * `bc_lt_bcmax`: asserted if the bitcount is less than the `word_size` + 1
* **Inputs**
  * `data_bus`: `word_size` bits; The input data bus where data to be sent is loaded in parallel
  * `load_xmt_datareg`: asserted to load the transmit register from the `data_bus`
  * `load_xmt_shiftreg`: asserted to load the shifter register from the transmit register.
  * `start`: asserted to send the start bit
  * `shift`: asserted to shift data out onto `serial_out` from the shift register
  * `clear`: reset the bit counter
  * `clk`: the clock
  * `rst_b`: active-low synchronous reset

