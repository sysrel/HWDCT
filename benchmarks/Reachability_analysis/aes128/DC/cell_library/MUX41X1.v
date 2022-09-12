`timescale 1ps / 1ps
module MUX41X1 (IN1,IN2,IN3,IN4,S0,S1,Q);

output  Q;
input   IN1,IN2,IN3,IN4,S0,S1;

s_mux41x1_  d1 (Q,S1,S0,IN4,IN3,IN2,IN1);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh_1=113,in1_hl_q_hl_1=112,in1_lh_q_lh_2=113,
 in1_hl_q_hl_2=112,in1_lh_q_lh_3=113,in1_hl_q_hl_3=112,in1_lh_q_lh_4=113,
 in1_hl_q_hl_4=112,in1_lh_q_lh_5=113,in1_hl_q_hl_5=112,in1_lh_q_lh_6=113,
 in1_hl_q_hl_6=112,in1_lh_q_lh_7=113,in1_hl_q_hl_7=112,in1_lh_q_lh_8=113,
 in1_hl_q_hl_8=112,in3_lh_q_lh_1=110,in3_lh_q_lh_2=110,in3_lh_q_lh_3=110,
 in3_lh_q_lh_4=110,in3_hl_q_hl_1=112,in3_hl_q_hl_2=112,in3_hl_q_hl_3=112,
 in3_hl_q_hl_4=112,in3_lh_q_lh_5=110,in3_lh_q_lh_6=110,in3_lh_q_lh_7=110,
 in3_lh_q_lh_8=110,in3_hl_q_hl_5=112,in3_hl_q_hl_6=112,in3_hl_q_hl_7=112,
 in3_hl_q_hl_8=112,s0_lh_q_hl_1=72,s0_lh_q_hl_2=72,s0_lh_q_lh_1=47,
 s0_lh_q_lh_2=47,s0_lh_q_hl_3=72,s0_lh_q_hl_4=72,s0_lh_q_lh_3=47,
 s0_lh_q_lh_4=47,s0_hl_q_lh_1=83,s0_hl_q_lh_2=83,s0_hl_q_hl_1=57,
 s0_hl_q_hl_2=57,s0_hl_q_lh_3=83,s0_hl_q_lh_4=83,s0_hl_q_hl_3=57,
 s0_hl_q_hl_4=57,in2_lh_q_lh_1=110,in2_lh_q_lh_2=110,in2_hl_q_hl_1=114,
 in2_hl_q_hl_2=114,in2_lh_q_lh_3=110,in2_lh_q_lh_4=110,in2_hl_q_hl_3=114,
 in2_hl_q_hl_4=114,in2_lh_q_lh_5=110,in2_lh_q_lh_6=110,in2_hl_q_hl_5=114,
 in2_hl_q_hl_6=114,in2_lh_q_lh_7=110,in2_lh_q_lh_8=110,in2_hl_q_hl_7=114,
 in2_hl_q_hl_8=114,in4_lh_q_lh_1=103,in4_lh_q_lh_2=103,in4_lh_q_lh_3=103,
 in4_lh_q_lh_4=103,in4_lh_q_lh_5=103,in4_lh_q_lh_6=103,in4_lh_q_lh_7=103,
 in4_lh_q_lh_8=103,in4_hl_q_hl_1=110,in4_hl_q_hl_2=110,in4_hl_q_hl_3=110,
 in4_hl_q_hl_4=110,in4_hl_q_hl_5=110,in4_hl_q_hl_6=110,in4_hl_q_hl_7=110,
 in4_hl_q_hl_8=110,s0_lh_q_hl_5=72,s0_lh_q_hl_6=72,s0_lh_q_hl_7=72,
 s0_lh_q_hl_8=72,s0_lh_q_lh_5=47,s0_lh_q_lh_6=47,s0_lh_q_lh_7=47,
 s0_lh_q_lh_8=47,s0_hl_q_lh_5=83,s0_hl_q_lh_6=83,s0_hl_q_lh_7=83,
 s0_hl_q_lh_8=83,s0_hl_q_hl_5=57,s0_hl_q_hl_6=57,s0_hl_q_hl_7=57,
 s0_hl_q_hl_8=57,s1_lh_q_hl_1=137,s1_lh_q_lh_1=97,s1_lh_q_hl_2=134,
 s1_lh_q_lh_2=100,s1_lh_q_hl_3=138,s1_lh_q_lh_3=94,s1_lh_q_hl_4=135,
 s1_lh_q_lh_4=98,s1_lh_q_hl_5=132,s1_lh_q_hl_6=127,s1_lh_q_hl_7=133,
 s1_lh_q_hl_8=130,s1_lh_q_lh_5=95,s1_lh_q_lh_6=100,s1_lh_q_lh_7=88,
 s1_lh_q_lh_8=95,s1_hl_q_lh_1=139,s1_hl_q_hl_1=101,s1_hl_q_lh_2=139,
 s1_hl_q_hl_2=104,s1_hl_q_lh_3=138,s1_hl_q_hl_3=95,s1_hl_q_lh_4=138,
 s1_hl_q_hl_4=100,s1_hl_q_lh_5=133,s1_hl_q_lh_6=128,s1_hl_q_lh_7=133,
 s1_hl_q_lh_8=130,s1_hl_q_hl_5=103,s1_hl_q_hl_6=107,s1_hl_q_hl_7=96,
 s1_hl_q_hl_8=102;
 if ((IN2==1'b0) && (IN3==1'b0) && (IN4==1'b0) && (S0==1'b0) && (S1==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_1,in1_hl_q_hl_1);
 if ((IN2==1'b1) && (IN3==1'b0) && (IN4==1'b0) && (S0==1'b0) && (S1==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_2,in1_hl_q_hl_2);
 if ((IN2==1'b0) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b0) && (S1==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_3,in1_hl_q_hl_3);
 if ((IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b0) && (S1==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_4,in1_hl_q_hl_4);
 if ((IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b0) && (S1==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_5,in1_hl_q_hl_5);
 if ((IN2==1'b1) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b0) && (S1==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_6,in1_hl_q_hl_6);
 if ((IN2==1'b0) && (IN3==1'b1) && (IN4==1'b1) && (S0==1'b0) && (S1==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_7,in1_hl_q_hl_7);
 if ((IN2==1'b1) && (IN3==1'b1) && (IN4==1'b1) && (S0==1'b0) && (S1==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh_8,in1_hl_q_hl_8);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN4==1'b0) && (S0==1'b1) && (S1==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_1,in3_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN4==1'b0) && (S0==1'b1) && (S1==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_2,in3_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN4==1'b0) && (S0==1'b1) && (S1==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_3,in3_hl_q_hl_3);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN4==1'b0) && (S0==1'b1) && (S1==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_4,in3_hl_q_hl_4);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN4==1'b1) && (S0==1'b1) && (S1==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_5,in3_hl_q_hl_5);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN4==1'b1) && (S0==1'b1) && (S1==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_6,in3_hl_q_hl_6);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN4==1'b1) && (S0==1'b1) && (S1==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_7,in3_hl_q_hl_7);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN4==1'b1) && (S0==1'b1) && (S1==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_8,in3_hl_q_hl_8);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b0) && (S1==1'b0))
 (        S0  -=> Q) = (s0_hl_q_lh_1,s0_lh_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b0) && (S1==1'b0))
 (        S0  -=> Q) = (s0_hl_q_lh_2,s0_lh_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b0) && (S1==1'b0))
 (        S0  +=> Q) = (s0_lh_q_lh_1,s0_hl_q_hl_1);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (S1==1'b0))
 (        S0  +=> Q) = (s0_lh_q_lh_2,s0_hl_q_hl_2);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1) && (S1==1'b0))
 (        S0  -=> Q) = (s0_hl_q_lh_3,s0_lh_q_hl_3);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b1) && (S1==1'b0))
 (        S0  -=> Q) = (s0_hl_q_lh_4,s0_lh_q_hl_4);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b1) && (S1==1'b0))
 (        S0  +=> Q) = (s0_lh_q_lh_3,s0_hl_q_hl_3);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b1) && (S1==1'b0))
 (        S0  +=> Q) = (s0_lh_q_lh_4,s0_hl_q_hl_4);
 if ((IN1==1'b0) && (IN3==1'b0) && (IN4==1'b0) && (S0==1'b0) && (S1==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_1,in2_hl_q_hl_1);
 if ((IN1==1'b1) && (IN3==1'b0) && (IN4==1'b0) && (S0==1'b0) && (S1==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_2,in2_hl_q_hl_2);
 if ((IN1==1'b0) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b0) && (S1==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_3,in2_hl_q_hl_3);
 if ((IN1==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b0) && (S1==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_4,in2_hl_q_hl_4);
 if ((IN1==1'b0) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b0) && (S1==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_5,in2_hl_q_hl_5);
 if ((IN1==1'b1) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b0) && (S1==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_6,in2_hl_q_hl_6);
 if ((IN1==1'b0) && (IN3==1'b1) && (IN4==1'b1) && (S0==1'b0) && (S1==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_7,in2_hl_q_hl_7);
 if ((IN1==1'b1) && (IN3==1'b1) && (IN4==1'b1) && (S0==1'b0) && (S1==1'b1))
 (        IN2 +=> Q) = (in2_lh_q_lh_8,in2_hl_q_hl_8);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b0) && (S0==1'b1) && (S1==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_1,in4_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (S0==1'b1) && (S1==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_2,in4_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b0) && (S0==1'b1) && (S1==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_3,in4_hl_q_hl_3);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b0) && (S0==1'b1) && (S1==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_4,in4_hl_q_hl_4);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b1) && (S0==1'b1) && (S1==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_5,in4_hl_q_hl_5);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b1) && (S0==1'b1) && (S1==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_6,in4_hl_q_hl_6);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (S0==1'b1) && (S1==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_7,in4_hl_q_hl_7);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b1) && (S0==1'b1) && (S1==1'b1))
 (        IN4 +=> Q) = (in4_lh_q_lh_8,in4_hl_q_hl_8);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b0) && (S1==1'b1))
 (        S0  -=> Q) = (s0_hl_q_lh_5,s0_lh_q_hl_5);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b0) && (S1==1'b1))
 (        S0  -=> Q) = (s0_hl_q_lh_6,s0_lh_q_hl_6);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (S1==1'b1))
 (        S0  -=> Q) = (s0_hl_q_lh_7,s0_lh_q_hl_7);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (S1==1'b1))
 (        S0  -=> Q) = (s0_hl_q_lh_8,s0_lh_q_hl_8);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1) && (S1==1'b1))
 (        S0  +=> Q) = (s0_lh_q_lh_5,s0_hl_q_hl_5);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1) && (S1==1'b1))
 (        S0  +=> Q) = (s0_lh_q_lh_6,s0_hl_q_hl_6);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b1) && (S1==1'b1))
 (        S0  +=> Q) = (s0_lh_q_lh_7,s0_hl_q_hl_7);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b1) && (S1==1'b1))
 (        S0  +=> Q) = (s0_lh_q_lh_8,s0_hl_q_hl_8);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b0) && (S0==1'b0))
 (        S1  -=> Q) = (s1_hl_q_lh_1,s1_lh_q_hl_1);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b0) && (S0==1'b0))
 (        S1  +=> Q) = (s1_lh_q_lh_1,s1_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b0))
 (        S1  -=> Q) = (s1_hl_q_lh_2,s1_lh_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b0))
 (        S1  +=> Q) = (s1_lh_q_lh_2,s1_hl_q_hl_2);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b0))
 (        S1  -=> Q) = (s1_hl_q_lh_3,s1_lh_q_hl_3);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b0))
 (        S1  +=> Q) = (s1_lh_q_lh_3,s1_hl_q_hl_3);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b1) && (S0==1'b0))
 (        S1  -=> Q) = (s1_hl_q_lh_4,s1_lh_q_hl_4);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b1) && (S0==1'b0))
 (        S1  +=> Q) = (s1_lh_q_lh_4,s1_hl_q_hl_4);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b1))
 (        S1  -=> Q) = (s1_hl_q_lh_5,s1_lh_q_hl_5);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b1))
 (        S1  -=> Q) = (s1_hl_q_lh_6,s1_lh_q_hl_6);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b1))
 (        S1  -=> Q) = (s1_hl_q_lh_7,s1_lh_q_hl_7);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b1) && (IN4==1'b0) && (S0==1'b1))
 (        S1  -=> Q) = (s1_hl_q_lh_8,s1_lh_q_hl_8);
 if ((IN1==1'b0) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b1))
 (        S1  +=> Q) = (s1_lh_q_lh_5,s1_hl_q_hl_5);
 if ((IN1==1'b1) && (IN2==1'b0) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b1))
 (        S1  +=> Q) = (s1_lh_q_lh_6,s1_hl_q_hl_6);
 if ((IN1==1'b0) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b1))
 (        S1  +=> Q) = (s1_lh_q_lh_7,s1_hl_q_hl_7);
 if ((IN1==1'b1) && (IN2==1'b1) && (IN3==1'b0) && (IN4==1'b1) && (S0==1'b1))
 (        S1  +=> Q) = (s1_lh_q_lh_8,s1_hl_q_hl_8);
endspecify
`endif

endmodule
