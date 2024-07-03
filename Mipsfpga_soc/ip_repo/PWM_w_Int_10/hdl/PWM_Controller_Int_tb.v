`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 20:04:17
// Design Name: 
// Module Name: PWM_Controller_Int_tb
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
module PWM_Controller_Int_tb();
    parameter integer period = 20;

    reg Clk, Reset;
    reg [31:0] DutyCycle;
    
    wire Interruput;
    wire [1:0] PWM_out;
    wire [period-1:0] count;
    
    PWM_Controller_Int #(period) dut (.Clk(Clk),.DutyCycle(DutyCycle),.Reset(Reset),.PWM_out(PWM_out),.Interruput(Interruput),.count(count));
   
    initial Clk = 0;
    always
        #5 Clk = ~Clk;
    
    initial DutyCycle = 900000;
        
    always begin
        #5 Reset = 0;
        #15 Reset = 1;
        
        #105 Reset = 0;
        DutyCycle = 990999;
        #15 Reset = 1;
    end
    
endmodule
