`timescale 1ps / 1ps
module AO221X1 (IN1,IN2,IN3,IN4,IN5,Q);

output  Q;
input   IN1,IN2,IN3,IN4,IN5;

and (g_1_out,IN2,IN1);
and (g_2_out,IN3,IN4);
or #1 (Q,g_1_out,g_2_out,IN5);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh_1=120,in1_hl_q_hl_1=120,in2_lh_q_lh_1=122,
 in2_hl_q_hl_1=126,in1_lh_q_lh_2=119,in1_hl_q_hl_2=149,in2_lh_q_lh_2=121,
 in2_hl_q_hl_2=156,in1_lh_q_lh_3=115,in1_hl_q_hl_3=139,in2_lh_q_lh_3=118,
 in2_hl_q_hl_3=147,in3_lh_q_lh_1=97,in3_lh_q_lh_2=100,in3_lh_q_lh_3=97,
 in3_hl_q_hl_1=103,in3_hl_q_hl_2=132,in3_hl_q_hl_3=123,in4_lh_q_lh_1=102,
 in4_lh_q_lh_2=105,in4_lh_q_lh_3=102,in4_hl_q_hl_1=110,in4_hl_q_hl_2=141,
 in4_hl_q_hl_3=131,in5_lh_q_lh_1=68,in5_lh_q_lh_2=70,in5_lh_q_lh_3=68,
 in5_lh_q_lh_4=70,in5_lh_q_lh_5=72,in5_lh_q_lh_6=70,in5_lh_q_lh_7=68,
 in5_lh_q_lh_8=70,in5_lh_q_lh_9=68,in5_hl_q_hl_1=58,in5_hl_q_hl_2=73,
 in5_hl_q_hl_3=65,in5_hl_q_hl_4=79,in5_hl_q_hl_5=98,in5_hl_q_hl_6=89,
 in5_hl_q_hl_7=71,in5_hl_q_hl_8=88,in5_hl_q_hl_9=79;
 if ((IN2==1'b1) && (IN3==1'b0) && (IN4==1'b0) && (IN5==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_1,in1_hl_q_hl_1);
 if ((IN1==1'b1) && (IN3==1'b0) && (IN4==1'b0) && (IN5==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh_1,in2_hl_q_hl_1);
 if ((IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (IN5==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_2,in1_hl_q_hl_2);
 if ((IN1==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (IN5==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh_2,in2_hl_q_hl_2);
 if ((IN2==1'b1) && (IN3==1'b0) && (IN4==1'b1) && (IN5==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_3,in1_hl_q_hl_3);
 if ((IN1==1'b1) && (IN3==1'b0) && (IN4==1'b1) && (IN5==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh_3,in2_hl_q_hl_3);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN4==1'b1) && (IN5==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_1,in3_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN4==1'b1) && (IN5==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_2,in3_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN4==1'b1) && (IN5==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_3,in3_hl_q_hl_3);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b1) && (IN5==1'b0))
 (        IN4 +=> Q) = (in4_lh_q_lh_1,in4_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b1) && (IN5==1'b0))
 (        IN4 +=> Q) = (in4_lh_q_lh_2,in4_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (IN5==1'b0))
 (        IN4 +=> Q) = (in4_lh_q_lh_3,in4_hl_q_hl_3);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b0))
 (        IN5 +=> Q) = (in5_lh_q_lh_1,in5_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b0))
 (        IN5 +=> Q) = (in5_lh_q_lh_2,in5_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b0))
 (        IN5 +=> Q) = (in5_lh_q_lh_3,in5_hl_q_hl_3);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b0))
 (        IN5 +=> Q) = (in5_lh_q_lh_4,in5_hl_q_hl_4);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b0))
 (        IN5 +=> Q) = (in5_lh_q_lh_5,in5_hl_q_hl_5);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0))
 (        IN5 +=> Q) = (in5_lh_q_lh_6,in5_hl_q_hl_6);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1))
 (        IN5 +=> Q) = (in5_lh_q_lh_7,in5_hl_q_hl_7);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1))
 (        IN5 +=> Q) = (in5_lh_q_lh_8,in5_hl_q_hl_8);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b1))
 (        IN5 +=> Q) = (in5_lh_q_lh_9,in5_hl_q_hl_9);
endspecify
`endif

endmodule
