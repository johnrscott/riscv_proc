`timescale 1 ns/10 ps

module tb_uart_tx();

   reg [7:0] data_bus;

   localparam half_cycle = 10;
   localparam period = 20;

   reg 	     clk, rst_b;
     
   uart_tx uut(.serial_out(serial_out),
	       .data_bus(data_bus),
	       .load_xmt_datareg(load_xmt_datareg),
	       .byte_ready(byte_ready),
	       .t_byte(t_byte),
	       .clk(clk),
	       .rst_b(rst_b));
   
   initial begin: clock_loop
      clk = 0;
      rst_b = 0;
      data_bus = "a";
      forever begin
	 #half_cycle clk = 1;
	 #half_cycle clk = 0;
      end
   end

   initial begin: check_uart_transmit_sequence

      #period;
      #period;
      rst_b = 1;
      
      // pc = 0;
      // #period;
      // if (instr !== 'h00106433)
      // 	$error("Error in instruction memory at pc = 0");

   end

endmodule
