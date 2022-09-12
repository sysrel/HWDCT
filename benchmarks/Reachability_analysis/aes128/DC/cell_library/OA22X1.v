`timescale 1ps / 1ps
module OA22X1 (IN1,IN2,IN3,IN4,Q);

output  Q;
input   IN1,IN2,IN3,IN4;

or (g_1_out,IN4,IN3);
or (g_2_out,IN2,IN1);
and #1 (Q,g_1_out,g_2_out);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh_1=104,in1_hl_q_hl_1=88,in2_lh_q_lh_1=87,
 in2_hl_q_hl_1=81,in3_lh_q_lh_1=89,in3_lh_q_lh_2=70,in3_lh_q_lh_3=59,
 in3_hl_q_hl_1=82,in3_hl_q_hl_2=72,in3_hl_q_hl_3=72,in1_lh_q_lh_2=89,
 in1_hl_q_hl_2=80,in2_lh_q_lh_2=73,in2_hl_q_hl_2=74,in1_lh_q_lh_3=75,
 in1_hl_q_hl_3=83,in2_lh_q_lh_3=62,in2_hl_q_hl_3=76,in4_lh_q_lh_1=76,
 in4_lh_q_lh_2=58,in4_lh_q_lh_3=50,in4_hl_q_hl_1=73,in4_hl_q_hl_2=63,
 in4_hl_q_hl_3=63;
 if ((IN2==1'b0) && (IN3==1'b1) && (IN4==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_1,in1_hl_q_hl_1);
 if ((IN1==1'b0) && (IN3==1'b1) && (IN4==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh_1,in2_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN4==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_1,in3_hl_q_hl_1);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN4==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_2,in3_hl_q_hl_2);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN4==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_3,in3_hl_q_hl_3);
 if ((IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1))
 (        IN1 +=> Q) = (in1_lh_q_lh_2,in1_hl_q_hl_2);
 if ((IN1==1'b0) && (IN3==1'b0) && (IN4==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_2,in2_hl_q_hl_2);
 if ((IN2==1'b0) && (IN3==1'b1) && (IN4==1'b1))
 (        IN1 +=> Q) = (in1_lh_q_lh_3,in1_hl_q_hl_3);
 if ((IN1==1'b0) && (IN3==1'b1) && (IN4==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_3,in2_hl_q_hl_3);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0))
 (        IN4 +=> Q) = (in4_lh_q_lh_1,in4_hl_q_hl_1);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b0))
 (        IN4 +=> Q) = (in4_lh_q_lh_2,in4_hl_q_hl_2);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b0))
 (        IN4 +=> Q) = (in4_lh_q_lh_3,in4_hl_q_hl_3);
endspecify
`endif

endmodule
