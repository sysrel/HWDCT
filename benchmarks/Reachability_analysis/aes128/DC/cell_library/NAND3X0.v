`timescale 1ps / 1ps
module NAND3X0 (IN1,IN2,IN3,QN);

output  QN;
input   IN1,IN2,IN3;

nand #1 (QN,IN3,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_qn_hl=20,in1_hl_qn_lh=21,in2_lh_qn_hl=28,
 in2_hl_qn_lh=27,in3_lh_qn_hl=29,in3_hl_qn_lh=32;
 (        IN1 -=> QN) = (in1_hl_qn_lh,in1_lh_qn_hl);
 (        IN2 -=> QN) = (in2_hl_qn_lh,in2_lh_qn_hl);
 (        IN3 -=> QN) = (in3_hl_qn_lh,in3_lh_qn_hl);
endspecify
`endif

endmodule
