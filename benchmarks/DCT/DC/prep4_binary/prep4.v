/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Sat Jun 12 00:18:45 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module prep4 ( clk, rst, in, out );
  input [7:0] in;
  output [7:0] out;
  input clk, rst;
  wire   n89, n90, n91, n92, n101, n102, n104, n105, n106, n107, n108, n109,
         n110, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120,
         n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, n131,
         n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142,
         n143, n144, n145, n146, n147, n148, n149, n150, n151, n152, n153,
         n154, n155, n156, n157, n158, n159, n160, n161, n162, n163, n164,
         n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185;
  wire   [3:0] state/*verilator public*/;
/*  reg 	n182, n183, n184, n185;
always @(posedge clk) 
begin
 if(rst==1'b0)
  begin
  state[0] = 1'b0;
  state[1] = 1'b0; 
  state[2] = 1'b0;
  state[3] = 1'b0;
  end
 else 
  begin
  state[0] = n89;
  n183 = ~n89;
  state[1] = n90;
  n184 = ~n90;
  state[2] = n91;
  n185 = ~n91;
  state[3] = n92;
  n182 = ~n92;
  end
end
*/
  DFFARX1 \state_reg[0]  ( .D(n89), .CLK(clk), .RSTB(rst), .Q(state[0]), .QN(n183) );
  DFFARX1 \state_reg[1]  ( .D(n90), .CLK(clk), .RSTB(rst), .Q(state[1]), .QN(n184) );
  DFFARX1 \state_reg[2]  ( .D(n91), .CLK(clk), .RSTB(rst), .Q(state[2]), .QN(n185) );
  DFFARX1 \state_reg[3]  ( .D(n92), .CLK(clk), .RSTB(rst), .Q(state[3]), .QN(n182) );
  NAND2X0 U103 ( .IN1(n163), .IN2(n156), .QN(n143) );
  NAND2X0 U104 ( .IN1(in[5]), .IN2(in[3]), .QN(n135) );
  NAND2X0 U105 ( .IN1(n177), .IN2(n155), .QN(n138) );
  NAND2X0 U106 ( .IN1(n102), .IN2(n109), .QN(n108) );
  NAND2X0 U107 ( .IN1(n141), .IN2(n144), .QN(n112) );
  NAND2X0 U108 ( .IN1(n101), .IN2(n165), .QN(out[0]) );
  NAND2X0 U109 ( .IN1(n182), .IN2(n184), .QN(n172) );
  INVX0 U110 ( .INP(n172), .ZN(n176) );
  NAND2X0 U111 ( .IN1(n183), .IN2(n185), .QN(n169) );
  OA22X1 U112 ( .IN1(n176), .IN2(n185), .IN3(n182), .IN4(n169), .Q(n101) );
  NAND2X0 U113 ( .IN1(n184), .IN2(state[3]), .QN(n146) );
  OR2X1 U114 ( .IN1(n146), .IN2(state[2]), .Q(n165) );
  NAND2X0 U115 ( .IN1(state[0]), .IN2(state[1]), .QN(n120) );
  NAND2X0 U116 ( .IN1(n146), .IN2(n120), .QN(out[5]) );
  NOR2X0 U117 ( .IN1(state[2]), .IN2(n183), .QN(n111) );
  NAND2X0 U118 ( .IN1(n111), .IN2(n184), .QN(n114) );
  NAND2X0 U119 ( .IN1(n101), .IN2(n114), .QN(out[2]) );
  NAND2X0 U120 ( .IN1(state[1]), .IN2(state[2]), .QN(n116) );
  INVX0 U121 ( .INP(n116), .ZN(n110) );
  INVX0 U122 ( .INP(in[0]), .ZN(n128) );
  INVX0 U123 ( .INP(in[7]), .ZN(n160) );
  NOR2X0 U124 ( .IN1(n128), .IN2(n160), .QN(n119) );
  NAND3X0 U125 ( .IN1(n110), .IN2(in[1]), .IN3(n119), .QN(n102) );
  NOR2X0 U126 ( .IN1(n183), .IN2(n182), .QN(n109) );
  NOR2X0 U128 ( .IN1(in[6]), .IN2(in[7]), .QN(n142) );
  AND2X1 U129 ( .IN1(in[6]), .IN2(in[7]), .Q(n155) );
  AO221X1 U130 ( .IN1(1'b1), .IN2(n142), .IN3(n182), .IN4(n155), .IN5(n184), 
        .Q(n105) );
  NAND2X0 U131 ( .IN1(in[1]), .IN2(in[0]), .QN(n127) );
  NAND3X0 U132 ( .IN1(in[4]), .IN2(in[2]), .IN3(n155), .QN(n104) );
  NOR3X0 U133 ( .IN1(n127), .IN2(n135), .IN3(n104), .QN(n122) );
  NAND2X0 U134 ( .IN1(state[2]), .IN2(n183), .QN(n132) );
  AO221X1 U135 ( .IN1(n105), .IN2(n122), .IN3(n105), .IN4(n182), .IN5(n132), 
        .Q(n107) );
  INVX0 U136 ( .INP(in[5]), .ZN(n163) );
  MUX21X1 U137 ( .IN1(n163), .IN2(in[5]), .S(in[4]), .Q(n159) );
  AO21X1 U138 ( .IN1(in[7]), .IN2(n159), .IN3(n146), .Q(n106) );
  NAND3X0 U139 ( .IN1(n108), .IN2(n107), .IN3(n106), .QN(n92) );
  OAI21X1 U140 ( .IN1(n176), .IN2(n111), .IN3(n165), .QN(out[4]) );
  NOR2X0 U141 ( .IN1(state[3]), .IN2(n184), .QN(n177) );
  INVX0 U142 ( .INP(n109), .ZN(n115) );
  OAI22X1 U143 ( .IN1(n177), .IN2(n132), .IN3(n110), .IN4(n115), .QN(out[7])
         );
  NAND2X0 U144 ( .IN1(n177), .IN2(n111), .QN(n180) );
  NAND2X0 U145 ( .IN1(state[3]), .IN2(n183), .QN(n113) );
  NOR2X0 U146 ( .IN1(n183), .IN2(n185), .QN(n141) );
  INVX0 U147 ( .INP(n177), .ZN(n144) );
  NAND4X0 U148 ( .IN1(n165), .IN2(n180), .IN3(n113), .IN4(n112), .QN(out[6])
         );
  NAND4X0 U149 ( .IN1(n165), .IN2(n116), .IN3(n115), .IN4(n114), .QN(out[1])
         );
  MUX21X1 U150 ( .IN1(n184), .IN2(n185), .S(state[0]), .Q(n118) );
  NOR3X0 U151 ( .IN1(state[3]), .IN2(state[0]), .IN3(n184), .QN(n117) );
  AO221X1 U152 ( .IN1(n118), .IN2(state[3]), .IN3(state[1]), .IN4(state[2]), 
        .IN5(n117), .Q(out[3]) );
  INVX0 U153 ( .INP(n142), .ZN(n129) );
  AO222X1 U154 ( .IN1(n129), .IN2(n172), .IN3(n129), .IN4(n169), .IN5(n142), 
        .IN6(n132), .Q(n126) );
  OA221X1 U155 ( .IN1(state[3]), .IN2(n142), .IN3(n182), .IN4(n119), .IN5(
        state[1]), .Q(n121) );
  INVX0 U156 ( .INP(n141), .ZN(n174) );
  NOR2X0 U157 ( .IN1(in[4]), .IN2(in[2]), .QN(n158) );
  NAND2X0 U158 ( .IN1(n128), .IN2(n158), .QN(n175) );
  OR2X1 U159 ( .IN1(n175), .IN2(in[1]), .Q(n157) );
  INVX0 U160 ( .INP(in[3]), .ZN(n156) );
  NOR2X0 U161 ( .IN1(n157), .IN2(n143), .QN(n130) );
  NAND4X0 U162 ( .IN1(in[6]), .IN2(n130), .IN3(n185), .IN4(n160), .QN(n167) );
  OA22X1 U163 ( .IN1(n121), .IN2(n174), .IN3(n167), .IN4(n120), .Q(n125) );
  NAND2X0 U164 ( .IN1(n122), .IN2(state[3]), .QN(n123) );
  NAND3X0 U165 ( .IN1(n184), .IN2(n123), .IN3(state[2]), .QN(n124) );
  NAND4X0 U166 ( .IN1(n126), .IN2(n125), .IN3(n124), .IN4(n180), .QN(n91) );
  NAND2X0 U167 ( .IN1(state[3]), .IN2(state[1]), .QN(n153) );
  NAND3X0 U168 ( .IN1(n182), .IN2(n185), .IN3(n127), .QN(n166) );
  OA222X1 U169 ( .IN1(n167), .IN2(n153), .IN3(n128), .IN4(n165), .IN5(n166), 
        .IN6(state[1]), .Q(n134) );
  NOR2X0 U170 ( .IN1(n130), .IN2(n129), .QN(n131) );
  OA22X1 U171 ( .IN1(n131), .IN2(n153), .IN3(n175), .IN4(n172), .Q(n133) );
  OA22X1 U172 ( .IN1(n134), .IN2(n183), .IN3(n133), .IN4(n132), .Q(n151) );
  INVX0 U173 ( .INP(in[1]), .ZN(n152) );
  NAND2X0 U174 ( .IN1(n143), .IN2(n135), .QN(n136) );
  MUX21X1 U175 ( .IN1(in[1]), .IN2(n152), .S(n136), .Q(n137) );
  OA22X1 U176 ( .IN1(in[0]), .IN2(n172), .IN3(n137), .IN4(n146), .Q(n140) );
  NAND4X0 U177 ( .IN1(state[3]), .IN2(state[1]), .IN3(in[1]), .IN4(in[7]), 
        .QN(n139) );
  NAND4X0 U178 ( .IN1(n141), .IN2(n140), .IN3(n139), .IN4(n138), .QN(n150) );
  NAND3X0 U179 ( .IN1(n142), .IN2(n177), .IN3(n183), .QN(n149) );
  NAND2X0 U180 ( .IN1(n142), .IN2(n182), .QN(n164) );
  INVX0 U181 ( .INP(n143), .ZN(n145) );
  OA221X1 U182 ( .IN1(n164), .IN2(n145), .IN3(n164), .IN4(n158), .IN5(n144), 
        .Q(n147) );
  AO221X1 U183 ( .IN1(n147), .IN2(n146), .IN3(n147), .IN4(n159), .IN5(n169), 
        .Q(n148) );
  NAND4X0 U184 ( .IN1(n151), .IN2(n150), .IN3(n149), .IN4(n148), .QN(n90) );
  OA21X1 U185 ( .IN1(in[0]), .IN2(n152), .IN3(in[7]), .Q(n154) );
  OA22X1 U186 ( .IN1(state[3]), .IN2(n155), .IN3(n154), .IN4(n153), .Q(n173)
         );
  NAND3X0 U187 ( .IN1(n158), .IN2(n157), .IN3(n156), .QN(n162) );
  OA221X1 U188 ( .IN1(n182), .IN2(n160), .IN3(n182), .IN4(n159), .IN5(n184), 
        .Q(n161) );
  OA221X1 U189 ( .IN1(n164), .IN2(n163), .IN3(n164), .IN4(n162), .IN5(n161), 
        .Q(n170) );
  AND3X1 U190 ( .IN1(n167), .IN2(n166), .IN3(n165), .Q(n168) );
  OA22X1 U191 ( .IN1(n170), .IN2(n169), .IN3(n168), .IN4(n183), .Q(n171) );
  OA221X1 U192 ( .IN1(n174), .IN2(n173), .IN3(n174), .IN4(n172), .IN5(n171), 
        .Q(n181) );
  NAND4X0 U193 ( .IN1(state[2]), .IN2(n176), .IN3(n183), .IN4(n175), .QN(n179)
         );
  NAND3X0 U194 ( .IN1(in[7]), .IN2(n177), .IN3(n183), .QN(n178) );
  NAND4X0 U195 ( .IN1(n181), .IN2(n180), .IN3(n179), .IN4(n178), .QN(n89) );
endmodule

