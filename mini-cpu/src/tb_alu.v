`timescale 1 ns/10 ps

module tb_alu();

   localparam period = 20;
   localparam xlen = 64;

   localparam
     alu_ctrl_and = 3'b000,
     alu_ctrl_or = 3'b001,
     alu_ctrl_add = 3'b010,
     alu_ctrl_sub = 3'b110,
     alu_ctrl_slt = 3'b111;
      
   reg [xlen-1:0] a, b;
   reg [2:0] 	  alu_ctrl;
   wire [xlen-1:0] result;
   wire 	   zero;
   
   alu #(.xlen(xlen)) uut
     (.result(result),
      .zero(zero),
      .a(b), .b(b),
      .alu_ctrl(alu_ctrl));
   
   initial begin
      
      // 1010 & 0101 = 0000
      a = 4'b1010;
      b = 4'b0101;
      alu_ctrl = alu_ctrl_and;
      #period;
      if ((result !== 0) || (zero !== 1))
	$error("Error on output 1010 & 0101 = 0000");

      // 1010 | 0101 = 1111
      a = 4'b1010;
      b = 4'b0101;
      alu_ctrl = alu_ctrl_or;
      #period;
      if ((result !== 4'b1111) || (zero !== 0))
	$error("Error on output 1010 | 0101 = 1111");

      
   end



endmodule
