`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 19:38:04
// Design Name: 
// Module Name: Seg_Controller_tb
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
module Seg_Controller_tb();
    reg Clk, Reset;
    reg [31:0] Seg_Display;
    wire [7:0]AN;
    wire [6:0] Digits_Bits;
    
    Seg_Controller_Int dut (.Clk(Clk),.Seg_Display(Seg_Display),.Reset(Reset),.AN(AN),.Digits_Bits(Digits_Bits));
    
    initial Clk = 0;
    always
        #5 Clk = ~Clk;
    initial Seg_Display = 7'b0110010;
    
    always begin
    #5 Reset = 0;
    #15 Reset = 1;
    #105 Seg_Display <= 0;    
    #15 Reset = 0;
    #15 Reset = 1;
    end    

endmodule
