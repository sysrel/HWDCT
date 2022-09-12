/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Sat Jun 12 14:30:07 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module mixcolum ( clk, reset, decrypt_i, start_i, data_i, ready_o, data_o );
  input [127:0] data_i;
  output [127:0] data_o;
  input clk, reset, decrypt_i, start_i;
  output ready_o;
  wire   next_ready_o, n3, n4/*, n5*/;
  reg   [1:0] state/*verilator public*/;
  reg	 n5;
  assign data_o[0] = 1'b0;
  assign data_o[1] = 1'b0;
  assign data_o[2] = 1'b0;
  assign data_o[3] = 1'b0;
  assign data_o[4] = 1'b0;
  assign data_o[5] = 1'b0;
  assign data_o[6] = 1'b0;
  assign data_o[7] = 1'b0;
  assign data_o[8] = 1'b0;
  assign data_o[9] = 1'b0;
  assign data_o[10] = 1'b0;
  assign data_o[11] = 1'b0;
  assign data_o[12] = 1'b0;
  assign data_o[13] = 1'b0;
  assign data_o[14] = 1'b0;
  assign data_o[15] = 1'b0;
  assign data_o[16] = 1'b0;
  assign data_o[17] = 1'b0;
  assign data_o[18] = 1'b0;
  assign data_o[19] = 1'b0;
  assign data_o[20] = 1'b0;
  assign data_o[21] = 1'b0;
  assign data_o[22] = 1'b0;
  assign data_o[23] = 1'b0;
  assign data_o[24] = 1'b0;
  assign data_o[25] = 1'b0;
  assign data_o[26] = 1'b0;
  assign data_o[27] = 1'b0;
  assign data_o[28] = 1'b0;
  assign data_o[29] = 1'b0;
  assign data_o[30] = 1'b0;
  assign data_o[31] = 1'b0;
  assign data_o[32] = 1'b0;
  assign data_o[33] = 1'b0;
  assign data_o[34] = 1'b0;
  assign data_o[35] = 1'b0;
  assign data_o[36] = 1'b0;
  assign data_o[37] = 1'b0;
  assign data_o[38] = 1'b0;
  assign data_o[39] = 1'b0;
  assign data_o[40] = 1'b0;
  assign data_o[41] = 1'b0;
  assign data_o[42] = 1'b0;
  assign data_o[43] = 1'b0;
  assign data_o[44] = 1'b0;
  assign data_o[45] = 1'b0;
  assign data_o[46] = 1'b0;
  assign data_o[47] = 1'b0;
  assign data_o[48] = 1'b0;
  assign data_o[49] = 1'b0;
  assign data_o[50] = 1'b0;
  assign data_o[51] = 1'b0;
  assign data_o[52] = 1'b0;
  assign data_o[53] = 1'b0;
  assign data_o[54] = 1'b0;
  assign data_o[55] = 1'b0;
  assign data_o[56] = 1'b0;
  assign data_o[57] = 1'b0;
  assign data_o[58] = 1'b0;
  assign data_o[59] = 1'b0;
  assign data_o[60] = 1'b0;
  assign data_o[61] = 1'b0;
  assign data_o[62] = 1'b0;
  assign data_o[63] = 1'b0;
  assign data_o[64] = 1'b0;
  assign data_o[65] = 1'b0;
  assign data_o[66] = 1'b0;
  assign data_o[67] = 1'b0;
  assign data_o[68] = 1'b0;
  assign data_o[69] = 1'b0;
  assign data_o[70] = 1'b0;
  assign data_o[71] = 1'b0;
  assign data_o[72] = 1'b0;
  assign data_o[73] = 1'b0;
  assign data_o[74] = 1'b0;
  assign data_o[75] = 1'b0;
  assign data_o[76] = 1'b0;
  assign data_o[77] = 1'b0;
  assign data_o[78] = 1'b0;
  assign data_o[79] = 1'b0;
  assign data_o[80] = 1'b0;
  assign data_o[81] = 1'b0;
  assign data_o[82] = 1'b0;
  assign data_o[83] = 1'b0;
  assign data_o[84] = 1'b0;
  assign data_o[85] = 1'b0;
  assign data_o[86] = 1'b0;
  assign data_o[87] = 1'b0;
  assign data_o[88] = 1'b0;
  assign data_o[89] = 1'b0;
  assign data_o[90] = 1'b0;
  assign data_o[91] = 1'b0;
  assign data_o[92] = 1'b0;
  assign data_o[93] = 1'b0;
  assign data_o[94] = 1'b0;
  assign data_o[95] = 1'b0;
  assign data_o[96] = 1'b0;
  assign data_o[97] = 1'b0;
  assign data_o[98] = 1'b0;
  assign data_o[99] = 1'b0;
  assign data_o[100] = 1'b0;
  assign data_o[101] = 1'b0;
  assign data_o[102] = 1'b0;
  assign data_o[103] = 1'b0;
  assign data_o[104] = 1'b0;
  assign data_o[105] = 1'b0;
  assign data_o[106] = 1'b0;
  assign data_o[107] = 1'b0;
  assign data_o[108] = 1'b0;
  assign data_o[109] = 1'b0;
  assign data_o[110] = 1'b0;
  assign data_o[111] = 1'b0;
  assign data_o[112] = 1'b0;
  assign data_o[113] = 1'b0;
  assign data_o[114] = 1'b0;
  assign data_o[115] = 1'b0;
  assign data_o[116] = 1'b0;
  assign data_o[117] = 1'b0;
  assign data_o[118] = 1'b0;
  assign data_o[119] = 1'b0;
  assign data_o[120] = 1'b0;
  assign data_o[121] = 1'b0;
  assign data_o[122] = 1'b0;
  assign data_o[123] = 1'b0;
  assign data_o[124] = 1'b0;
  assign data_o[125] = 1'b0;
  assign data_o[126] = 1'b0;
  assign data_o[127] = 1'b0;

always @(posedge clk) 
begin
 if(reset==1'b0)
  begin
  state[0] = 1'b0;
  state[1] = 1'b0; 

  end
 else 
  begin
  state[0] = n4;
  n5 = ~n4;
  state[1] = n3;
  end
end

  //DFFARX1 \state_reg[0]  ( .D(n4), .CLK(clk), .RSTB(reset), .Q(state[0]), .QN(n5) );
  DFFARX1 ready_o_reg ( .D(next_ready_o), .CLK(clk), .RSTB(reset), .Q(ready_o));
  //DFFARX1 \state_reg[1]  ( .D(n3), .CLK(clk), .RSTB(reset), .Q(state[1]) );
  MUX21X1 U9 ( .IN1(state[0]), .IN2(n5), .S(state[1]), .Q(n3) );
  AND2X1 U10 ( .IN1(state[0]), .IN2(state[1]), .Q(next_ready_o) );
  OA21X1 U12 ( .IN1(state[1]), .IN2(start_i), .IN3(n5), .Q(n4) );
endmodule

