# Specification

The UART transmitter/receiver module will be support an 8-bit transfer, without stop bit or parity check. The transfer speed will be 9600bps.

The module interface will be as follows:

* **Outputs**
  * `tx`: the module serial UART output. Connected to the `RXD` pin of the FT2232 chip.
  
* **Inputs**
  * `rx`: the module serial UART input. Connected to the `TXD` pin of the FT2232 chip.
  
