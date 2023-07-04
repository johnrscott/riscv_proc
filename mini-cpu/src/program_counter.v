module program_counter 
  #(parameter xlen = 4)
   (output reg [xlen-1:0] pc,
    input [63:0] imm_branch,
    input 	 pc_src, clk, rstn);  

   wire [63:0] 	 pc_plus_4, pc_plus_imm_branch;

   // Adder for normal pc increment
   alu #(.xlen(xlen)) alu_increment
     (.result(pc_plus_4),
      .a(pc), .b(4),
      .alu_ctrl(2));

   // Adder for pc branch
   alu #(.xlen(xlen)) alu_branch
     (.result(pc_plus_imm_branch),
      .a(pc), .b(imm_branch),
      .alu_ctrl(2));
   
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
