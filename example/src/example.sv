module example(input clk, output led);

   reg [31:0] count;
   reg led;

   initial begin
      count <= 0;
      led <= 0;
   end
   
   always @(posedge clk) begin
      if count < 20
	count <= count + 1;
      else begin
	 count <= 0;
	 led <= ~led;
      end
   end
endmodule
