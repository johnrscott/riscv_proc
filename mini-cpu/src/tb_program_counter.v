`timescale 1 ns/10 ps

module tb_program_counter();
   
   localparam half_cycle = 10;
   localparam period = 20;
   localparam xlen = 64;

   reg [xlen-1:0] imm_branch;
   reg 		  clk, rstn, pc_src;
   
   wire [xlen-1:0] pc;
   
   program_counter #(.xlen(xlen)) uut
     (.pc(pc),
      .imm_branch(imm_branch),
      .pc_src(pc_src),
      .clk(clk),
      .rstn(rstn));
   
   initial begin: clock_loop
      clk = 0;
      rstn = 0;
      imm_branch = 0;
      pc_src = 0;
      forever begin
	 #half_cycle clk = 1;
	 #half_cycle clk = 0;
      end
   end
   
   initial begin

      // Wait for first clock edge
      #period
      
      // Check initial reset
      #period;
      if (pc !== 0)
	$error("Expected pc = 0 in first reset");
      pc_src = 1;
      imm_branch = 4;
      #period;
      if (pc !== 0)
	$error("Expected pc = 0 in first reset with pc_src = 1");
      pc_src = 0;
      imm_branch = 0;
      #period;
      if (pc !== 0)
	$error("Expected pc = 0 in first reset");
      #period;
      if (pc !== 0)
	$error("Expected pc = 0 in first reset");

      // Deassert reset and check normal pc increment
      rstn = 1;
      #period;
      if (pc !== 4)
	$error("Expected pc = 4");
      #period;
      if (pc !== 8)
	$error("Expected pc = 8");
      #period;
      if (pc !== 12)
	$error("Expected pc = 12");
      #period;
      if (pc !== 16)
	$error("Expected pc = 16");
      #period;
      if (pc !== 20)
	$error("Expected pc = 20");
      
      // Check branch forwards
      pc_src = 1;
      imm_branch = 40;
      #period;
      if (pc !== 60)
	$error("Expected pc = 60 after branch forwards");
      pc_src = 0;

      // Check continued increment
      #period;
      if (pc !== 64)
	$error("Expected pc = 64");
      #period;
      if (pc !== 68)
	$error("Expected pc = 68");
		   
      // Check branch backwards
      pc_src = 1;
      imm_branch = -64;
      #period;
      if (pc !== 4)
	$error("Expected pc = 4 after branch backwards");
      pc_src = 0;

      // Check continued increment
      #period;
      if (pc !== 8)
	$error("Expected pc = 8");
      #period;
      if (pc !== 12)
	$error("Expected pc = 12");

      // Check subsequent reset
      rstn = 0;
      #period;
      if (pc !== 0)
	$error("Expected pc = 0 after second reset");
      
      
   end
   
endmodule
