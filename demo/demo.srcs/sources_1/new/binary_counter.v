`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2023 09:32:02 PM
// Design Name: 
// Module Name: binary_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module binary_counter(
    input button_input,
    output reg[3:0] led_output
    );
    always @(posedge button_input) begin
        led_output <= led_output + 1;
    end
endmodule
