module top(input clk_sys, output led);

   wire clk;
   clk_wiz_0 clk0(.clk_in1(clk_sys), 
		  .clk_out1(clk));
   example m0(.clk(clk),
	      .led(led));

endmodule
