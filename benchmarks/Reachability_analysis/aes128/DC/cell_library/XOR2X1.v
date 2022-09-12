`timescale 1ps / 1ps
module XOR2X1 (IN1,IN2,Q);

output  Q;
input   IN1,IN2;

xor #1 (Q,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh=64,in1_hl_q_hl=65,in1_lh_q_hl=94,in1_hl_q_lh=108,
 in2_lh_q_lh=77,in2_lh_q_hl=103,in2_hl_q_hl=80,in2_hl_q_lh=111;
 if ((IN2==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh,in1_hl_q_hl);
 if ((IN2==1'b1))
 (        IN1 -=> Q) = (in1_hl_q_lh,in1_lh_q_hl);
 if ((IN1==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh,in2_hl_q_hl);
 if ((IN1==1'b1))
 (        IN2 -=> Q) = (in2_hl_q_lh,in2_lh_q_hl);
endspecify
`endif

endmodule
