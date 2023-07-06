module processor(input clk, rstn);
   
   wire [4:0] 		    rd, rs1, rs2;
   wire [63:0] 		    rs1_data, rs2_data, rd_data;

   wire [63:0] 		    pc;

   wire 		    is_branch, mem_to_reg, 
			    reg_write, mem_read, mem_write,
			    alu_src, main_alu_zero;
   
   wire [2:0] 		    alu_ctrl;
   wire [31:0] 		    instr;   

   wire [63:0] 		    imm_branch, imm_mem;

   wire [63:0] 		    main_alu_b;
   
   assign rd = instr[11:7];
   assign rs1 = instr[19:15];
   assign rs2 = instr[24:20];
   
   control control_0
     (.is_branch(is_branch),
      .mem_to_reg(mem_to_reg),
      .reg_write(reg_write),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .alu_src(alu_src),
      .alu_ctrl(alu_ctrl),
      .instr(instr));

   assign pc_src = (is_branch && main_alu_zero);
   
   program_counter #(.xlen(64)) program_counter_0
    (.pc(pc),
     .imm_branch(imm_branch),
     .pc_src(pc_src),
     .clk(clk),
     .rstn(rstn));

   instruction_memory instruction_memory_0
     (.instr(instr),
      .pc(pc));
   
   register_file register_file_0
     (.rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .rs1(rs1), .rs2(rs2), .rd(rd),
      .rd_data(rd_data),
      .write_en(reg_write),
      .clk(clk),
      .rstn(rstn));

   immediate_gen immediate_gen_0
     (.imm_mem(imm_mem),
      .imm_branch(imm_branch),
      .instr(instr));

   assign main_alu_b = alu_src ? imm_mem : rs2_data;
   		       
   alu #(.xlen(64)) main_alu
     (.result(main_alu_result),
      .zero(main_alu_zero),
      .a(rs1_data),
      .b(main_alu_b),
      .alu_ctrl(alu_ctrl));

   data_memory data_memory_0
     (.read_data(memory_read_data),
      .address(main_alu_result),
      .write_data(rs2_data),
      .read_en(mem_read),
      .write_en(mem_write),
      .clk(clk),
      .rstn(rstn));

endmodule
