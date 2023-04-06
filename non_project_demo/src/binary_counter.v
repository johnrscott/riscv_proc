`timescale 1ns / 1ps

module binary_counter(input 	       button_input,
		      output reg [3:0] led_output);
   always @(posedge button_input) begin
      led_output <= led_output + 1;
   end
endmodule
