`timescale 1ps / 1ps
module INVX0 (INP,ZN);

output  ZN;
input   INP;

not #1 (ZN,INP);

`ifdef functional
`else
specify
 specparam in_lh_qn_hl=13,in_hl_qn_lh=13;
 (        INP -=> ZN) = (in_hl_qn_lh,in_lh_qn_hl);
endspecify
`endif

endmodule
