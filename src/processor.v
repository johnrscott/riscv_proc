module processor(clk);
   input clk;
   
   reg 	 ctrl_reg_num;
   reg 	 ctrl_write;
   reg [53:0] data_out, data_in;
   
   register_file reg0(.clk(clk),
		      .ctrl_reg_num(ctrl_reg_num),
		      .ctrl_write(ctrl_write),
		      .data_out(data_out),
		      .data_in(data_in));
   
endmodule
