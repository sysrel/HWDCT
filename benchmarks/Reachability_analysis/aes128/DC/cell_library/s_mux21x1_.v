`timescale 1ps / 1ps
module s_mux21x1_ (Q,S,IN2,IN1);

output Q;
input  S,IN2,IN1;

table

   0    ?    1    : 1;
   0    ?    0    : 0;
   1    1    ?    : 1;
   1    0    ?    : 0;
endtable
endmodule
