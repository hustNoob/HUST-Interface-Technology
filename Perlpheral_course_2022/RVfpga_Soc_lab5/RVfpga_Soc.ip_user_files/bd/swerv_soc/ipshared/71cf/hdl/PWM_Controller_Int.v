`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 19:57:42
// Design Name: 
// Module Name: PWM_Controller_Int
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 16:16:09
// Design Name: 
// Module Name: PWM_Controller_Int
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
module PWM_Controller_Int #(
    parameter integer period = 20)
(
    input Clk,
    input [31:0] DutyCycle, 
    input Reset,
    output reg [1:0] PWM_out,
	output reg Interruput,
	output reg [period-1:0] count
 );
    
    // Sets PWM Period.  Must be calculated vs. input clk period.
    // For example, setting this to 20 will divide the input clock by 2^20, or 1 Million.
    // So a 50 MHz input clock will be divided by 1e6, thus this will have a period of 1/50
    always @(posedge Clk)
        if (!Reset)
            count <= 0;
        else
            count <= count + 1; 
    
    always @(posedge Clk)
        if (count < DutyCycle)
            PWM_out <= 2'b01; 
        else
            PWM_out <= 2'b10;
		   
	always @(posedge Clk)
        if (!Reset)
            Interruput <= 0;
        else if (DutyCycle > 990000)
            Interruput <= 1;
        else
            Interruput <= 0; 
        
endmodule
