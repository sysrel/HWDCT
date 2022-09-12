`timescale 1ps / 1ps
module AO21X1 (IN1,IN2,IN3,Q);

output  Q;
input   IN1,IN2,IN3;

and (g_1_out,IN1,IN2);
or #1 (Q,g_1_out,IN3);

`ifdef functional
`else
specify
 specparam in1_lh_q_lh=80,in1_hl_q_hl=79,in2_lh_q_lh=81,in2_hl_q_hl=84,
 in3_lh_q_lh_1=55,in3_lh_q_lh_2=57,in3_lh_q_lh_3=55,in3_hl_q_hl_1=47,
 in3_hl_q_hl_2=65,in3_hl_q_hl_3=58;
 if ((IN2==1'b1) && (IN3==1'b0))
 (        IN1 +=> Q) = (in1_lh_q_lh,in1_hl_q_hl);
 if ((IN1==1'b1) && (IN3==1'b0))
 (        IN2 +=> Q) = (in2_lh_q_lh,in2_hl_q_hl);
 if ((IN1==1'b0) && (IN2==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_1,in3_hl_q_hl_1);
 if ((IN1==1'b1) && (IN2==1'b0))
 (        IN3 +=> Q) = (in3_lh_q_lh_2,in3_hl_q_hl_2);
 if ((IN1==1'b0) && (IN2==1'b1))
 (        IN3 +=> Q) = (in3_lh_q_lh_3,in3_hl_q_hl_3);
endspecify
`endif

endmodule
