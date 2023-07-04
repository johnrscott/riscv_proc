module program_counter 
  #(parameter xlen = 4)
   (output reg [xlen-1:0] pc,
    input [xlen-1:0] imm_branch,
    input 	     pc_src, clk, rstn);  
   
   wire [xlen-1:0]   constant_4, pc_plus_4, pc_plus_imm_branch;
   
   assign constant_4 = 4;
   
   // Adder for normal pc increment
   alu #(.xlen(xlen)) alu_increment
     (.result(pc_plus_4),
      .a(pc), .b(constant_4),
      .alu_ctrl(3'b010));

   // Adder for pc branch
   alu #(.xlen(xlen)) alu_branch
     (.result(pc_plus_imm_branch),
      .a(pc), .b(imm_branch),
      .alu_ctrl(3'b010));
   
   always @(posedge clk) begin
      if (!rstn)
	pc <= 0;
      else begin
	 if (pc_src)
	   pc <= pc_plus_imm_branch;	  
	 else
	   pc <= pc_plus_4;
      end
   end
   
endmodule
