module register_file(clk, resetn, ctrl_reg_num, ctrl_write, data_in, data_out);

   // Asynchronous reset 
   input resetn;
   
   // Data written and read from the registers
   input [63:0] data_in;
   output [63:0] data_out;

   // If high, data is written from data_in to the register
   // index ctrl_reg_num. Otherwise that register is read and
   // placed on data_out
   input 	 ctrl_write;

   // Which register to read or write
   input [4:0] ctrl_reg_num;

   // Data is moved to or read from registers on the rising edge
   // of the clock
   input       clk;

   reg [63:0]  registers[31:0];
    
   always @(posedge clk, negedge resetn)
     if (!resetn) begin
	int n;
        for (n=0; n<32; n=n+1)
	 registers[n] <= 0;
     end
     else if (ctrl_write == 1)
       registers[ctrl_reg_num] <= data_in;	
     else 
       if (ctrl_reg_num == 0)
	 // x0 is tied to zero
	 data_out <= 0;
       else
	 data_out <= registers[ctrl_reg_num];
   
`ifdef FORMAL
   // TODO 
`endif
   
endmodule
