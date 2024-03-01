// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Nov 24 12:54:49 2023
// Host        : ECEB-4022-10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {u:/ECE 437 Final Project/ECE 437 Final
//               Project.gen/sources_1/ip/ila_0/ila_0_stub.v}
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a75tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2022.2" *)
module ila_0(clk, probe0, probe1, probe2, probe3)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[7:0],probe1[0:0],probe2[1:0],probe3[0:0]" */;
  input clk;
  input [7:0]probe0;
  input [0:0]probe1;
  input [1:0]probe2;
  input [0:0]probe3;
endmodule
