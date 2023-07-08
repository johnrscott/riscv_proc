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
      uut.im[5] = 'h001006b3; // x13 = x0 + x1 = -1
      uut.im[6] = 'h00520733; // x14 = x4 + x5 = -13
      uut.im[7] = 'h000007b3; // x15 = x0 - x0 = 0
      uut.im[8] = 'h00520833; // x16 = x4 + x5 = -23
      uut.im[9] = 'h001008b3; // x17 = x0 - x1  = 1
   end
   
   initial begin: check_instructions_at_pc_address

      pc = 0;
      #period;
      if (instr !== 'h00106433)
	$error("Error in instruction memory at pc = 0");

      pc = 1;
      #period;
      if (instr !== 'h0020e4b3)
	$error("Error in instruction memory at pc = 0");

   end
   
endmodule
