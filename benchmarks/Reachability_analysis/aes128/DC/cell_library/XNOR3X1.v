`timescale 1ps / 1ps
module XNOR3X1 (IN1,IN2,IN3,Q);

output  Q;
input   IN1,IN2,IN3;

xnor #1 (Q,IN3,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_hl_1=169,in1_hl_q_lh_1=174,in1_lh_q_lh_1=129,
 in1_hl_q_hl_1=133,in2_lh_q_hl_1=173,in2_lh_q_lh_1=142,in2_hl_q_lh_1=175,
 in2_hl_q_hl_1=149,in1_lh_q_lh_2=208,in1_hl_q_hl_2=210,in1_lh_q_hl_2=165,
 in1_hl_q_lh_2=171,in2_lh_q_lh_2=211,in2_lh_q_hl_2=179,in2_hl_q_hl_2=210,
 in2_hl_q_lh_2=188,in3_lh_q_hl_1=83,in3_lh_q_lh_1=64,in3_lh_q_lh_2=64,
 in3_lh_q_hl_2=83,in3_hl_q_lh_1=78,in3_hl_q_hl_1=62,in3_hl_q_hl_2=62,
 in3_hl_q_lh_2=78;
 if ((IN2==1'b0) && (IN3==1'b0))
 (        IN1 -=> Q) = (in1_hl_q_lh_1,in1_lh_q_hl_1);
 if ((IN2==1'b1) && (IN3==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_1,in1_hl_q_hl_1);
 if ((IN1==1'b0) && (IN3==1'b0))
 (        IN2 -=> Q) = (in2_hl_q_lh_1,in2_lh_q_hl_1);
 if ((IN1==1'b1) && (IN3==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh_1,in2_hl_q_hl_1);
 if ((IN2==1'b0) && (IN3==1'b1))
 (        IN1 +=> Q) = (in1_lh_q_lh_2,in1_hl_q_hl_2);
 if ((IN2==1'b1) && (IN3==1'b1))
 (        IN1 -=> Q) = (in1_hl_q_lh_2,in1_lh_q_hl_2);
 if ((IN1==1'b0) && (IN3==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_2,in2_hl_q_hl_2);
 if ((IN1==1'b1) && (IN3==1'b1))
 (        IN2 -=> Q) = (in2_hl_q_lh_2,in2_lh_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b0))
 (        IN3 -=> Q) = (in3_hl_q_lh_1,in3_lh_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_1,in3_hl_q_hl_1);
 if ((IN1==1'b0) && (IN2==1'b1))
 (        IN3 +=> Q) = (in3_lh_q_lh_2,in3_hl_q_hl_2);
 if ((IN1==1'b1) && (IN2==1'b1))
 (        IN3 -=> Q) = (in3_hl_q_lh_2,in3_lh_q_hl_2);
endspecify
`endif

endmodule
