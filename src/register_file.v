module register_file(clk, ctrl_reg_num, ctrl_write, data_in, data_out);

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

   reg [63:0]  registers[30:0];
    
   always @(posedge clk) begin
      if (ctrl_write == 1)
	if (ctrl_reg_num != 0)
	  registers[ctrl_reg_num] <= data_in;	
      else 
	if (ctrl_reg_num == 0)
	  data_out <= 0;
	else
	  data_out <= registers[ctrl_reg_num];
   end
      
endmodule
