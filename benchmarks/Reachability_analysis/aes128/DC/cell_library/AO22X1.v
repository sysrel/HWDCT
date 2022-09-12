`timescale 1ps / 1ps
module AO22X1 (IN1,IN2,IN3,IN4,Q);

output  Q;
input   IN1,IN2,IN3,IN4;

and (g_1_out,IN2,IN1);
and (g_2_out,IN4,IN3);
or #1 (Q,g_1_out,g_2_out);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh_1=89,in1_hl_q_hl_1=85,in2_lh_q_lh_1=92,
 in2_hl_q_hl_1=90,in1_lh_q_lh_2=87,in1_hl_q_hl_2=110,in2_lh_q_lh_2=89,
 in2_hl_q_hl_2=117,in1_lh_q_lh_3=84,in1_hl_q_hl_3=102,in2_lh_q_lh_3=87,
 in2_hl_q_hl_3=109,in3_lh_q_lh_1=64,in3_lh_q_lh_2=66,in3_lh_q_lh_3=64,
 in3_hl_q_hl_1=66,in3_hl_q_hl_2=89,in3_hl_q_hl_3=80,in4_lh_q_lh_1=70,
 in4_lh_q_lh_2=72,in4_lh_q_lh_3=70,in4_hl_q_hl_1=71,in4_hl_q_hl_2=96,
 in4_hl_q_hl_3=87;
 if ((IN2==1'b1) && (IN3==1'b0) && (IN4==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_1,in1_hl_q_hl_1);
 if ((IN1==1'b1) && (IN3==1'b0) && (IN4==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh_1,in2_hl_q_hl_1);
 if ((IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_2,in1_hl_q_hl_2);
 if ((IN1==1'b1) && (IN3==1'b1) && (IN4==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh_2,in2_hl_q_hl_2);
 if ((IN2==1'b1) && (IN3==1'b0) && (IN4==1'b1))
 (        IN1 +=> Q) = (in1_lh_q_lh_3,in1_hl_q_hl_3);
 if ((IN1==1'b1) && (IN3==1'b0) && (IN4==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_3,in2_hl_q_hl_3);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN4==1'b1))
 (        IN3 +=> Q) = (in3_lh_q_lh_1,in3_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN4==1'b1))
 (        IN3 +=> Q) = (in3_lh_q_lh_2,in3_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN4==1'b1))
 (        IN3 +=> Q) = (in3_lh_q_lh_3,in3_hl_q_hl_3);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_1,in4_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_2,in4_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_3,in4_hl_q_hl_3);
endspecify
`endif

endmodule
