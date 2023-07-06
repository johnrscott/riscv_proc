module processor(output main_alu_zero,
		 input clk, rstn);
   
   wire [4:0] 		    rd, rs1, rs2;
   wire [63:0] 		    rs1_data, rs2_data, rd_data,
			    mem_read_data;

   wire [63:0] 		    pc;

   wire 		    is_branch, mem_to_reg, 
			    reg_write, mem_read, mem_write,
			    alu_src;
   
   wire [2:0] 		    alu_ctrl;
   wire [31:0] 		    instr;   

   wire [63:0] 		    imm_branch, imm_mem,
			    main_alu_b, main_alu_result;
   
   control control_0
     (.is_branch(is_branch),
      .mem_to_reg(mem_to_reg),
      .reg_write(reg_write),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .alu_src(alu_src),
      .alu_ctrl(alu_ctrl),
      .instr(instr));

   // The program counter increments by 4 on each
   // rising clock edge, unless the instruction beq
   // is a branch and the zero line of the main_alu
   // is asserted (for branch taken)
   assign pc_src = (is_branch && main_alu_zero);
   program_counter #(.xlen(64)) program_counter_0
    (.pc(pc),
     .imm_branch(imm_branch),
     .pc_src(pc_src),
     .clk(clk),
     .rstn(rstn));

   // Instruction memory is read only, and instruction
   // output acts like a combinational function of the
   // program counter input
   instruction_memory instruction_memory_0
     (.instr(instr),
      .pc(pc));

   // The register file read addresses rs1 and
   // rs2 are hardwired to their (fixed) positions
   // in the instruction format. Data to be written
   // is either from memory (for loads) or from the
   // main ALU output (for arithmetic/logic)
   assign rd = instr[11:7];
   assign rs1 = instr[19:15];
   assign rs2 = instr[24:20];
   assign rd_data = mem_to_reg ? mem_read_data : main_alu_result;
   register_file register_file_0
     (.rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .rs1(rs1), .rs2(rs2), .rd(rd),
      .rd_data(rd_data),
      .write_en(reg_write),
      .clk(clk),
      .rstn(rstn));

   // For S-type and SB-type instructions, the
   // immediate is extracted from the instruction,
   // sign extended, and used as either a memory
   // offset (imm_mem) for loads/stores, or 
   // left-shifted and used as a pc-relative 
   // branch offset (imm_branch)
   immediate_gen immediate_gen_0
     (.imm_mem(imm_mem),
      .imm_branch(imm_branch),
      .instr(instr));

   // Input a to the main ALU is always rs1. The
   // second input is either rs2 (for arithmetic
   // and logic) or the memory offset immediate (for
   // loads and stores)
   assign main_alu_b = alu_src ? imm_mem : rs2_data;
   alu #(.xlen(64)) main_alu
     (.result(main_alu_result),
      .zero(main_alu_zero),
      .a(rs1_data),
      .b(main_alu_b),
      .alu_ctrl(alu_ctrl));

   // Data memory is addressed by the output of the
   // main ALU, with write data from the register
   // file. Reads and writes are enabled by control
   // signals. 
   data_memory data_memory_0
     (.read_data(mem_read_data),
      .address(main_alu_result),
      .write_data(rs2_data),
      .read_en(mem_read),
      .write_en(mem_write),
      .clk(clk),
      .rstn(rstn));

endmodule
