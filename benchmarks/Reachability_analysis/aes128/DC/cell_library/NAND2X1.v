`timescale 1ps / 1ps
module NAND2X1 (IN1,IN2,QN);

output  QN;
input   IN1,IN2;

nand #1 (QN,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_qn_hl=20,in1_hl_qn_lh=18,in2_lh_qn_hl=24,
 in2_hl_qn_lh=22;
 (        IN1 -=> QN) = (in1_hl_qn_lh,in1_lh_qn_hl);
 (        IN2 -=> QN) = (in2_hl_qn_lh,in2_lh_qn_hl);
endspecify
`endif

endmodule
