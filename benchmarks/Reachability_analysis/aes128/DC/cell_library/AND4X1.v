`timescale 1ps / 1ps
module AND4X1 (IN1,IN2,IN3,IN4,Q);

output  Q;
input   IN1,IN2,IN3,IN4;

and #1 (Q,IN4,IN3,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh=76,in1_hl_q_hl=76,in2_lh_q_lh=87,in2_hl_q_hl=85,
 in3_lh_q_lh=99,in3_hl_q_hl=94,in4_lh_q_lh=102,in4_hl_q_hl=100;
 (        IN1 +=> Q) = (in1_lh_q_lh,in1_hl_q_hl);
 (        IN2 +=> Q) = (in2_lh_q_lh,in2_hl_q_hl);
 (        IN3 +=> Q) = (in3_lh_q_lh,in3_hl_q_hl);
 (        IN4 +=> Q) = (in4_lh_q_lh,in4_hl_q_hl);
endspecify
`endif

endmodule
