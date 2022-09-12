`timescale 1ps / 1ps
module NAND4X0 (IN1,IN2,IN3,IN4,QN);

output  QN;
input   IN1,IN2,IN3,IN4;

nand #1 (QN,IN4,IN3,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_qn_hl=22,in1_hl_qn_lh=24,in2_lh_qn_hl=30,
 in2_hl_qn_lh=32,in3_lh_qn_hl=37,in3_hl_qn_lh=39,in4_lh_qn_hl=40,
 in4_hl_qn_lh=43;
 (        IN1 -=> QN) = (in1_hl_qn_lh,in1_lh_qn_hl);
 (        IN2 -=> QN) = (in2_hl_qn_lh,in2_lh_qn_hl);
 (        IN3 -=> QN) = (in3_hl_qn_lh,in3_lh_qn_hl);
 (        IN4 -=> QN) = (in4_hl_qn_lh,in4_lh_qn_hl);
endspecify
`endif

endmodule
