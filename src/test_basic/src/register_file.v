module register_file(clk, resetn, ctrl_reg_num, ctrl_write, data_in, data_out);
 
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

   integer     n;
   always @(posedge clk) begin
      if (!resetn) begin
         for (n=0; n<32; n=n+1) begin
	   registers[n] <= 0;
	 end
      end else begin
	 if (ctrl_write)
	    registers[ctrl_reg_num] <= data_in;
      end
   end

   assign data_out = (~ctrl_write) ? registers[ctrl_reg_num] : 0;
   	 
`ifdef FORMAL
   property x0_is_zero;

endproperty
   x0_is_zero: cover property (x0_is_zero);
`endif
   
endmodule
