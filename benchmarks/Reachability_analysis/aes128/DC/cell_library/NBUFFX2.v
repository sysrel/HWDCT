`timescale 1ps / 1ps
module NBUFFX2 (INP,Z);

output  Z;
input   INP;

buf #1 (Z,INP);

`ifdef functional
`else
specify
 specparam in_lh_q_lh=48,in_hl_q_hl=45;
 (        INP +=> Z) = (in_lh_q_lh,in_hl_q_hl);
endspecify
`endif

endmodule
