module register_file #(parameter xlen = 64)
   (output [xlen-1:0] rs1_data, rs2_data,
    input [4:0]      rs1, rs2, rd,
    input [xlen-1:0] rd_data,
    input 	     write_en, clk, rstn);

   // registers[0] is always zero
   reg [xlen-1:0]    registers[32];
   
   assign rs1_data = registers[rs1];
   assign rs2_data = registers[rs2];

   integer 	     n;
   
   always @(posedge clk) begin
      if (!rstn)
	for (n=0; n<32; n=n+1)
	  registers[n] <= 0;
      else if (write_en && (rd != 0))
	registers[rd] <= rd_data;	
   end
   
endmodule
