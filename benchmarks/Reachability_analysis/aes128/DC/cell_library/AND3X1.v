`timescale 1ps / 1ps
module AND3X1 (IN1,IN2,IN3,Q);

output  Q;
input   IN1,IN2,IN3;

and #1 (Q,IN3,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh=74,in1_hl_q_hl=71,in2_lh_q_lh=83,in2_hl_q_hl=78,
 in3_lh_q_lh=90,in3_hl_q_hl=86;
 (        IN1 +=> Q) = (in1_lh_q_lh,in1_hl_q_hl);
 (        IN2 +=> Q) = (in2_lh_q_lh,in2_hl_q_hl);
 (        IN3 +=> Q) = (in3_lh_q_lh,in3_hl_q_hl);
endspecify
`endif

endmodule
