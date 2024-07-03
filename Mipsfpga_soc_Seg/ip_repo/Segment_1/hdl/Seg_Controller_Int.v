`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 19:36:13
// Design Name: 
// Module Name: Seg_Controller_Int
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
module Seg_Controller_Int(
    input Clk,
    input Reset,
    input [31:0] Seg_Display,
    output reg [7:0]AN,
    output reg [6:0] Digits_Bits
    );
    
    always @(posedge Clk)
        if (!Reset)begin
            AN <= 8'b1111_1111;
            Digits_Bits <= 7'b1000000;
            end
        else begin
        case (Seg_Display[2:0])
            3'b000: AN<=8'b1111_1110;
            3'b001: AN<=8'b1111_1101;
            3'b010: AN<=8'b1111_1011;
            3'b011: AN<=8'b1111_0111;
            3'b100: AN<=8'b1110_1111;
            3'b101: AN<=8'b1101_1111;
            3'b110: AN<=8'b1011_1111;
            3'b111: AN<=8'b0111_1111;
        endcase
        case (Seg_Display[6:3])
        	   4'b0000 : Digits_Bits[6:0] = 7'b0000001;
               4'b0001 : Digits_Bits[6:0] = 7'b1001111;
               4'b0010 : Digits_Bits[6:0] = 7'b0010010;
               4'b0011 : Digits_Bits[6:0] = 7'b0000110;
               4'b0100 : Digits_Bits[6:0] = 7'b1001100;
               4'b0101 : Digits_Bits[6:0] = 7'b0100100;
               4'b0110 : Digits_Bits[6:0] = 7'b0100000;
               4'b0111 : Digits_Bits[6:0] = 7'b0001111;
               4'b1000 : Digits_Bits[6:0] = 7'b0000000;
               4'b1001 : Digits_Bits[6:0] = 7'b0000100;
               4'b1010 : Digits_Bits[6:0] = 7'b0001000;
               4'b1011 : Digits_Bits[6:0] = 7'b1100000;
               4'b1100 : Digits_Bits[6:0] = 7'b0110001;
               4'b1101 : Digits_Bits[6:0] = 7'b1000010;
               4'b1110 : Digits_Bits[6:0] = 7'b0110000;
               4'b1111 : Digits_Bits[6:0] = 7'b0111000;
        endcase
        end
endmodule
