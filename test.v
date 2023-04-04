/// A simple counter
module counter (input up_down,
		clock
		resetn, 
		output reg [2:0] out);
   always @(posedge clock)
      if (!resetn)
	 out <= 0;
      else begin
	 if (up_down)
	   out <= out + 1;
	 else
	   out <= out - 1;
      end
endmodule

