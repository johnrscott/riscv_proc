`timescale 1 ns/10 ps

module tb_immediate_gen();

   localparam period = 20;
   localparam xlen = 64;
      
   reg [xlen-1:0] instr;
   wire [xlen-1:0] imm_mem, imm_branch;
   
   immediate_gen #(.xlen(xlen)) uut
     (.imm_mem(imm_mem),
      .imm_branch(imm_branch),
      .instr(instr));
   

   initial begin

      // Instruction encodings below from here:
      // https://luplab.gitlab.io/rvcodecjs/#q=beq+x1,+x2,+40&abi=false&isa=AUTO   

      // 0x02208463 (beq x1, x2, 40), imm_branch = 40
      instr = 'h02208463;
      #period;
      if (imm_branch !== 40)
	$error("Error on imm_branch = 40, 0x02208463 (beq x1, x2, 40)");

      // 0xfe628ce3 (beq x5, x6, -8), imm_branch = -8
      instr = 'hfe628ce3;
      #period;
      if (imm_branch !== -8)
	$error("Error on imm_branch = -8, 0xfe628ce3 (beq x5, x6, -8)");

      // 0x02213103 (ld x2, 34(x2)), imm_mem = 34
      instr = 'h02213103;
      #period;
      if (imm_mem !== 34)
	$error("Error on imm_branch = 34, 0x02213103 (ld x2, 34(x2))");

      // 0xec62ba23 (sd x6, -300(x5)), imm_mem = 34
      instr = 'hec62ba23;
      #period;
      if (imm_mem !== -300)
	$error("Error on imm_branch = -300, 0xec62ba23 (sd x6, -300(x5))");
      
   end

endmodule
