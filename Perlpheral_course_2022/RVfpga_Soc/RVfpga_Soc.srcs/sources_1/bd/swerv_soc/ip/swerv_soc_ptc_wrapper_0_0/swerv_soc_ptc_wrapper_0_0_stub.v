// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat May 11 06:50:02 2024
// Host        : vivadopc running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/workspace/Perlpheral_course_2022/RVfpga_Soc_lab6/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_ptc_wrapper_0_0/swerv_soc_ptc_wrapper_0_0_stub.v
// Design      : swerv_soc_ptc_wrapper_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ptc_wrapper,Vivado 2019.2" *)
module swerv_soc_ptc_wrapper_0_0(wb_clk_i, wb_rst_i, wb_cyc_i, wb_adr_i, wb_dat_i, 
  wb_sel_i, wb_we_i, wb_stb_i, wb_dat_o, wb_ack_o, wb_err_o, wb_inta_o, pwm_pad_o)
/* synthesis syn_black_box black_box_pad_pin="wb_clk_i,wb_rst_i,wb_cyc_i,wb_adr_i[31:0],wb_dat_i[31:0],wb_sel_i[3:0],wb_we_i,wb_stb_i,wb_dat_o[31:0],wb_ack_o,wb_err_o,wb_inta_o,pwm_pad_o" */;
  input wb_clk_i;
  input wb_rst_i;
  input wb_cyc_i;
  input [31:0]wb_adr_i;
  input [31:0]wb_dat_i;
  input [3:0]wb_sel_i;
  input wb_we_i;
  input wb_stb_i;
  output [31:0]wb_dat_o;
  output wb_ack_o;
  output wb_err_o;
  output wb_inta_o;
  output pwm_pad_o;
endmodule
