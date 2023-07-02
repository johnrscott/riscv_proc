module program_counter (output reg [63:0] pc,
			input [63:0] imm_branch,
			input 	     pc_src, clk, rstn);  

   // Add the two ALUs for adding 4 and imm_branch
   // to the program counter
   
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
