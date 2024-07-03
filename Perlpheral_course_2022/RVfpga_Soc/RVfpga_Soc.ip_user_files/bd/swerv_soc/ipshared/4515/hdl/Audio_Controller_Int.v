`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 23:11:48
// Design Name: 
// Module Name: Audio_Controller_Int
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
`define H7 1976 //高音 7
module Audio_Controller_Int(
    input Clk,
    input Reset,
    input [31:0] Audio_Display,
    output reg Audio,
    output reg Audio_enable
    );
//250ms 跳转一次,需要计数 12500000
localparam state_top=24'd12500000-1;
//放大器工作与否
always@(*) begin
    Audio_enable = Audio_Display[0];
end
reg [23:0] state_cnt;
always@(posedge Clk or negedge Reset)
    if(!Reset)
        state_cnt<=0;
    else if(Audio_Display[0] == 0)
        state_cnt<=0;
    else if(state_cnt<state_top)
        state_cnt<=state_cnt+1;
    else
        state_cnt<=0;
//状态跳转标志信号
wire state_cnt_done=(state_cnt==state_top)?1:0;
reg [6:0] state;
reg [20:0] cnt_top;
always@(posedge Clk or negedge Reset)
    if(!Reset)
        state<=0;
    else if(Audio_Display[0] == 0)
        state <= 1;
    else if(state_cnt_done)begin
    if(state<1)
        state<=state+1; 
    else
        state<=0;
    end
    else
    state<=state;
    
    always@(*)begin
    case(state)
        0 :cnt_top<=`H7;
        1 :cnt_top<= 0;
        default:;
    endcase
    end
    
    //每个音符的演奏          
    reg [26:0] cnt;
    always@(posedge Clk or negedge Reset)
    if(!Reset)
        cnt<=0;
    else if(Audio_Display[0] == 0)
        cnt<=0;
    else if(cnt<100_000_000/cnt_top-1)
        cnt<=cnt+1;
    else
    cnt<=0;
    
    always@(posedge Clk or negedge Reset)
    if(!Reset)
        Audio<=0;
    else if(Audio_Display[0] == 0)
        Audio<=0;
    else
    Audio<=(cnt<cnt_top/2)?1:0;
endmodule
