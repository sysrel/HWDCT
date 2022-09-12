/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Mon Sep 20 17:09:39 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module APB_SLAVE ( PCLK, PRESETn, PADDR, PWRITE, PSEL, PENABLE, PWDATA, PRDATA, 
        PREADY, TrFr, SPI_CR_1, SPI_CR_2, SPI_BR_R, SPI_ST_R, SPI_DATA_Reg_1, 
        SPI_DATA_Reg_2, SPI_DATA_Reg_3, SPI_DATA_Reg_4 );
  input [2:0] PADDR;
  input [7:0] PWDATA;
  output [7:0] PRDATA;
  output [7:0] SPI_CR_1;
  output [7:0] SPI_CR_2;
  output [7:0] SPI_BR_R;
  output [7:0] SPI_ST_R;
  output [7:0] SPI_DATA_Reg_1;
  output [7:0] SPI_DATA_Reg_2;
  output [7:0] SPI_DATA_Reg_3;
  output [7:0] SPI_DATA_Reg_4;
  input PCLK, PRESETn, PWRITE, PSEL, PENABLE, TrFr;
  output PREADY;
  wire   outTrojan_ena, N25, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107,
         n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, n118,
         n119, n120, n121, n122, n123, n124, n125, n126, n127, n128, n129,
         n130, n131, n132, n133, n134, n135, n136, n137, n138, n139, n140,
         n141, n142, n143, n144, n145, n146, n147, n148, n149, n150, n151,
         n152, n153, n154, n155, n156, n157, n158, n159, n160, n161, n162,
         n163, n164, n165, n166, n167, n168, n169, n170, n171, n172, n173,
         n174, n175, n176, n177, n178, n179, n180, n181, n182, n183, n184,
         n185, n186, n187, n188, n189, n190, n191, n192, n193, n194, n195,
         n196, n197, n198, n199, n200, n201, n202, n203, n204, n205, n206,
         n207, n208, n209, n210, n211, n212, n213, n214, n215, n216, n217,
         n218, n219/*, n220*/;
  reg    [1:0] STATE/*verilator public*/;
  wire   [1:0] trojan_state;
  reg	  n220;

always @(posedge PCLK) 
begin
 if(PRESETn==1'b0)
  begin
  STATE[0] = 1'b0;
  STATE[1] = 1'b0;
  end
 else 
  begin
  STATE[0] = n147;
  n220 = ~n147;
  STATE[1] = n146;
  end
end

  //DFFARX1 \STATE_reg[0]  ( .D(n147), .CLK(PCLK), .RSTB(PRESETn), .Q(STATE[0]), .QN(n220) );
  //DFFARX1 \STATE_reg[1]  ( .D(n146), .CLK(PCLK), .RSTB(PRESETn), .Q(STATE[1]),  .QN() );
  DFFARX1 \trojan_state_reg[0]  ( .D(n145), .CLK(PCLK), .RSTB(PRESETn), .Q(
        trojan_state[0]), .QN() );
  DFFARX1 \trojan_state_reg[1]  ( .D(n144), .CLK(PCLK), .RSTB(PRESETn), .Q(
        trojan_state[1]), .QN(n219) );
  DFFARX1 outTrojan_ena_reg ( .D(n148), .CLK(PCLK), .RSTB(PRESETn), .Q(
        outTrojan_ena), .QN() );
  DFFARX1 PREADY_reg ( .D(N25), .CLK(PCLK), .RSTB(PRESETn), .Q(PREADY), .QN()
         );
  DFFARX1 \SPI_DATA_Reg_4_reg[7]  ( .D(n143), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[7]), .QN() );
  DFFARX1 \SPI_DATA_Reg_4_reg[6]  ( .D(n142), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[6]), .QN() );
  DFFARX1 \SPI_DATA_Reg_4_reg[5]  ( .D(n141), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[5]), .QN() );
  DFFARX1 \SPI_DATA_Reg_4_reg[4]  ( .D(n140), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[4]), .QN() );
  DFFARX1 \SPI_DATA_Reg_4_reg[3]  ( .D(n139), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[3]), .QN() );
  DFFARX1 \SPI_DATA_Reg_4_reg[2]  ( .D(n138), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[2]), .QN() );
  DFFARX1 \SPI_DATA_Reg_4_reg[1]  ( .D(n137), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[1]), .QN() );
  DFFARX1 \SPI_DATA_Reg_4_reg[0]  ( .D(n136), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[0]), .QN() );
  DFFARX1 \SPI_DATA_Reg_3_reg[7]  ( .D(n135), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[7]), .QN() );
  DFFARX1 \SPI_DATA_Reg_3_reg[6]  ( .D(n134), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[6]), .QN() );
  DFFARX1 \SPI_DATA_Reg_3_reg[5]  ( .D(n133), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[5]), .QN() );
  DFFARX1 \SPI_DATA_Reg_3_reg[4]  ( .D(n132), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[4]), .QN() );
  DFFARX1 \SPI_DATA_Reg_3_reg[3]  ( .D(n131), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[3]), .QN() );
  DFFARX1 \SPI_DATA_Reg_3_reg[2]  ( .D(n130), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[2]), .QN() );
  DFFARX1 \SPI_DATA_Reg_3_reg[1]  ( .D(n129), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[1]), .QN() );
  DFFARX1 \SPI_DATA_Reg_3_reg[0]  ( .D(n128), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[0]), .QN() );
  DFFARX1 \SPI_DATA_Reg_2_reg[7]  ( .D(n127), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[7]), .QN() );
  DFFARX1 \SPI_DATA_Reg_2_reg[6]  ( .D(n126), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[6]), .QN() );
  DFFARX1 \SPI_DATA_Reg_2_reg[5]  ( .D(n125), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[5]), .QN() );
  DFFARX1 \SPI_DATA_Reg_2_reg[4]  ( .D(n124), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[4]), .QN() );
  DFFARX1 \SPI_DATA_Reg_2_reg[3]  ( .D(n123), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[3]), .QN() );
  DFFARX1 \SPI_DATA_Reg_2_reg[2]  ( .D(n122), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[2]), .QN() );
  DFFARX1 \SPI_DATA_Reg_2_reg[1]  ( .D(n121), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[1]), .QN() );
  DFFARX1 \SPI_DATA_Reg_2_reg[0]  ( .D(n120), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[0]), .QN() );
  DFFARX1 \SPI_DATA_Reg_1_reg[7]  ( .D(n119), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[7]), .QN() );
  DFFARX1 \SPI_DATA_Reg_1_reg[6]  ( .D(n118), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[6]), .QN() );
  DFFARX1 \SPI_DATA_Reg_1_reg[5]  ( .D(n117), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[5]), .QN() );
  DFFARX1 \SPI_DATA_Reg_1_reg[4]  ( .D(n116), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[4]), .QN() );
  DFFARX1 \SPI_DATA_Reg_1_reg[3]  ( .D(n115), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[3]), .QN() );
  DFFARX1 \SPI_DATA_Reg_1_reg[2]  ( .D(n114), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[2]), .QN() );
  DFFARX1 \SPI_DATA_Reg_1_reg[1]  ( .D(n113), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[1]), .QN() );
  DFFARX1 \SPI_DATA_Reg_1_reg[0]  ( .D(n112), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[0]), .QN() );
  DFFARX1 \SPI_ST_R_reg[7]  ( .D(n111), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[7]), .QN() );
  DFFARX1 \SPI_ST_R_reg[6]  ( .D(n110), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[6]), .QN() );
  DFFARX1 \SPI_ST_R_reg[5]  ( .D(n109), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[5]), .QN() );
  DFFARX1 \SPI_ST_R_reg[4]  ( .D(n108), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[4]), .QN() );
  DFFARX1 \SPI_ST_R_reg[3]  ( .D(n107), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[3]), .QN() );
  DFFARX1 \SPI_ST_R_reg[2]  ( .D(n106), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[2]), .QN() );
  DFFARX1 \SPI_ST_R_reg[1]  ( .D(n105), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[1]), .QN() );
  DFFARX1 \SPI_ST_R_reg[0]  ( .D(n104), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[0]), .QN() );
  DFFARX1 \SPI_BR_R_reg[7]  ( .D(n103), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[7]), .QN() );
  DFFARX1 \SPI_BR_R_reg[6]  ( .D(n102), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[6]), .QN() );
  DFFARX1 \SPI_BR_R_reg[5]  ( .D(n101), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[5]), .QN() );
  DFFARX1 \SPI_BR_R_reg[4]  ( .D(n100), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[4]), .QN() );
  DFFARX1 \SPI_BR_R_reg[3]  ( .D(n99), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[3]), .QN() );
  DFFARX1 \SPI_BR_R_reg[2]  ( .D(n98), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[2]), .QN() );
  DFFARX1 \SPI_BR_R_reg[1]  ( .D(n97), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[1]), .QN() );
  DFFARX1 \SPI_BR_R_reg[0]  ( .D(n96), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[0]), .QN() );
  DFFARX1 \SPI_CR_2_reg[7]  ( .D(n95), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[7]), .QN() );
  DFFARX1 \SPI_CR_2_reg[6]  ( .D(n94), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[6]), .QN() );
  DFFARX1 \SPI_CR_2_reg[5]  ( .D(n93), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[5]), .QN() );
  DFFARX1 \SPI_CR_2_reg[4]  ( .D(n92), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[4]), .QN() );
  DFFARX1 \SPI_CR_2_reg[3]  ( .D(n91), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[3]), .QN() );
  DFFARX1 \SPI_CR_2_reg[2]  ( .D(n90), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[2]), .QN() );
  DFFARX1 \SPI_CR_2_reg[1]  ( .D(n89), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[1]), .QN() );
  DFFARX1 \SPI_CR_2_reg[0]  ( .D(n88), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[0]), .QN() );
  DFFARX1 \SPI_CR_1_reg[7]  ( .D(n87), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[7]), .QN() );
  DFFARX1 \SPI_CR_1_reg[6]  ( .D(n86), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[6]), .QN() );
  DFFARX1 \SPI_CR_1_reg[5]  ( .D(n85), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[5]), .QN() );
  DFFARX1 \SPI_CR_1_reg[4]  ( .D(n84), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[4]), .QN() );
  DFFARX1 \SPI_CR_1_reg[3]  ( .D(n83), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[3]), .QN() );
  DFFARX1 \SPI_CR_1_reg[2]  ( .D(n82), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[2]), .QN() );
  DFFARX1 \SPI_CR_1_reg[1]  ( .D(n81), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[1]), .QN() );
  DFFARX1 \SPI_CR_1_reg[0]  ( .D(n80), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[0]), .QN() );
  DFFARX1 \PRDATA_reg[7]  ( .D(n79), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[7]), 
        .QN() );
  DFFARX1 \PRDATA_reg[6]  ( .D(n78), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[6]), 
        .QN() );
  DFFARX1 \PRDATA_reg[5]  ( .D(n77), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[5]), 
        .QN() );
  DFFARX1 \PRDATA_reg[4]  ( .D(n76), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[4]), 
        .QN() );
  DFFARX1 \PRDATA_reg[3]  ( .D(n75), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[3]), 
        .QN() );
  DFFARX1 \PRDATA_reg[2]  ( .D(n74), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[2]), 
        .QN() );
  DFFARX1 \PRDATA_reg[1]  ( .D(n73), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[1]), 
        .QN() );
  DFFARX1 \PRDATA_reg[0]  ( .D(n72), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[0]), 
        .QN() );
  NAND2X0 U152 ( .IN1(PADDR[1]), .IN2(n153), .QN(n149) );
  NAND2X0 U153 ( .IN1(n202), .IN2(n169), .QN(n170) );
  NAND2X0 U154 ( .IN1(n207), .IN2(n169), .QN(n162) );
  NAND2X0 U155 ( .IN1(n159), .IN2(n218), .QN(n146) );
  NAND2X0 U156 ( .IN1(STATE[0]), .IN2(PENABLE), .QN(n159) );
  NAND2X0 U157 ( .IN1(STATE[0]), .IN2(STATE[1]), .QN(n218) );
  INVX0 U158 ( .INP(PADDR[0]), .ZN(n154) );
  INVX0 U159 ( .INP(PADDR[2]), .ZN(n153) );
  INVX0 U160 ( .INP(PADDR[1]), .ZN(n152) );
  AND3X1 U161 ( .IN1(n154), .IN2(n153), .IN3(n152), .Q(n202) );
  AND3X1 U162 ( .IN1(n153), .IN2(n152), .IN3(PADDR[0]), .Q(n201) );
  AO22X1 U163 ( .IN1(n202), .IN2(SPI_CR_1[0]), .IN3(n201), .IN4(SPI_CR_2[0]), 
        .Q(n158) );
  NOR2X0 U164 ( .IN1(PADDR[0]), .IN2(n149), .QN(n204) );
  NOR3X0 U165 ( .IN1(n154), .IN2(n152), .IN3(PADDR[2]), .QN(n203) );
  AO22X1 U166 ( .IN1(n204), .IN2(SPI_BR_R[0]), .IN3(n203), .IN4(SPI_ST_R[0]), 
        .Q(n157) );
  NAND2X0 U167 ( .IN1(PADDR[2]), .IN2(n152), .QN(n150) );
  NOR2X0 U168 ( .IN1(PADDR[0]), .IN2(n150), .QN(n206) );
  NOR3X0 U169 ( .IN1(n153), .IN2(n154), .IN3(PADDR[1]), .QN(n205) );
  AO22X1 U170 ( .IN1(n206), .IN2(SPI_DATA_Reg_1[0]), .IN3(n205), .IN4(
        SPI_DATA_Reg_2[0]), .Q(n156) );
  NAND2X0 U171 ( .IN1(PADDR[2]), .IN2(PADDR[1]), .QN(n151) );
  NOR2X0 U172 ( .IN1(PADDR[0]), .IN2(n151), .QN(n208) );
  NOR3X0 U173 ( .IN1(n154), .IN2(n153), .IN3(n152), .QN(n207) );
  AO22X1 U174 ( .IN1(n208), .IN2(SPI_DATA_Reg_3[0]), .IN3(n207), .IN4(
        SPI_DATA_Reg_4[0]), .Q(n155) );
  OR4X1 U175 ( .IN1(n158), .IN2(n157), .IN3(n156), .IN4(n155), .Q(n160) );
  NOR3X0 U176 ( .IN1(PWRITE), .IN2(STATE[1]), .IN3(n159), .QN(n213) );
  MUX21X1 U177 ( .IN1(PRDATA[0]), .IN2(n160), .S(n213), .Q(n72) );
  INVX0 U178 ( .INP(n218), .ZN(n161) );
  MUX21X1 U179 ( .IN1(trojan_state[0]), .IN2(n161), .S(n219), .Q(n145) );
  AND3X1 U180 ( .IN1(PWRITE), .IN2(STATE[1]), .IN3(n220), .Q(n169) );
  MUX21X1 U181 ( .IN1(PWDATA[7]), .IN2(SPI_DATA_Reg_4[7]), .S(n162), .Q(n143)
         );
  MUX21X1 U182 ( .IN1(PWDATA[6]), .IN2(SPI_DATA_Reg_4[6]), .S(n162), .Q(n142)
         );
  MUX21X1 U183 ( .IN1(PWDATA[5]), .IN2(SPI_DATA_Reg_4[5]), .S(n162), .Q(n141)
         );
  MUX21X1 U184 ( .IN1(PWDATA[4]), .IN2(SPI_DATA_Reg_4[4]), .S(n162), .Q(n140)
         );
  MUX21X1 U185 ( .IN1(PWDATA[3]), .IN2(SPI_DATA_Reg_4[3]), .S(n162), .Q(n139)
         );
  MUX21X1 U186 ( .IN1(PWDATA[2]), .IN2(SPI_DATA_Reg_4[2]), .S(n162), .Q(n138)
         );
  MUX21X1 U187 ( .IN1(PWDATA[1]), .IN2(SPI_DATA_Reg_4[1]), .S(n162), .Q(n137)
         );
  MUX21X1 U188 ( .IN1(PWDATA[0]), .IN2(SPI_DATA_Reg_4[0]), .S(n162), .Q(n136)
         );
  NAND2X0 U189 ( .IN1(n208), .IN2(n169), .QN(n163) );
  MUX21X1 U190 ( .IN1(PWDATA[7]), .IN2(SPI_DATA_Reg_3[7]), .S(n163), .Q(n135)
         );
  MUX21X1 U191 ( .IN1(PWDATA[6]), .IN2(SPI_DATA_Reg_3[6]), .S(n163), .Q(n134)
         );
  MUX21X1 U192 ( .IN1(PWDATA[5]), .IN2(SPI_DATA_Reg_3[5]), .S(n163), .Q(n133)
         );
  MUX21X1 U193 ( .IN1(PWDATA[4]), .IN2(SPI_DATA_Reg_3[4]), .S(n163), .Q(n132)
         );
  MUX21X1 U194 ( .IN1(PWDATA[3]), .IN2(SPI_DATA_Reg_3[3]), .S(n163), .Q(n131)
         );
  MUX21X1 U195 ( .IN1(PWDATA[2]), .IN2(SPI_DATA_Reg_3[2]), .S(n163), .Q(n130)
         );
  MUX21X1 U196 ( .IN1(PWDATA[1]), .IN2(SPI_DATA_Reg_3[1]), .S(n163), .Q(n129)
         );
  MUX21X1 U197 ( .IN1(PWDATA[0]), .IN2(SPI_DATA_Reg_3[0]), .S(n163), .Q(n128)
         );
  NAND2X0 U198 ( .IN1(n205), .IN2(n169), .QN(n164) );
  MUX21X1 U199 ( .IN1(PWDATA[7]), .IN2(SPI_DATA_Reg_2[7]), .S(n164), .Q(n127)
         );
  MUX21X1 U200 ( .IN1(PWDATA[6]), .IN2(SPI_DATA_Reg_2[6]), .S(n164), .Q(n126)
         );
  MUX21X1 U201 ( .IN1(PWDATA[5]), .IN2(SPI_DATA_Reg_2[5]), .S(n164), .Q(n125)
         );
  MUX21X1 U202 ( .IN1(PWDATA[4]), .IN2(SPI_DATA_Reg_2[4]), .S(n164), .Q(n124)
         );
  MUX21X1 U203 ( .IN1(PWDATA[3]), .IN2(SPI_DATA_Reg_2[3]), .S(n164), .Q(n123)
         );
  MUX21X1 U204 ( .IN1(PWDATA[2]), .IN2(SPI_DATA_Reg_2[2]), .S(n164), .Q(n122)
         );
  MUX21X1 U205 ( .IN1(PWDATA[1]), .IN2(SPI_DATA_Reg_2[1]), .S(n164), .Q(n121)
         );
  MUX21X1 U206 ( .IN1(PWDATA[0]), .IN2(SPI_DATA_Reg_2[0]), .S(n164), .Q(n120)
         );
  NAND2X0 U207 ( .IN1(n206), .IN2(n169), .QN(n165) );
  MUX21X1 U208 ( .IN1(PWDATA[7]), .IN2(SPI_DATA_Reg_1[7]), .S(n165), .Q(n119)
         );
  MUX21X1 U209 ( .IN1(PWDATA[6]), .IN2(SPI_DATA_Reg_1[6]), .S(n165), .Q(n118)
         );
  MUX21X1 U210 ( .IN1(PWDATA[5]), .IN2(SPI_DATA_Reg_1[5]), .S(n165), .Q(n117)
         );
  MUX21X1 U211 ( .IN1(PWDATA[4]), .IN2(SPI_DATA_Reg_1[4]), .S(n165), .Q(n116)
         );
  MUX21X1 U212 ( .IN1(PWDATA[3]), .IN2(SPI_DATA_Reg_1[3]), .S(n165), .Q(n115)
         );
  MUX21X1 U213 ( .IN1(PWDATA[2]), .IN2(SPI_DATA_Reg_1[2]), .S(n165), .Q(n114)
         );
  MUX21X1 U214 ( .IN1(PWDATA[1]), .IN2(SPI_DATA_Reg_1[1]), .S(n165), .Q(n113)
         );
  MUX21X1 U215 ( .IN1(PWDATA[0]), .IN2(SPI_DATA_Reg_1[0]), .S(n165), .Q(n112)
         );
  NAND2X0 U216 ( .IN1(n203), .IN2(n169), .QN(n166) );
  MUX21X1 U217 ( .IN1(PWDATA[7]), .IN2(SPI_ST_R[7]), .S(n166), .Q(n111) );
  MUX21X1 U218 ( .IN1(PWDATA[6]), .IN2(SPI_ST_R[6]), .S(n166), .Q(n110) );
  MUX21X1 U219 ( .IN1(PWDATA[5]), .IN2(SPI_ST_R[5]), .S(n166), .Q(n109) );
  MUX21X1 U220 ( .IN1(PWDATA[4]), .IN2(SPI_ST_R[4]), .S(n166), .Q(n108) );
  MUX21X1 U221 ( .IN1(PWDATA[3]), .IN2(SPI_ST_R[3]), .S(n166), .Q(n107) );
  MUX21X1 U222 ( .IN1(PWDATA[2]), .IN2(SPI_ST_R[2]), .S(n166), .Q(n106) );
  MUX21X1 U223 ( .IN1(PWDATA[1]), .IN2(SPI_ST_R[1]), .S(n166), .Q(n105) );
  MUX21X1 U224 ( .IN1(PWDATA[0]), .IN2(SPI_ST_R[0]), .S(n166), .Q(n104) );
  NAND2X0 U225 ( .IN1(n204), .IN2(n169), .QN(n167) );
  MUX21X1 U226 ( .IN1(PWDATA[7]), .IN2(SPI_BR_R[7]), .S(n167), .Q(n103) );
  MUX21X1 U227 ( .IN1(PWDATA[6]), .IN2(SPI_BR_R[6]), .S(n167), .Q(n102) );
  MUX21X1 U228 ( .IN1(PWDATA[5]), .IN2(SPI_BR_R[5]), .S(n167), .Q(n101) );
  MUX21X1 U229 ( .IN1(PWDATA[4]), .IN2(SPI_BR_R[4]), .S(n167), .Q(n100) );
  MUX21X1 U230 ( .IN1(PWDATA[3]), .IN2(SPI_BR_R[3]), .S(n167), .Q(n99) );
  MUX21X1 U231 ( .IN1(PWDATA[2]), .IN2(SPI_BR_R[2]), .S(n167), .Q(n98) );
  MUX21X1 U232 ( .IN1(PWDATA[1]), .IN2(SPI_BR_R[1]), .S(n167), .Q(n97) );
  MUX21X1 U233 ( .IN1(PWDATA[0]), .IN2(SPI_BR_R[0]), .S(n167), .Q(n96) );
  NAND2X0 U234 ( .IN1(n201), .IN2(n169), .QN(n168) );
  MUX21X1 U235 ( .IN1(PWDATA[7]), .IN2(SPI_CR_2[7]), .S(n168), .Q(n95) );
  MUX21X1 U236 ( .IN1(PWDATA[6]), .IN2(SPI_CR_2[6]), .S(n168), .Q(n94) );
  MUX21X1 U237 ( .IN1(PWDATA[5]), .IN2(SPI_CR_2[5]), .S(n168), .Q(n93) );
  MUX21X1 U238 ( .IN1(PWDATA[4]), .IN2(SPI_CR_2[4]), .S(n168), .Q(n92) );
  MUX21X1 U239 ( .IN1(PWDATA[3]), .IN2(SPI_CR_2[3]), .S(n168), .Q(n91) );
  MUX21X1 U240 ( .IN1(PWDATA[2]), .IN2(SPI_CR_2[2]), .S(n168), .Q(n90) );
  MUX21X1 U241 ( .IN1(PWDATA[1]), .IN2(SPI_CR_2[1]), .S(n168), .Q(n89) );
  MUX21X1 U242 ( .IN1(PWDATA[0]), .IN2(SPI_CR_2[0]), .S(n168), .Q(n88) );
  MUX21X1 U243 ( .IN1(PWDATA[7]), .IN2(SPI_CR_1[7]), .S(n170), .Q(n87) );
  MUX21X1 U244 ( .IN1(PWDATA[6]), .IN2(SPI_CR_1[6]), .S(n170), .Q(n86) );
  MUX21X1 U245 ( .IN1(PWDATA[5]), .IN2(SPI_CR_1[5]), .S(n170), .Q(n85) );
  MUX21X1 U246 ( .IN1(PWDATA[4]), .IN2(SPI_CR_1[4]), .S(n170), .Q(n84) );
  MUX21X1 U247 ( .IN1(PWDATA[3]), .IN2(SPI_CR_1[3]), .S(n170), .Q(n83) );
  MUX21X1 U248 ( .IN1(PWDATA[2]), .IN2(SPI_CR_1[2]), .S(n170), .Q(n82) );
  MUX21X1 U249 ( .IN1(PWDATA[1]), .IN2(SPI_CR_1[1]), .S(n170), .Q(n81) );
  MUX21X1 U250 ( .IN1(PWDATA[0]), .IN2(SPI_CR_1[0]), .S(n170), .Q(n80) );
  AO22X1 U251 ( .IN1(n202), .IN2(SPI_CR_1[7]), .IN3(n201), .IN4(SPI_CR_2[7]), 
        .Q(n174) );
  AO22X1 U252 ( .IN1(n204), .IN2(SPI_BR_R[7]), .IN3(n203), .IN4(SPI_ST_R[7]), 
        .Q(n173) );
  AO22X1 U253 ( .IN1(n206), .IN2(SPI_DATA_Reg_1[7]), .IN3(n205), .IN4(
        SPI_DATA_Reg_2[7]), .Q(n172) );
  AO22X1 U254 ( .IN1(n208), .IN2(SPI_DATA_Reg_3[7]), .IN3(n207), .IN4(
        SPI_DATA_Reg_4[7]), .Q(n171) );
  OR4X1 U255 ( .IN1(n174), .IN2(n173), .IN3(n172), .IN4(n171), .Q(n175) );
  MUX21X1 U256 ( .IN1(PRDATA[7]), .IN2(n175), .S(n213), .Q(n79) );
  AO22X1 U257 ( .IN1(n202), .IN2(SPI_CR_1[6]), .IN3(n201), .IN4(SPI_CR_2[6]), 
        .Q(n179) );
  AO22X1 U258 ( .IN1(n204), .IN2(SPI_BR_R[6]), .IN3(n203), .IN4(SPI_ST_R[6]), 
        .Q(n178) );
  AO22X1 U259 ( .IN1(n206), .IN2(SPI_DATA_Reg_1[6]), .IN3(n205), .IN4(
        SPI_DATA_Reg_2[6]), .Q(n177) );
  AO22X1 U260 ( .IN1(n208), .IN2(SPI_DATA_Reg_3[6]), .IN3(n207), .IN4(
        SPI_DATA_Reg_4[6]), .Q(n176) );
  OR4X1 U261 ( .IN1(n179), .IN2(n178), .IN3(n177), .IN4(n176), .Q(n180) );
  MUX21X1 U262 ( .IN1(PRDATA[6]), .IN2(n180), .S(n213), .Q(n78) );
  AO22X1 U263 ( .IN1(n202), .IN2(SPI_CR_1[5]), .IN3(n201), .IN4(SPI_CR_2[5]), 
        .Q(n184) );
  AO22X1 U264 ( .IN1(n204), .IN2(SPI_BR_R[5]), .IN3(n203), .IN4(SPI_ST_R[5]), 
        .Q(n183) );
  AO22X1 U265 ( .IN1(n206), .IN2(SPI_DATA_Reg_1[5]), .IN3(n205), .IN4(
        SPI_DATA_Reg_2[5]), .Q(n182) );
  AO22X1 U266 ( .IN1(n208), .IN2(SPI_DATA_Reg_3[5]), .IN3(n207), .IN4(
        SPI_DATA_Reg_4[5]), .Q(n181) );
  OR4X1 U267 ( .IN1(n184), .IN2(n183), .IN3(n182), .IN4(n181), .Q(n185) );
  MUX21X1 U268 ( .IN1(PRDATA[5]), .IN2(n185), .S(n213), .Q(n77) );
  AO22X1 U269 ( .IN1(n202), .IN2(SPI_CR_1[4]), .IN3(n201), .IN4(SPI_CR_2[4]), 
        .Q(n189) );
  AO22X1 U270 ( .IN1(n204), .IN2(SPI_BR_R[4]), .IN3(n203), .IN4(SPI_ST_R[4]), 
        .Q(n188) );
  AO22X1 U271 ( .IN1(n206), .IN2(SPI_DATA_Reg_1[4]), .IN3(n205), .IN4(
        SPI_DATA_Reg_2[4]), .Q(n187) );
  AO22X1 U272 ( .IN1(n208), .IN2(SPI_DATA_Reg_3[4]), .IN3(n207), .IN4(
        SPI_DATA_Reg_4[4]), .Q(n186) );
  OR4X1 U273 ( .IN1(n189), .IN2(n188), .IN3(n187), .IN4(n186), .Q(n190) );
  MUX21X1 U274 ( .IN1(PRDATA[4]), .IN2(n190), .S(n213), .Q(n76) );
  AO22X1 U275 ( .IN1(n202), .IN2(SPI_CR_1[3]), .IN3(n201), .IN4(SPI_CR_2[3]), 
        .Q(n194) );
  AO22X1 U276 ( .IN1(n204), .IN2(SPI_BR_R[3]), .IN3(n203), .IN4(SPI_ST_R[3]), 
        .Q(n193) );
  AO22X1 U277 ( .IN1(n206), .IN2(SPI_DATA_Reg_1[3]), .IN3(n205), .IN4(
        SPI_DATA_Reg_2[3]), .Q(n192) );
  AO22X1 U278 ( .IN1(n208), .IN2(SPI_DATA_Reg_3[3]), .IN3(n207), .IN4(
        SPI_DATA_Reg_4[3]), .Q(n191) );
  OR4X1 U279 ( .IN1(n194), .IN2(n193), .IN3(n192), .IN4(n191), .Q(n195) );
  MUX21X1 U280 ( .IN1(PRDATA[3]), .IN2(n195), .S(n213), .Q(n75) );
  AO22X1 U281 ( .IN1(n202), .IN2(SPI_CR_1[2]), .IN3(n201), .IN4(SPI_CR_2[2]), 
        .Q(n199) );
  AO22X1 U282 ( .IN1(n204), .IN2(SPI_BR_R[2]), .IN3(n203), .IN4(SPI_ST_R[2]), 
        .Q(n198) );
  AO22X1 U283 ( .IN1(n206), .IN2(SPI_DATA_Reg_1[2]), .IN3(n205), .IN4(
        SPI_DATA_Reg_2[2]), .Q(n197) );
  AO22X1 U284 ( .IN1(n208), .IN2(SPI_DATA_Reg_3[2]), .IN3(n207), .IN4(
        SPI_DATA_Reg_4[2]), .Q(n196) );
  OR4X1 U285 ( .IN1(n199), .IN2(n198), .IN3(n197), .IN4(n196), .Q(n200) );
  MUX21X1 U286 ( .IN1(PRDATA[2]), .IN2(n200), .S(n213), .Q(n74) );
  AO22X1 U287 ( .IN1(n202), .IN2(SPI_CR_1[1]), .IN3(n201), .IN4(SPI_CR_2[1]), 
        .Q(n212) );
  AO22X1 U288 ( .IN1(n204), .IN2(SPI_BR_R[1]), .IN3(n203), .IN4(SPI_ST_R[1]), 
        .Q(n211) );
  AO22X1 U289 ( .IN1(n206), .IN2(SPI_DATA_Reg_1[1]), .IN3(n205), .IN4(
        SPI_DATA_Reg_2[1]), .Q(n210) );
  AO22X1 U290 ( .IN1(n208), .IN2(SPI_DATA_Reg_3[1]), .IN3(n207), .IN4(
        SPI_DATA_Reg_4[1]), .Q(n209) );
  OR4X1 U291 ( .IN1(n212), .IN2(n211), .IN3(n210), .IN4(n209), .Q(n214) );
  MUX21X1 U292 ( .IN1(PRDATA[1]), .IN2(n214), .S(n213), .Q(n73) );
  NOR2X0 U293 ( .IN1(STATE[0]), .IN2(STATE[1]), .QN(n217) );
  INVX0 U294 ( .INP(n217), .ZN(n215) );
  NOR2X0 U295 ( .IN1(outTrojan_ena), .IN2(n215), .QN(N25) );
  NOR2X0 U296 ( .IN1(trojan_state[0]), .IN2(n219), .QN(n148) );
  OA21X1 U297 ( .IN1(STATE[0]), .IN2(PENABLE), .IN3(STATE[1]), .Q(n216) );
  AO21X1 U298 ( .IN1(n217), .IN2(TrFr), .IN3(n216), .Q(n147) );
  AO21X1 U299 ( .IN1(trojan_state[0]), .IN2(n218), .IN3(trojan_state[1]), .Q(
        n144) );
endmodule

