module uart_tx #(parameter word_size = 8)
   (output serial_out,
    input [word_size-1:0] data_bus,
    input 		  load_xmt_datareg, byte_ready, t_byte, clk, rst_b);

   uart_tx_control m0(.load_xmt_datareg_out(load_xmt_datareg_internal),
		      .load_xmt_shiftreg(load_xmt_shiftreg),
		      .start(start),
		      .shift(shift),
		      .clear(clear),
		      .load_xmt_datareg(load_xmt_datareg),
		      .byte_ready(byte_ready),
		      .t_byte(t_byte),
		      .bc_lt_bcmax(bc_lt_bcmax),
		      .clk(clk),
		      .rst_b(rst_b));

   uart_tx_datapath m1(.serial_out(serial_out),
		       .bc_lt_bcmax(bc_lt_bcmax),
		       .data_bus(data_bus),
		       .load_xmt_datareg(load_xmt_datareg_internal),
		       .load_xmt_shiftreg(load_xmt_shiftreg),
		       .start(start),
		       .shift(shift),
		       .clear(clear),
		       .clk(clk),
		       .rst_b(rst_b));

endmodule
