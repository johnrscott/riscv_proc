module top(input clk_sys, reset, output led);

   wire clk, locked;
   clk_wiz_0 clk0(.clk_in1(clk_sys), 
		  .clk_out1(clk),
		  .reset(reset),
		  .locked(locked));
   example m0(.clk(clk),
	      .led(led));

endmodule
