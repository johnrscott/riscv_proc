`timescale 1 ns/10 ps

module tb_instruction_memory();
   
   localparam period = 20;

   reg [63:0] pc;
   wire [31:0] instr;
   
   instruction_memory uut(.instr(instr),
			  .pc(pc));

   initial begin: initialise_instruction_memory
      // The instruction memory is an array of 4-byte words
      uut.im[0] = 'h00106433; // x8 = x0 | x1 = -1
      uut.im[1] = 'h0020e4b3; // x9 = x1 | x2 = -1
      uut.im[2] = 'h0020f533; // x10 = x1 & x2 = a
      uut.im[3] = 'h003175b3; // x10 = x2 & x3 = 0
      uut.im[4] = 'h00000633; // x12 = x0 + x0 = 0
   end
   
   initial begin: check_instructions_at_pc_address

      pc = 0;
      #period;
      if (instr !== 'h00106433)
	$error("Error in instruction memory at pc = 0");

      pc = 4;
      #period;
      if (instr !== 'h0020e4b3)
	$error("Error in instruction memory at pc = 4");

      pc = 8;
      #period;
      if (instr !== 'h0020f533)
	$error("Error in instruction memory at pc = 8");

      pc = 12;
      #period;
      if (instr !== 'h003175b3)
	$error("Error in instruction memory at pc = 12");

      pc = 16;
      #period;
      if (instr !== 'h00000633)
	$error("Error in instruction memory at pc = 16");

      
      
   end
   
endmodule
