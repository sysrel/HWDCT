`timescale 1ps / 1ps
module OA21X1 (IN1,IN2,IN3,Q);

output  Q;
input   IN1,IN2,IN3;

or (g_2_out,IN1,IN2);
and #1 (Q,IN3,g_2_out);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh=98,in1_hl_q_hl=87,in2_lh_q_lh=81,in2_hl_q_hl=80,
 in3_lh_q_lh_1=80,in3_lh_q_lh_2=60,in3_lh_q_lh_3=49,in3_hl_q_hl_1=71,
 in3_hl_q_hl_2=62,in3_hl_q_hl_3=62;
 if ((IN2==1'b0) && (IN3==1'b1))
 (        IN1 +=> Q) = (in1_lh_q_lh,in1_hl_q_hl);
 if ((IN1==1'b0) && (IN3==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh,in2_hl_q_hl);
 if ((IN1==1'b1) && (IN2==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_1,in3_hl_q_hl_1);
 if ((IN1==1'b0) && (IN2==1'b1))
 (        IN3 +=> Q) = (in3_lh_q_lh_2,in3_hl_q_hl_2);
 if ((IN1==1'b1) && (IN2==1'b1))
 (        IN3 +=> Q) = (in3_lh_q_lh_3,in3_hl_q_hl_3);
endspecify
`endif

endmodule
