`timescale 1 ns/10 ps

task check_branch_signals(input is_branch, mem_to_reg, 
			 reg_write, mem_read, mem_write,
			 alu_src,
			 input [2:0] alu_ctrl);
   
   if (is_branch !== 1)
     $error("Expected is_branch = 1 in branch instruction");
   
   if (reg_write !== 0)
     $error("Expected reg_write = 0 in branch instruction");
   
   if (mem_write !== 0)
     $error("Expected mem_write = 0 in branch instruction");

   if (alu_src !== 0)
     $error("Expected alu_src = 0 in branch instruction");

   if (alu_ctrl !== 3'b110)
     $error("Expected alu_ctrl = 110 in branch instruction");
   
endtask;

task check_load_signals(input is_branch, mem_to_reg, 
			reg_write, mem_read, mem_write,
			alu_src,
			input [2:0] alu_ctrl);
   
   if (is_branch !== 0)
     $error("Expected is_branch = 0 in load instruction");

   if (mem_to_reg !== 1)
     $error("Expected mem_to_reg = 1 in load instruction");
   
   if (reg_write !== 1)
     $error("Expected reg_write = 1 in load instruction");

   if (mem_read !== 1)
     $error("Expected mem_read = 1 in load instruction");
   
   if (mem_write !== 0)
     $error("Expected mem_write = 0 in load instruction");

   if (alu_src !== 1)
     $error("Expected alu_src = 1 in load instruction");

   if (alu_ctrl !== 3'b010)
     $error("Expected alu_ctrl = 010 in load instruction");
   
endtask;

task check_store_signals(input is_branch, mem_to_reg, 
			 reg_write, mem_read, mem_write,
			 alu_src,
			 input [2:0] alu_ctrl);
   
   if (is_branch !== 0)
     $error("Expected is_branch = 0 in store instruction");

   if (reg_write !== 0)
     $error("Expected reg_write = 0 in store instruction");
   
   if (mem_write !== 1)
     $error("Expected mem_write = 1 in store instruction");

   if (alu_src !== 1)
     $error("Expected alu_src = 1 in store instruction");

   if (alu_ctrl !== 3'b010)
     $error("Expected alu_ctrl = 010 in store instruction");
   
endtask;

task check_arithmetic_logic_signals(input is_branch, mem_to_reg, 
				    reg_write, mem_read, mem_write,
				    alu_src);
   
   if (is_branch !== 0)
     $error("Expected is_branch = 0 in arithmetic/logic instruction");

   if (mem_to_reg !== 0)
     $error("Expected mem_to_reg = 0 in arithmetic/logic instruction");
   
   if (reg_write !== 1)
     $error("Expected reg_write = 1 in arithmetic/logic instruction");
   
   if (mem_write !== 0)
     $error("Expected mem_write = 0 in arithmetic/logic instruction");

   if (alu_src !== 0)
     $error("Expected alu_src = 0 in arithmetic/logic instruction");
   
endtask;



module tb_control();

   localparam period = 20;

   wire       is_branch, mem_to_reg, 
	      reg_write, mem_read, mem_write,
	      alu_src;
   wire [2:0] alu_ctrl;
   reg [31:0] instr;
	      
   control uut (.is_branch(is_branch),
		.mem_to_reg(mem_to_reg),
		.reg_write(reg_write),
		.mem_read(mem_read),
		.mem_write(mem_write),
		.alu_src(alu_src),
		.alu_ctrl(alu_ctrl),
		.instr(instr));
   
   initial begin

      // Instruction encodings below from here:
      // https://luplab.gitlab.io/rvcodecjs/#q=beq+x1,+x2,+40&abi=false&isa=AUTO   

      // 0x02208463 (beq x1, x2, 40)
      instr = 'h02208463;
      #period;
      check_branch_signals(is_branch, mem_to_reg, reg_write,
			  mem_read, mem_write, alu_src, alu_ctrl);

      // 0x02813083 (ld x1, 40(x2))
      instr = 'h02813083;
      #period;
      check_load_signals(is_branch, mem_to_reg, reg_write,
			 mem_read, mem_write, alu_src, alu_ctrl);

      // 0x02113423 (sd x1, 40(x2))
      instr = 'h02113423;
      #period;
      check_store_signals(is_branch, mem_to_reg, reg_write,
			 mem_read, mem_write, alu_src, alu_ctrl);

      // 0x003100b3 (add x1, x2, x3)
      instr = 'h003100b3;
      #period;
      check_arithmetic_logic_signals(is_branch, mem_to_reg, reg_write,
				     mem_read, mem_write, alu_src);
      if (alu_ctrl !== 3'b010)
	$error("Expecting alu_ctrl = 010 for add");

      // 0x403100b3 (sub x1, x2, x3)
      instr = 'h403100b3;
      #period;
      check_arithmetic_logic_signals(is_branch, mem_to_reg, reg_write,
				     mem_read, mem_write, alu_src);
      if (alu_ctrl !== 3'b110)
	$error("Expecting alu_ctrl = 110 for sub");

      
   end

endmodule
