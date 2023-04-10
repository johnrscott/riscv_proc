module alu_1bit (alu_ctrl, a, b, alu_out, zero);
   input [3:0] alu_ctrl;
   input [63:0]	a, b;
   output reg [63:0] alu_out;
   output	     zero;
   
   assign zero = (alu_ctrl == 0);
   always @(alu_ctrl, a, b) begin
      case (alu_ctrl)
	0: alu_out <= a & b;
	1: alu_out <= a | b;
	2: alu_out <= a + b;
	6: alu_out <= a - b;
	7: alu_out <= ~(a | b);
	default: alu_out <= 0;
      endcase
   end
endmodule
