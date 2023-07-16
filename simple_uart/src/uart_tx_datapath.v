module uart_tx_datapath
  #(word_size = 8,
    size_bit_count = 3,
    all_ones = {(word_size + 1)(1'b1)} // 9-bit all-ones
    )
   (output serial_out, bc_lt_bcmax,
    input [word_size-1:0] data_bus,
    input 		  load_xmt_datareg, load_xmt_shiftreg, start,
			  shift, clear, clk, rst_b);

   // The data register is word_size bits long and contains
   // the data to be sent out on UART  
   reg [word_size-1:0] 	  xmt_datareg;

   // There is one extra bit in the shift register for the stop bit 
   reg [word_size:0] 	  xmt_shiftreg;

   always @(posedge clk, negedge rst_b)
     if (rst_b == 0) begin
	xmt_shiftreg <= all_ones;
	bit_count <= 0;
     end
     else begin: register_transfers
	// Load data_bus input data into the transmit register
	if (load_xmt_datareg == 1'b1) xmt_datareg <= data_bus;

	// Load shift register including stop bit
	if (load_xmt_shiftreg == 1'b1) xmt_shiftreg <= {xmt_datareg, 1'b1};

	if (clear == 1'b1) bit_count <= 0;

	// Shift right and fill top with ones
	if (shift == 1'b1) begin
	   xmt_shiftreg <= {1'b1, xmt_shiftreg[word_size:1]};
	   bit_count <= bit_count + 1;
	end
     end
endmodule
