module data_memory 
   (output [63:0] read_data,
    input [63:0] address, write_data,
    input write_en, read_en, clk, rstn);

   // Arranged as a list of bytes
   reg [7:0] dm[9:0];

   wire [63:0] byte_addresses[3:0];
   wire [63:0] read_data_internal;
   
   genvar      m;
   integer     n;
   
   // Compute addresses of read data
   generate
      for (m=0; m<8; m=m+1)
	alu #(.xlen(64)) alu_m
	     (.result(byte_addresses[m]),
	      .a(address),
	      .b(m),
	      .alu_ctrl(3'b010));   
   endgenerate

   // Read the data at computed byte addresses
   // generate
   for (m=0; m<8; m=m+1)
     assign read_data_internal[(8*m)+:8] = dm[byte_addresses[m]];
      
   assign read_data = read_en ? read_data_internal : 0;

   always @(posedge clk) begin
      if (!rstn)
	for (n=0; n<1024; n=n+1)
	  dm[n] <= 0;
      else if (write_en)
	for (n=0; n<8; n=n+1)
	  dm[byte_addresses[n]] <= write_data[(8*n)+:8];
   end
   
endmodule
