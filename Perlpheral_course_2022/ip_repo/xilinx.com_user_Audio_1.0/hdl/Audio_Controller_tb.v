`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 23:35:19
// Design Name: 
// Module Name: Audio_Controller_tb
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
module Audio_Controller_tb();
    reg Clk, Reset;
    reg [31:0] Audio_Display;
    wire Audio;
    
    Audio_Controller_Int dut(.Clk(Clk),.Reset(Reset),.Audio_Display(Audio_Display),.Audio(Audio),.Audio_enable(Audio_enable));
    
    initial Clk = 0;
    always #5 Clk = ~Clk;
    
    always begin
    #5 Reset = 0;
    #15 Reset = 1;
    #15 Audio_Display <= 1; 
    #100 Audio_Display <= 0;   
    #100 Reset = 0;
    #15 Reset = 1;
    end  
    
endmodule
