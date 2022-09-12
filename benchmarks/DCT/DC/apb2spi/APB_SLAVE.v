/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Fri Jun 11 13:46:28 2021
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
  wire   n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80,
         n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94,
         n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106,
         n107, n108, n109, n110, n111, n112, n113, n114, n115, n116, n117,
         n118, n119, n120, n121, n122, n123, n124, n125, n126, n127, n128,
         n129, n130, n131, n132, n133, n134, n135, n136, n137, n138, n139,
         n140, n141, n142, n143, n144, n145, n146, n147, n148, n149, n150,
         n151, n152, n153, n154, n155, n156, n157, n158, n159, n160, n161,
         n162, n163, n164, n165, n166, n167, n168, n169, n170, n171, n172,
         n173, n174, n175, n176, n177, n178, n179, n180, n181, n182, n183,
         n184, n185, n186, n187, n188, n189, n190, n191, n192, n193, n194,
         n195, n196, n197, n198, n199, n200, n201, n202, n203, n204, n205,
         n206/*, n207*/;
  reg   [1:0] STATE/*verilator public*/;
  reg	n207;
always @(posedge PCLK) 
begin
 if(PRESETn==1'b0)
  begin
  STATE[0] = 1'b0;
  STATE[1] = 1'b0;
  end
 else 
  begin
  STATE[0] = n139;
  n207 = ~n139;
  STATE[1] = n140;
  end
end

  //DFFARX1 \STATE_reg[1]  ( .D(n140), .CLK(PCLK), .RSTB(PRESETn), .Q(STATE[1]));
  DFFARX1 PREADY_reg ( .D(n141), .CLK(PCLK), .RSTB(PRESETn), .Q(PREADY) );
  //DFFARX1 \STATE_reg[0]  ( .D(n139), .CLK(PCLK), .RSTB(PRESETn), .Q(STATE[0]), QN(n207) );
  DFFARX1 \PRDATA_reg[0]  ( .D(n138), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[0]) );
  DFFARX1 \PRDATA_reg[1]  ( .D(n137), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[1]) );
  DFFARX1 \PRDATA_reg[2]  ( .D(n136), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[2]) );
  DFFARX1 \PRDATA_reg[3]  ( .D(n135), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[3]) );
  DFFARX1 \PRDATA_reg[4]  ( .D(n134), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[4]) );
  DFFARX1 \PRDATA_reg[5]  ( .D(n133), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[5]) );
  DFFARX1 \PRDATA_reg[6]  ( .D(n132), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[6]) );
  DFFARX1 \PRDATA_reg[7]  ( .D(n131), .CLK(PCLK), .RSTB(PRESETn), .Q(PRDATA[7]) );
  DFFARX1 \SPI_DATA_Reg_4_reg[0]  ( .D(n130), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[0]) );
  DFFARX1 \SPI_DATA_Reg_4_reg[1]  ( .D(n129), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[1]) );
  DFFARX1 \SPI_DATA_Reg_4_reg[2]  ( .D(n128), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[2]) );
  DFFARX1 \SPI_DATA_Reg_4_reg[3]  ( .D(n127), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[3]) );
  DFFARX1 \SPI_DATA_Reg_4_reg[4]  ( .D(n126), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[4]) );
  DFFARX1 \SPI_DATA_Reg_4_reg[5]  ( .D(n125), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[5]) );
  DFFARX1 \SPI_DATA_Reg_4_reg[6]  ( .D(n124), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[6]) );
  DFFARX1 \SPI_DATA_Reg_4_reg[7]  ( .D(n123), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_4[7]) );
  DFFARX1 \SPI_CR_1_reg[0]  ( .D(n122), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[0]) );
  DFFARX1 \SPI_CR_1_reg[1]  ( .D(n121), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[1]) );
  DFFARX1 \SPI_CR_1_reg[2]  ( .D(n120), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[2]) );
  DFFARX1 \SPI_CR_1_reg[3]  ( .D(n119), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[3]) );
  DFFARX1 \SPI_CR_1_reg[4]  ( .D(n118), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[4]) );
  DFFARX1 \SPI_CR_1_reg[5]  ( .D(n117), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[5]) );
  DFFARX1 \SPI_CR_1_reg[6]  ( .D(n116), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[6]) );
  DFFARX1 \SPI_CR_1_reg[7]  ( .D(n115), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_1[7]) );
  DFFARX1 \SPI_DATA_Reg_3_reg[0]  ( .D(n114), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[0]) );
  DFFARX1 \SPI_DATA_Reg_3_reg[1]  ( .D(n113), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[1]) );
  DFFARX1 \SPI_DATA_Reg_3_reg[2]  ( .D(n112), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[2]) );
  DFFARX1 \SPI_DATA_Reg_3_reg[3]  ( .D(n111), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[3]) );
  DFFARX1 \SPI_DATA_Reg_3_reg[4]  ( .D(n110), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[4]) );
  DFFARX1 \SPI_DATA_Reg_3_reg[5]  ( .D(n109), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[5]) );
  DFFARX1 \SPI_DATA_Reg_3_reg[6]  ( .D(n108), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[6]) );
  DFFARX1 \SPI_DATA_Reg_3_reg[7]  ( .D(n107), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_3[7]) );
  DFFARX1 \SPI_CR_2_reg[0]  ( .D(n106), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[0]) );
  DFFARX1 \SPI_CR_2_reg[1]  ( .D(n105), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[1]) );
  DFFARX1 \SPI_CR_2_reg[2]  ( .D(n104), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[2]) );
  DFFARX1 \SPI_CR_2_reg[3]  ( .D(n103), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[3]) );
  DFFARX1 \SPI_CR_2_reg[4]  ( .D(n102), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[4]) );
  DFFARX1 \SPI_CR_2_reg[5]  ( .D(n101), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[5]) );
  DFFARX1 \SPI_CR_2_reg[6]  ( .D(n100), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[6]) );
  DFFARX1 \SPI_CR_2_reg[7]  ( .D(n99), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_CR_2[7]) );
  DFFARX1 \SPI_DATA_Reg_2_reg[0]  ( .D(n98), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[0]) );
  DFFARX1 \SPI_DATA_Reg_2_reg[1]  ( .D(n97), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[1]) );
  DFFARX1 \SPI_DATA_Reg_2_reg[2]  ( .D(n96), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[2]) );
  DFFARX1 \SPI_DATA_Reg_2_reg[3]  ( .D(n95), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[3]) );
  DFFARX1 \SPI_DATA_Reg_2_reg[4]  ( .D(n94), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[4]) );
  DFFARX1 \SPI_DATA_Reg_2_reg[5]  ( .D(n93), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[5]) );
  DFFARX1 \SPI_DATA_Reg_2_reg[6]  ( .D(n92), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[6]) );
  DFFARX1 \SPI_DATA_Reg_2_reg[7]  ( .D(n91), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_2[7]) );
  DFFARX1 \SPI_BR_R_reg[0]  ( .D(n90), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[0]) );
  DFFARX1 \SPI_BR_R_reg[1]  ( .D(n89), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[1]) );
  DFFARX1 \SPI_BR_R_reg[2]  ( .D(n88), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[2]) );
  DFFARX1 \SPI_BR_R_reg[3]  ( .D(n87), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[3]) );
  DFFARX1 \SPI_BR_R_reg[4]  ( .D(n86), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[4]) );
  DFFARX1 \SPI_BR_R_reg[5]  ( .D(n85), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[5]) );
  DFFARX1 \SPI_BR_R_reg[6]  ( .D(n84), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[6]) );
  DFFARX1 \SPI_BR_R_reg[7]  ( .D(n83), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_BR_R[7]) );
  DFFARX1 \SPI_DATA_Reg_1_reg[0]  ( .D(n82), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[0]) );
  DFFARX1 \SPI_DATA_Reg_1_reg[1]  ( .D(n81), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[1]) );
  DFFARX1 \SPI_DATA_Reg_1_reg[2]  ( .D(n80), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[2]) );
  DFFARX1 \SPI_DATA_Reg_1_reg[3]  ( .D(n79), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[3]) );
  DFFARX1 \SPI_DATA_Reg_1_reg[4]  ( .D(n78), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[4]) );
  DFFARX1 \SPI_DATA_Reg_1_reg[5]  ( .D(n77), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[5]) );
  DFFARX1 \SPI_DATA_Reg_1_reg[6]  ( .D(n76), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[6]) );
  DFFARX1 \SPI_DATA_Reg_1_reg[7]  ( .D(n75), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_DATA_Reg_1[7]) );
  DFFARX1 \SPI_ST_R_reg[0]  ( .D(n74), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[0]) );
  DFFARX1 \SPI_ST_R_reg[1]  ( .D(n73), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[1]) );
  DFFARX1 \SPI_ST_R_reg[2]  ( .D(n72), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[2]) );
  DFFARX1 \SPI_ST_R_reg[3]  ( .D(n71), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[3]) );
  DFFARX1 \SPI_ST_R_reg[4]  ( .D(n70), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[4]) );
  DFFARX1 \SPI_ST_R_reg[5]  ( .D(n69), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[5]) );
  DFFARX1 \SPI_ST_R_reg[6]  ( .D(n68), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[6]) );
  DFFARX1 \SPI_ST_R_reg[7]  ( .D(n67), .CLK(PCLK), .RSTB(PRESETn), .Q(
        SPI_ST_R[7]) );
  NOR4X1 U144 ( .IN1(STATE[1]), .IN2(PWRITE), .IN3(n207), .IN4(n152), .QN(n189) );
  NAND2X0 U145 ( .IN1(PADDR[2]), .IN2(n146), .QN(n145) );
  NAND2X0 U146 ( .IN1(n184), .IN2(n203), .QN(n206) );
  NAND2X0 U147 ( .IN1(n191), .IN2(n203), .QN(n192) );
  INVX0 U148 ( .INP(PADDR[2]), .ZN(n143) );
  AND3X1 U149 ( .IN1(PADDR[0]), .IN2(PADDR[1]), .IN3(n143), .Q(n184) );
  AND3X1 U150 ( .IN1(STATE[1]), .IN2(PWRITE), .IN3(n207), .Q(n203) );
  MUX21X1 U151 ( .IN1(PWDATA[7]), .IN2(SPI_ST_R[7]), .S(n206), .Q(n67) );
  NOR2X0 U152 ( .IN1(STATE[1]), .IN2(STATE[0]), .QN(n141) );
  INVX0 U153 ( .INP(PENABLE), .ZN(n152) );
  NAND2X0 U154 ( .IN1(n207), .IN2(n152), .QN(n142) );
  AO22X1 U155 ( .IN1(STATE[1]), .IN2(n142), .IN3(n141), .IN4(TrFr), .Q(n139)
         );
  NAND2X0 U156 ( .IN1(PADDR[0]), .IN2(n143), .QN(n144) );
  NOR2X0 U157 ( .IN1(PADDR[1]), .IN2(n144), .QN(n197) );
  INVX0 U158 ( .INP(PADDR[1]), .ZN(n146) );
  NOR3X0 U159 ( .IN1(PADDR[2]), .IN2(PADDR[0]), .IN3(n146), .QN(n201) );
  AO22X1 U160 ( .IN1(n197), .IN2(SPI_CR_2[0]), .IN3(n201), .IN4(SPI_BR_R[0]), 
        .Q(n151) );
  NOR2X0 U161 ( .IN1(PADDR[0]), .IN2(n145), .QN(n204) );
  AO22X1 U162 ( .IN1(n184), .IN2(SPI_ST_R[0]), .IN3(n204), .IN4(
        SPI_DATA_Reg_1[0]), .Q(n150) );
  AND3X1 U163 ( .IN1(PADDR[0]), .IN2(PADDR[2]), .IN3(n146), .Q(n199) );
  NAND2X0 U164 ( .IN1(PADDR[2]), .IN2(PADDR[1]), .QN(n147) );
  NOR2X0 U165 ( .IN1(PADDR[0]), .IN2(n147), .QN(n195) );
  AO22X1 U166 ( .IN1(n199), .IN2(SPI_DATA_Reg_2[0]), .IN3(n195), .IN4(
        SPI_DATA_Reg_3[0]), .Q(n149) );
  AND3X1 U167 ( .IN1(PADDR[2]), .IN2(PADDR[0]), .IN3(PADDR[1]), .Q(n191) );
  NOR3X0 U168 ( .IN1(PADDR[2]), .IN2(PADDR[0]), .IN3(PADDR[1]), .QN(n193) );
  AO22X1 U169 ( .IN1(n191), .IN2(SPI_DATA_Reg_4[0]), .IN3(n193), .IN4(
        SPI_CR_1[0]), .Q(n148) );
  OR4X1 U170 ( .IN1(n151), .IN2(n150), .IN3(n149), .IN4(n148), .Q(n153) );
  MUX21X1 U171 ( .IN1(PRDATA[0]), .IN2(n153), .S(n189), .Q(n138) );
  AO22X1 U172 ( .IN1(n197), .IN2(SPI_CR_2[1]), .IN3(n201), .IN4(SPI_BR_R[1]), 
        .Q(n157) );
  AO22X1 U173 ( .IN1(n184), .IN2(SPI_ST_R[1]), .IN3(n204), .IN4(
        SPI_DATA_Reg_1[1]), .Q(n156) );
  AO22X1 U174 ( .IN1(n199), .IN2(SPI_DATA_Reg_2[1]), .IN3(n195), .IN4(
        SPI_DATA_Reg_3[1]), .Q(n155) );
  AO22X1 U175 ( .IN1(n191), .IN2(SPI_DATA_Reg_4[1]), .IN3(n193), .IN4(
        SPI_CR_1[1]), .Q(n154) );
  OR4X1 U176 ( .IN1(n157), .IN2(n156), .IN3(n155), .IN4(n154), .Q(n158) );
  MUX21X1 U177 ( .IN1(PRDATA[1]), .IN2(n158), .S(n189), .Q(n137) );
  AO22X1 U178 ( .IN1(n197), .IN2(SPI_CR_2[2]), .IN3(n201), .IN4(SPI_BR_R[2]), 
        .Q(n162) );
  AO22X1 U179 ( .IN1(n184), .IN2(SPI_ST_R[2]), .IN3(n204), .IN4(
        SPI_DATA_Reg_1[2]), .Q(n161) );
  AO22X1 U180 ( .IN1(n199), .IN2(SPI_DATA_Reg_2[2]), .IN3(n195), .IN4(
        SPI_DATA_Reg_3[2]), .Q(n160) );
  AO22X1 U181 ( .IN1(n191), .IN2(SPI_DATA_Reg_4[2]), .IN3(n193), .IN4(
        SPI_CR_1[2]), .Q(n159) );
  OR4X1 U182 ( .IN1(n162), .IN2(n161), .IN3(n160), .IN4(n159), .Q(n163) );
  MUX21X1 U183 ( .IN1(PRDATA[2]), .IN2(n163), .S(n189), .Q(n136) );
  AO22X1 U184 ( .IN1(n197), .IN2(SPI_CR_2[3]), .IN3(n201), .IN4(SPI_BR_R[3]), 
        .Q(n167) );
  AO22X1 U185 ( .IN1(n184), .IN2(SPI_ST_R[3]), .IN3(n204), .IN4(
        SPI_DATA_Reg_1[3]), .Q(n166) );
  AO22X1 U186 ( .IN1(n199), .IN2(SPI_DATA_Reg_2[3]), .IN3(n195), .IN4(
        SPI_DATA_Reg_3[3]), .Q(n165) );
  AO22X1 U187 ( .IN1(n191), .IN2(SPI_DATA_Reg_4[3]), .IN3(n193), .IN4(
        SPI_CR_1[3]), .Q(n164) );
  OR4X1 U188 ( .IN1(n167), .IN2(n166), .IN3(n165), .IN4(n164), .Q(n168) );
  MUX21X1 U189 ( .IN1(PRDATA[3]), .IN2(n168), .S(n189), .Q(n135) );
  AO22X1 U190 ( .IN1(n197), .IN2(SPI_CR_2[4]), .IN3(n201), .IN4(SPI_BR_R[4]), 
        .Q(n172) );
  AO22X1 U191 ( .IN1(n184), .IN2(SPI_ST_R[4]), .IN3(n204), .IN4(
        SPI_DATA_Reg_1[4]), .Q(n171) );
  AO22X1 U192 ( .IN1(n199), .IN2(SPI_DATA_Reg_2[4]), .IN3(n195), .IN4(
        SPI_DATA_Reg_3[4]), .Q(n170) );
  AO22X1 U193 ( .IN1(n191), .IN2(SPI_DATA_Reg_4[4]), .IN3(n193), .IN4(
        SPI_CR_1[4]), .Q(n169) );
  OR4X1 U194 ( .IN1(n172), .IN2(n171), .IN3(n170), .IN4(n169), .Q(n173) );
  MUX21X1 U195 ( .IN1(PRDATA[4]), .IN2(n173), .S(n189), .Q(n134) );
  AO22X1 U196 ( .IN1(n197), .IN2(SPI_CR_2[5]), .IN3(n201), .IN4(SPI_BR_R[5]), 
        .Q(n177) );
  AO22X1 U197 ( .IN1(n184), .IN2(SPI_ST_R[5]), .IN3(n204), .IN4(
        SPI_DATA_Reg_1[5]), .Q(n176) );
  AO22X1 U198 ( .IN1(n199), .IN2(SPI_DATA_Reg_2[5]), .IN3(n195), .IN4(
        SPI_DATA_Reg_3[5]), .Q(n175) );
  AO22X1 U199 ( .IN1(n191), .IN2(SPI_DATA_Reg_4[5]), .IN3(n193), .IN4(
        SPI_CR_1[5]), .Q(n174) );
  OR4X1 U200 ( .IN1(n177), .IN2(n176), .IN3(n175), .IN4(n174), .Q(n178) );
  MUX21X1 U201 ( .IN1(PRDATA[5]), .IN2(n178), .S(n189), .Q(n133) );
  AO22X1 U202 ( .IN1(n197), .IN2(SPI_CR_2[6]), .IN3(n201), .IN4(SPI_BR_R[6]), 
        .Q(n182) );
  AO22X1 U203 ( .IN1(n184), .IN2(SPI_ST_R[6]), .IN3(n204), .IN4(
        SPI_DATA_Reg_1[6]), .Q(n181) );
  AO22X1 U204 ( .IN1(n199), .IN2(SPI_DATA_Reg_2[6]), .IN3(n195), .IN4(
        SPI_DATA_Reg_3[6]), .Q(n180) );
  AO22X1 U205 ( .IN1(n191), .IN2(SPI_DATA_Reg_4[6]), .IN3(n193), .IN4(
        SPI_CR_1[6]), .Q(n179) );
  OR4X1 U206 ( .IN1(n182), .IN2(n181), .IN3(n180), .IN4(n179), .Q(n183) );
  MUX21X1 U207 ( .IN1(PRDATA[6]), .IN2(n183), .S(n189), .Q(n132) );
  AO22X1 U208 ( .IN1(n197), .IN2(SPI_CR_2[7]), .IN3(n201), .IN4(SPI_BR_R[7]), 
        .Q(n188) );
  AO22X1 U209 ( .IN1(n184), .IN2(SPI_ST_R[7]), .IN3(n204), .IN4(
        SPI_DATA_Reg_1[7]), .Q(n187) );
  AO22X1 U210 ( .IN1(n199), .IN2(SPI_DATA_Reg_2[7]), .IN3(n195), .IN4(
        SPI_DATA_Reg_3[7]), .Q(n186) );
  AO22X1 U211 ( .IN1(n191), .IN2(SPI_DATA_Reg_4[7]), .IN3(n193), .IN4(
        SPI_CR_1[7]), .Q(n185) );
  OR4X1 U212 ( .IN1(n188), .IN2(n187), .IN3(n186), .IN4(n185), .Q(n190) );
  MUX21X1 U213 ( .IN1(PRDATA[7]), .IN2(n190), .S(n189), .Q(n131) );
  MUX21X1 U214 ( .IN1(PWDATA[0]), .IN2(SPI_DATA_Reg_4[0]), .S(n192), .Q(n130)
         );
  MUX21X1 U215 ( .IN1(PWDATA[1]), .IN2(SPI_DATA_Reg_4[1]), .S(n192), .Q(n129)
         );
  MUX21X1 U216 ( .IN1(PWDATA[2]), .IN2(SPI_DATA_Reg_4[2]), .S(n192), .Q(n128)
         );
  MUX21X1 U217 ( .IN1(PWDATA[3]), .IN2(SPI_DATA_Reg_4[3]), .S(n192), .Q(n127)
         );
  MUX21X1 U218 ( .IN1(PWDATA[4]), .IN2(SPI_DATA_Reg_4[4]), .S(n192), .Q(n126)
         );
  MUX21X1 U219 ( .IN1(PWDATA[5]), .IN2(SPI_DATA_Reg_4[5]), .S(n192), .Q(n125)
         );
  MUX21X1 U220 ( .IN1(PWDATA[6]), .IN2(SPI_DATA_Reg_4[6]), .S(n192), .Q(n124)
         );
  MUX21X1 U221 ( .IN1(PWDATA[7]), .IN2(SPI_DATA_Reg_4[7]), .S(n192), .Q(n123)
         );
  NAND2X0 U222 ( .IN1(n193), .IN2(n203), .QN(n194) );
  MUX21X1 U223 ( .IN1(PWDATA[0]), .IN2(SPI_CR_1[0]), .S(n194), .Q(n122) );
  MUX21X1 U224 ( .IN1(PWDATA[1]), .IN2(SPI_CR_1[1]), .S(n194), .Q(n121) );
  MUX21X1 U225 ( .IN1(PWDATA[2]), .IN2(SPI_CR_1[2]), .S(n194), .Q(n120) );
  MUX21X1 U226 ( .IN1(PWDATA[3]), .IN2(SPI_CR_1[3]), .S(n194), .Q(n119) );
  MUX21X1 U227 ( .IN1(PWDATA[4]), .IN2(SPI_CR_1[4]), .S(n194), .Q(n118) );
  MUX21X1 U228 ( .IN1(PWDATA[5]), .IN2(SPI_CR_1[5]), .S(n194), .Q(n117) );
  MUX21X1 U229 ( .IN1(PWDATA[6]), .IN2(SPI_CR_1[6]), .S(n194), .Q(n116) );
  MUX21X1 U230 ( .IN1(PWDATA[7]), .IN2(SPI_CR_1[7]), .S(n194), .Q(n115) );
  NAND2X0 U231 ( .IN1(n195), .IN2(n203), .QN(n196) );
  MUX21X1 U232 ( .IN1(PWDATA[0]), .IN2(SPI_DATA_Reg_3[0]), .S(n196), .Q(n114)
         );
  MUX21X1 U233 ( .IN1(PWDATA[1]), .IN2(SPI_DATA_Reg_3[1]), .S(n196), .Q(n113)
         );
  MUX21X1 U234 ( .IN1(PWDATA[2]), .IN2(SPI_DATA_Reg_3[2]), .S(n196), .Q(n112)
         );
  MUX21X1 U235 ( .IN1(PWDATA[3]), .IN2(SPI_DATA_Reg_3[3]), .S(n196), .Q(n111)
         );
  MUX21X1 U236 ( .IN1(PWDATA[4]), .IN2(SPI_DATA_Reg_3[4]), .S(n196), .Q(n110)
         );
  MUX21X1 U237 ( .IN1(PWDATA[5]), .IN2(SPI_DATA_Reg_3[5]), .S(n196), .Q(n109)
         );
  MUX21X1 U238 ( .IN1(PWDATA[6]), .IN2(SPI_DATA_Reg_3[6]), .S(n196), .Q(n108)
         );
  MUX21X1 U239 ( .IN1(PWDATA[7]), .IN2(SPI_DATA_Reg_3[7]), .S(n196), .Q(n107)
         );
  NAND2X0 U240 ( .IN1(n197), .IN2(n203), .QN(n198) );
  MUX21X1 U241 ( .IN1(PWDATA[0]), .IN2(SPI_CR_2[0]), .S(n198), .Q(n106) );
  MUX21X1 U242 ( .IN1(PWDATA[1]), .IN2(SPI_CR_2[1]), .S(n198), .Q(n105) );
  MUX21X1 U243 ( .IN1(PWDATA[2]), .IN2(SPI_CR_2[2]), .S(n198), .Q(n104) );
  MUX21X1 U244 ( .IN1(PWDATA[3]), .IN2(SPI_CR_2[3]), .S(n198), .Q(n103) );
  MUX21X1 U245 ( .IN1(PWDATA[4]), .IN2(SPI_CR_2[4]), .S(n198), .Q(n102) );
  MUX21X1 U246 ( .IN1(PWDATA[5]), .IN2(SPI_CR_2[5]), .S(n198), .Q(n101) );
  MUX21X1 U247 ( .IN1(PWDATA[6]), .IN2(SPI_CR_2[6]), .S(n198), .Q(n100) );
  MUX21X1 U248 ( .IN1(PWDATA[7]), .IN2(SPI_CR_2[7]), .S(n198), .Q(n99) );
  NAND2X0 U249 ( .IN1(n199), .IN2(n203), .QN(n200) );
  MUX21X1 U250 ( .IN1(PWDATA[0]), .IN2(SPI_DATA_Reg_2[0]), .S(n200), .Q(n98)
         );
  MUX21X1 U251 ( .IN1(PWDATA[1]), .IN2(SPI_DATA_Reg_2[1]), .S(n200), .Q(n97)
         );
  MUX21X1 U252 ( .IN1(PWDATA[2]), .IN2(SPI_DATA_Reg_2[2]), .S(n200), .Q(n96)
         );
  MUX21X1 U253 ( .IN1(PWDATA[3]), .IN2(SPI_DATA_Reg_2[3]), .S(n200), .Q(n95)
         );
  MUX21X1 U254 ( .IN1(PWDATA[4]), .IN2(SPI_DATA_Reg_2[4]), .S(n200), .Q(n94)
         );
  MUX21X1 U255 ( .IN1(PWDATA[5]), .IN2(SPI_DATA_Reg_2[5]), .S(n200), .Q(n93)
         );
  MUX21X1 U256 ( .IN1(PWDATA[6]), .IN2(SPI_DATA_Reg_2[6]), .S(n200), .Q(n92)
         );
  MUX21X1 U257 ( .IN1(PWDATA[7]), .IN2(SPI_DATA_Reg_2[7]), .S(n200), .Q(n91)
         );
  NAND2X0 U258 ( .IN1(n201), .IN2(n203), .QN(n202) );
  MUX21X1 U259 ( .IN1(PWDATA[0]), .IN2(SPI_BR_R[0]), .S(n202), .Q(n90) );
  MUX21X1 U260 ( .IN1(PWDATA[1]), .IN2(SPI_BR_R[1]), .S(n202), .Q(n89) );
  MUX21X1 U261 ( .IN1(PWDATA[2]), .IN2(SPI_BR_R[2]), .S(n202), .Q(n88) );
  MUX21X1 U262 ( .IN1(PWDATA[3]), .IN2(SPI_BR_R[3]), .S(n202), .Q(n87) );
  MUX21X1 U263 ( .IN1(PWDATA[4]), .IN2(SPI_BR_R[4]), .S(n202), .Q(n86) );
  MUX21X1 U264 ( .IN1(PWDATA[5]), .IN2(SPI_BR_R[5]), .S(n202), .Q(n85) );
  MUX21X1 U265 ( .IN1(PWDATA[6]), .IN2(SPI_BR_R[6]), .S(n202), .Q(n84) );
  MUX21X1 U266 ( .IN1(PWDATA[7]), .IN2(SPI_BR_R[7]), .S(n202), .Q(n83) );
  NAND2X0 U267 ( .IN1(n204), .IN2(n203), .QN(n205) );
  MUX21X1 U268 ( .IN1(PWDATA[0]), .IN2(SPI_DATA_Reg_1[0]), .S(n205), .Q(n82)
         );
  MUX21X1 U269 ( .IN1(PWDATA[1]), .IN2(SPI_DATA_Reg_1[1]), .S(n205), .Q(n81)
         );
  MUX21X1 U270 ( .IN1(PWDATA[2]), .IN2(SPI_DATA_Reg_1[2]), .S(n205), .Q(n80)
         );
  MUX21X1 U271 ( .IN1(PWDATA[3]), .IN2(SPI_DATA_Reg_1[3]), .S(n205), .Q(n79)
         );
  MUX21X1 U272 ( .IN1(PWDATA[4]), .IN2(SPI_DATA_Reg_1[4]), .S(n205), .Q(n78)
         );
  MUX21X1 U273 ( .IN1(PWDATA[5]), .IN2(SPI_DATA_Reg_1[5]), .S(n205), .Q(n77)
         );
  MUX21X1 U274 ( .IN1(PWDATA[6]), .IN2(SPI_DATA_Reg_1[6]), .S(n205), .Q(n76)
         );
  MUX21X1 U275 ( .IN1(PWDATA[7]), .IN2(SPI_DATA_Reg_1[7]), .S(n205), .Q(n75)
         );
  MUX21X1 U276 ( .IN1(PWDATA[0]), .IN2(SPI_ST_R[0]), .S(n206), .Q(n74) );
  MUX21X1 U277 ( .IN1(PWDATA[1]), .IN2(SPI_ST_R[1]), .S(n206), .Q(n73) );
  MUX21X1 U278 ( .IN1(PWDATA[2]), .IN2(SPI_ST_R[2]), .S(n206), .Q(n72) );
  MUX21X1 U279 ( .IN1(PWDATA[3]), .IN2(SPI_ST_R[3]), .S(n206), .Q(n71) );
  MUX21X1 U280 ( .IN1(PWDATA[4]), .IN2(SPI_ST_R[4]), .S(n206), .Q(n70) );
  MUX21X1 U281 ( .IN1(PWDATA[5]), .IN2(SPI_ST_R[5]), .S(n206), .Q(n69) );
  MUX21X1 U282 ( .IN1(PWDATA[6]), .IN2(SPI_ST_R[6]), .S(n206), .Q(n68) );
  OA21X1 U283 ( .IN1(STATE[1]), .IN2(PENABLE), .IN3(STATE[0]), .Q(n140) );
endmodule

