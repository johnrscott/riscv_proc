module alu
  #(parameter xlen = 64)
   (output [xlen-1:0] result,
    output 	     zero,
    input [xlen-1:0] a, b,
    input [2:0]      alu_ctrl);
   
   wire [xlen-1:0]   sum;
   wire 	     carry_out, carry_in;

   wire 	     b_or_not_b, sign_bit;

   // Zero output is set if result is all-zero
   assign zero = ~&result;
   
   // Negate b and set carry_in for subtraction
   assign b_or_not_b = alu_ctrl[2] ? b : ~b;
   assign carry_in = alu_ctrl[2];

   // Adder performs addition and subtraction
   ripple_carry_adder #(.xlen(xlen)) adder
     (sum, carry_out, a, b_or_not_b, carry_in);

   // Sign bit used as value for set
   assign sign_bit = sum[xlen-1];
   
   // Choose source for result based on alu_ctrl[1:0]
   always @(*) begin
      case (alu_ctrl[1:0])
	2'b00: result = a & b_or_not_b;
	2'b01: result = a | b_or_not_b;
	2'b10: result = sum;
	2'b11: result = sign_bit; 
      endcase	
   end
   
endmodule
    
