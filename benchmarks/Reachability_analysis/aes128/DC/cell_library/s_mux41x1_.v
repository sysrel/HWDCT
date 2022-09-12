`timescale 1ps / 1ps
module s_mux41x1_ (Q,S1,S0,IN4,IN3,IN2,IN1);

output Q;
input  S1,S0,IN4,IN3,IN2,IN1;

table

   0    0    ?    ?    ?    1    : 1;
   0    0    ?    ?    ?    0    : 0;
   0    1    ?    0    ?    ?    : 0;
   0    1    ?    1    ?    ?    : 1;
   1    1    0    ?    ?    ?    : 0;
   1    1    1    ?    ?    ?    : 1;
   1    0    ?    ?    0    ?    : 0;
   1    0    ?    ?    1    ?    : 1;
endtable
endmodule
