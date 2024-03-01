// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Nov 24 11:06:07 2023
// Host        : ECEB-4022-10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {u:/ECE 437 Final Project/ECE 437 Final
//               Project.gen/sources_1/ip/fifo_generator_0/fifo_generator_0_stub.v}
// Design      : fifo_generator_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a75tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_7,Vivado 2022.2" *)
module fifo_generator_0(wr_clk, wr_rst, rd_clk, rd_rst, din, wr_en, rd_en, 
  dout, full, empty, prog_full)
/* synthesis syn_black_box black_box_pad_pin="wr_clk,wr_rst,rd_clk,rd_rst,din[7:0],wr_en,rd_en,dout[31:0],full,empty,prog_full" */;
  input wr_clk;
  input wr_rst;
  input rd_clk;
  input rd_rst;
  input [7:0]din;
  input wr_en;
  input rd_en;
  output [31:0]dout;
  output full;
  output empty;
  output prog_full;
endmodule
