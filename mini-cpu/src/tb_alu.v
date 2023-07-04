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
      .a(a), .b(b),
      .alu_ctrl(alu_ctrl));
   
   initial begin
      
      // 1010 & 0101 = 0000
      a = 4'b1010; b = 4'b0101;
      alu_ctrl = alu_ctrl_and;
      #period;
      if ((result !== 0) || (zero !== 1))
	$error("Error on output 1010 & 0101 = 0000");

      // 1010 | 0101 = 1111
      a = 4'b1010; b = 4'b0101;
      alu_ctrl = alu_ctrl_or;
      #period;
      if ((result !== 4'b1111) || (zero !== 0))
	$error("Error on output 1010 | 0101 = 1111");

      // 5 + 10 = 15, addition of positives
      a = 5; b = 10;
      alu_ctrl = alu_ctrl_add;
      #period;
      if ((result !== 15) || (zero !== 0))
	$error("Error on output 5 + 10 = 15");

      // -50 + 10 = -40, addition resulting in negative
      a = -50; b = 10;
      alu_ctrl = alu_ctrl_add;
      #period;
      if ((result !== -40) || (zero !== 0))
	$error("Error on output -50 + 10 = -40");

      // -1 + 1 = 0, addition wrapping to zero
      a = -1; b = 1;
      alu_ctrl = alu_ctrl_add;
      #period;
      if ((result !== 0) || (zero !== 1))
	$error("Error on output -1 + 1 = 0");
      
      // 5 - 6 = -1, subtraction resulting in negative
      a = 5; b = 6;
      alu_ctrl = alu_ctrl_sub;
      #period;
      if ((result !== -1) || (zero !== 0))
	$error("Error on output 5 - 6 = -1");

      // 102 - 22 = 80, subtraction resulting in positive
      a = 102; b = 22;
      alu_ctrl = alu_ctrl_sub;
      #period;
      if ((result !== 80) || (zero !== 0))
	$error("Error on output 102 - 22 = 80");

      // 0 < 0 is false
      a = 0; b = 0;
      alu_ctrl = alu_ctrl_slt;
      #period;
      if ((result !== 0) || (zero !== 1))
	$error("Error on output 0 < 0 = false");

      // 5 < 10 is true
      a = 5; b = 10;
      alu_ctrl = alu_ctrl_slt;
      #period;
      if ((result !== 1) || (zero !== 0))
	$error("Error on output 5 < 10 = true");

      // -1 < 0 is true (edge case)
      a = -1; b = 0;
      alu_ctrl = alu_ctrl_slt;
      #period;
      if ((result !== 1) || (zero !== 0))
	$error("Error on output -1 < 0 = true");
      
   end



endmodule
