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
`define L1 262 //低音 1
`define L2 294 //低音 2
`define L3 330 //低音 3
`define L4 349 //低音 4
`define L5 392 //低音 5
`define L6 440 //低音 6
`define L7 494 //低音 7
`define M1 523 //中音 1 
`define M2 587 //中音 2 
`define M3 659 //中音 3 
`define M4 699 //中音 4 
`define M5 784 //中音 5 
`define M6 880 //中音 6 
`define M7 988 //中音 7 
`define H1 1046 //高音 1 
`define H2 1170 //高音 2 
`define H3 1319 //高音 3 
`define H4 1397 //高音 4 
`define H5 1568 //高音 5 
`define H6 1760 //高音 6 
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
        state <= 82;
    else if(state_cnt_done)begin
    if(state<82)
        state<=state+1; 
    else
        state<=0;
    end
    else
    state<=state;
    
    //春日影
    always@(*)begin
    case(state)
        0 :cnt_top<=`H3;
        1 :cnt_top<=`H2;
        2 :cnt_top<=`H1;
        3 :cnt_top<= 0;
        4 :cnt_top<=`H2;
        5 :cnt_top<=`H3;
        6 :cnt_top<= 0;
        7 :cnt_top<=`H4;
        8 :cnt_top<=`H3;
        9 :cnt_top<=`H2;
        10 :cnt_top<= 0;
        11 :cnt_top<=`H3;
        12 :cnt_top<=`H2;
        13 :cnt_top<=`H1;
        14 :cnt_top<= 0;
        15 :cnt_top<=`H2;
        16 :cnt_top<=`H3;
        17 :cnt_top<= 0;
        18 :cnt_top<=`H4;
        19 :cnt_top<=`H3;
        20 :cnt_top<=`H2;
        21 :cnt_top<= 0;
        22 :cnt_top<=`M1;
        23 :cnt_top<=`M2;
        24 :cnt_top<=`M3;
        25 :cnt_top<=`M3;
        26 :cnt_top<=`M2;
        27 :cnt_top<=`M4;
        28 :cnt_top<=`M3;
        29 :cnt_top<=`M2;
        30 :cnt_top<= 0;
        31 :cnt_top<=`M2;
        32 :cnt_top<=`M2;
        33 :cnt_top<=`M1;
        34 :cnt_top<=`M1;
        35 :cnt_top<=`M4;
        36 :cnt_top<=`M3;
        37 :cnt_top<=`M2;
        38 :cnt_top<= 0;
        39 :cnt_top<=`M2;
        40 :cnt_top<=`M1;
        41 :cnt_top<=`M2;
        42 :cnt_top<=`M3;
        43 :cnt_top<= 0;
        44 :cnt_top<=`M3;
        45 :cnt_top<=`M5;
        46 :cnt_top<=`H1;
        47 :cnt_top<=`M7;
        48 :cnt_top<=`H1;
        49 :cnt_top<=`M7;
        50 :cnt_top<=`M6;
        51 :cnt_top<=`M5;
        52 :cnt_top<= 0;
        53 :cnt_top<=`M5;
        54 :cnt_top<=`M2;
        55 :cnt_top<=`M4;
        56 :cnt_top<=`M4;
        57 :cnt_top<=`M3;
        58 :cnt_top<=`M3;
        59 :cnt_top<= 0;
        60 :cnt_top<=`L5;
        61 :cnt_top<=`M4;
        62 :cnt_top<=`M3;
        63 :cnt_top<=`M2;
        64 :cnt_top<=`M3;
        65 :cnt_top<=`M5;
        66 :cnt_top<=`M1;
        67 :cnt_top<= 0;
        68 :cnt_top<=`M1;
        69 :cnt_top<=`M2;
        70 :cnt_top<=`M1;
        71 :cnt_top<=`M1;
        72 :cnt_top<= 0;
        73 :cnt_top<=`M1;
        74 :cnt_top<=`M5;
        75 :cnt_top<=`M1;
        76 :cnt_top<= 0;
        77 :cnt_top<=`M4;
        78 :cnt_top<=`M3;
        79 :cnt_top<=`M2;
        80 :cnt_top<=`M1;
        81 :cnt_top<=`M1;
        82 :cnt_top<= 0;
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
