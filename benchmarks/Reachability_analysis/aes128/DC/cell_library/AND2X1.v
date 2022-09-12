`timescale 1ps / 1ps
module AND2X1 (IN1,IN2,Q);

output  Q;
input   IN1,IN2;

and #1 (Q,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh=52,in1_hl_q_hl=50,in2_lh_q_lh=59,in2_hl_q_hl=56;
 (        IN1 +=> Q) = (in1_lh_q_lh,in1_hl_q_hl);
 (        IN2 +=> Q) = (in2_lh_q_lh,in2_hl_q_hl);
endspecify
`endif

endmodule
