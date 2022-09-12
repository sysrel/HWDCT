`timescale 1ps / 1ps
module MUX21X1 (IN1,IN2,S,Q);

output  Q;
input   IN1,IN2,S;

s_mux21x1_  d1 (Q,S,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh_1=66,in1_hl_q_hl_1=59,in1_lh_q_lh_2=57,
 in1_hl_q_hl_2=59,in2_lh_q_lh_1=68,in2_lh_q_lh_2=57,in2_hl_q_hl_1=60,
 in2_hl_q_hl_2=60,s_lh_q_hl=86,s_lh_q_lh=68,s_hl_q_lh=88,s_hl_q_hl=63;
 if ((IN2==1'b0) && (S==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_1,in1_hl_q_hl_1);
 if ((IN2==1'b1) && (S==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_2,in1_hl_q_hl_2);
 if ((IN1==1'b0) && (S==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_1,in2_hl_q_hl_1);
 if ((IN1==1'b1) && (S==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_2,in2_hl_q_hl_2);
 if ((IN1==1'b1) && (IN2==1'b0))
 (        S   -=> Q) = (s_hl_q_lh,s_lh_q_hl);
 if ((IN1==1'b0) && (IN2==1'b1))
 (        S   +=> Q) = (s_lh_q_lh,s_hl_q_hl);
endspecify
`endif

endmodule
