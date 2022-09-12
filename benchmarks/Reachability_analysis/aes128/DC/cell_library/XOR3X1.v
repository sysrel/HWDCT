`timescale 1ps / 1ps
module XOR3X1 (IN1,IN2,IN3,Q);

output  Q;
input   IN1,IN2,IN3;

xor #1 (Q,IN3,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh_1=206,in1_hl_q_hl_1=205,in1_lh_q_hl_1=163,
 in1_hl_q_lh_1=171,in2_lh_q_lh_1=210,in2_lh_q_hl_1=177,in2_hl_q_hl_1=208,
 in2_hl_q_lh_1=187,in1_lh_q_hl_2=169,in1_hl_q_lh_2=170,in1_lh_q_lh_2=128,
 in1_hl_q_hl_2=134,in2_lh_q_hl_2=173,in2_lh_q_lh_2=142,in2_hl_q_lh_2=174,
 in2_hl_q_hl_2=149,in3_lh_q_lh_1=60,in3_lh_q_hl_1=79,in3_lh_q_hl_2=79,
 in3_lh_q_lh_2=60,in3_hl_q_hl_1=67,in3_hl_q_lh_1=78,in3_hl_q_lh_2=78,
 in3_hl_q_hl_2=67;
 if ((IN2==1'b0) && (IN3==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_1,in1_hl_q_hl_1);
 if ((IN2==1'b1) && (IN3==1'b0))
 (        IN1 -=> Q) = (in1_hl_q_lh_1,in1_lh_q_hl_1);
 if ((IN1==1'b0) && (IN3==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh_1,in2_hl_q_hl_1);
 if ((IN1==1'b1) && (IN3==1'b0))
 (        IN2 -=> Q) = (in2_hl_q_lh_1,in2_lh_q_hl_1);
 if ((IN2==1'b0) && (IN3==1'b1))
 (        IN1 -=> Q) = (in1_hl_q_lh_2,in1_lh_q_hl_2);
 if ((IN2==1'b1) && (IN3==1'b1))
 (        IN1 +=> Q) = (in1_lh_q_lh_2,in1_hl_q_hl_2);
 if ((IN1==1'b0) && (IN3==1'b1))
 (        IN2 -=> Q) = (in2_hl_q_lh_2,in2_lh_q_hl_2);
 if ((IN1==1'b1) && (IN3==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_2,in2_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_1,in3_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0))
 (        IN3 -=> Q) = (in3_hl_q_lh_1,in3_lh_q_hl_1);
 if ((IN1==1'b0) && (IN2==1'b1))
 (        IN3 -=> Q) = (in3_hl_q_lh_2,in3_lh_q_hl_2);
 if ((IN1==1'b1) && (IN2==1'b1))
 (        IN3 +=> Q) = (in3_lh_q_lh_2,in3_hl_q_hl_2);
endspecify
`endif

endmodule
