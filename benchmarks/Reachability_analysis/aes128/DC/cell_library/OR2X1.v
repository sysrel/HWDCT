`timescale 1ps / 1ps
module OR2X1 (IN1,IN2,Q);

output  Q;
input   IN1,IN2;

or #1 (Q,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh=47,in1_hl_q_hl=49,in2_lh_q_lh=59,in2_hl_q_hl=59;
 (        IN1 +=> Q) = (in1_lh_q_lh,in1_hl_q_hl);
 (        IN2 +=> Q) = (in2_lh_q_lh,in2_hl_q_hl);
endspecify
`endif

endmodule
