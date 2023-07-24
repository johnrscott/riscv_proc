// This module exposes the FT2232 pins tx and rx on
// tx_out and rx_out, which can be routed to IO headers
// and read with an oscilloscope.
module debug_uart(output tx, tx_debug, rx_debug,
		  input rx);

   clk_wiz_0 clk();
   
   assign tx_debug = tx;
   assign rx_debug = rx;
   
endmodule

