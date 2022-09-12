/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Wed Sep 15 20:33:24 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module uart ( clk, rst, rx, tx, transmit, tx_byte, received, rx_byte, 
        is_receiving, is_transmitting, recv_error );
  input [7:0] tx_byte;
  output [7:0] rx_byte;
  input clk, rst, rx, transmit;
  output tx, received, is_receiving, is_transmitting, recv_error;
  wire   outTrojan_ena, N212, N213, N214, N215, N216, N217, N218, N219, N220,
         N221, N222, N299, N300, N301, N302, N303, N304, N305, N306, N307,
         N308, N309, N327, N329, N330, N334, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145,
         n146, n147, n148, n149, n150, n151, n152, n153, n154, n155, n156,
         n157, n158, n159, n160, n161, n162, n163, n164, n165, n166, n167,
         n168, n169, n170, n171, n172, n173, n174, n175, n176, n177, n178,
         n179, n180, n181, n182, n183, n184, n185, n186, n187, n188, n189,
         n190, n191, n192, n193, n194, n195, n196, n197, n198, n199, n200,
         n201, n202, n203, n204, n205, n206, n207, n208, n209, n210, n211,
         n212, n213, n214, n215, n216, n217, n218, n219, n220, n221, n222,
         n223, n224, n225, n226, n227, n228, n229, n230, n231, n232, n233,
         n234, n235, n236, n237, n238, n239, n240, n241, n242, n243, n244,
         n245, n246, n247, n248, n249, n250, n251, n252, n253, n254, n255,
         n256, n257, n258, n259, n260, n261, n262, n263, n264, n265, n266,
         n267, n268, n269, n270, n271, n272, n273, n274, n275, n276, n277,
         n278, n279, n280, n281, n282, n283, n284, n285, n286, n287, n288,
         n289, n290, n291, n292, n293, n294, n295, n296, n297, n298, n299,
         n300, n301, n302, n303, n304, n305, n306, n307, n308, n309, n310,
         n311, n312, n313, n314, n315, n316, n317, n318, n319, n320, n321,
         n322, n323, n324, n325, n326, n327, n328, n329, n330, n331, n332,
         n333, n334, n335, n336, n337, n338, n339, n340, n341, n342, n343,
         n344, n345, n346, n347, n348, n349, n350, n351, n352;
  wire   [2:0] recv_state;
  reg    [1:0] tx_state;
  wire   [1:0] trojan_state;
  wire   [3:0] tx_bits_remaining;
  wire   [7:0] tx_data;
  wire   [10:0] rx_clk_divider;
  wire   [5:0] rx_countdown;
  wire   [10:0] tx_clk_divider;
  wire   [5:0] tx_countdown;
  wire   [3:0] rx_bits_remaining;
  assign received = N327;
  assign is_receiving = N329;
  assign is_transmitting = N330;
  assign recv_error = N334;

always @(posedge clk) 
begin
  tx_state[0] = n139;
  tx_state[1] = n140;
end

  //DFFX1 \tx_state_reg[0]  ( .D(n139), .CLK(clk), .Q(tx_state[0]), .QN() );
  //DFFX1 \tx_state_reg[1]  ( .D(n140), .CLK(clk), .Q(tx_state[1]), .QN() );
  DFFX1 \tx_countdown_reg[2]  ( .D(n137), .CLK(clk), .Q(tx_countdown[2]), .QN(
        n348) );
  DFFX1 \tx_bits_remaining_reg[0]  ( .D(n134), .CLK(clk), .Q(
        tx_bits_remaining[0]), .QN() );
  DFFX1 \tx_bits_remaining_reg[1]  ( .D(n133), .CLK(clk), .Q(
        tx_bits_remaining[1]), .QN() );
  DFFX1 \tx_bits_remaining_reg[2]  ( .D(n132), .CLK(clk), .Q(
        tx_bits_remaining[2]), .QN() );
  DFFX1 \tx_bits_remaining_reg[3]  ( .D(n131), .CLK(clk), .Q(
        tx_bits_remaining[3]), .QN() );
  DFFX1 \tx_countdown_reg[3]  ( .D(n136), .CLK(clk), .Q(tx_countdown[3]), 
        .QN() );
  DFFX1 \tx_countdown_reg[1]  ( .D(n142), .CLK(clk), .Q(tx_countdown[1]), 
        .QN() );
  DFFX1 \tx_countdown_reg[5]  ( .D(n141), .CLK(clk), .Q(tx_countdown[5]), .QN(
        n343) );
  DFFX1 \tx_countdown_reg[0]  ( .D(n138), .CLK(clk), .Q(tx_countdown[0]), .QN(
        n336) );
  DFFX1 \tx_countdown_reg[4]  ( .D(n135), .CLK(clk), .Q(tx_countdown[4]), .QN(
        n338) );
  DFFX1 \trojan_state_reg[1]  ( .D(n120), .CLK(clk), .Q(trojan_state[1]), 
        .QN() );
  DFFX1 \trojan_state_reg[0]  ( .D(n121), .CLK(clk), .Q(trojan_state[0]), .QN(
        n352) );
  DFFX1 outTrojan_ena_reg ( .D(n119), .CLK(clk), .Q(outTrojan_ena), .QN() );
  DFFX1 \recv_state_reg[0]  ( .D(n163), .CLK(clk), .Q(recv_state[0]), .QN(n335) );
  DFFX1 \rx_countdown_reg[2]  ( .D(n157), .CLK(clk), .Q(rx_countdown[2]), 
        .QN() );
  DFFX1 \recv_state_reg[2]  ( .D(n160), .CLK(clk), .Q(recv_state[2]), .QN(n345) );
  DFFX1 \recv_state_reg[1]  ( .D(n161), .CLK(clk), .Q(recv_state[1]), .QN() );
  DFFX1 \rx_clk_divider_reg[0]  ( .D(N212), .CLK(clk), .Q(rx_clk_divider[0]), 
        .QN(n346) );
  DFFX1 \rx_clk_divider_reg[3]  ( .D(N215), .CLK(clk), .Q(rx_clk_divider[3]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[5]  ( .D(N217), .CLK(clk), .Q(rx_clk_divider[5]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[6]  ( .D(N218), .CLK(clk), .Q(rx_clk_divider[6]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[7]  ( .D(N219), .CLK(clk), .Q(), .QN(n341) );
  DFFX1 \rx_clk_divider_reg[9]  ( .D(N221), .CLK(clk), .Q(rx_clk_divider[9]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[1]  ( .D(N213), .CLK(clk), .Q(rx_clk_divider[1]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[2]  ( .D(N214), .CLK(clk), .Q(rx_clk_divider[2]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[4]  ( .D(N216), .CLK(clk), .Q(rx_clk_divider[4]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[8]  ( .D(N220), .CLK(clk), .Q(rx_clk_divider[8]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[10]  ( .D(N222), .CLK(clk), .Q(rx_clk_divider[10]), 
        .QN() );
  DFFX1 \rx_countdown_reg[1]  ( .D(n159), .CLK(clk), .Q(rx_countdown[1]), 
        .QN() );
  DFFX1 \rx_countdown_reg[3]  ( .D(n156), .CLK(clk), .Q(rx_countdown[3]), .QN(
        n351) );
  DFFX1 \rx_countdown_reg[0]  ( .D(n158), .CLK(clk), .Q(rx_countdown[0]), .QN(
        n337) );
  DFFX1 \rx_countdown_reg[4]  ( .D(n155), .CLK(clk), .Q(), .QN(n339) );
  DFFX1 \rx_countdown_reg[5]  ( .D(n154), .CLK(clk), .Q(rx_countdown[5]), .QN(
        n349) );
  DFFX1 \rx_bits_remaining_reg[0]  ( .D(n153), .CLK(clk), .Q(
        rx_bits_remaining[0]), .QN() );
  DFFX1 \rx_bits_remaining_reg[1]  ( .D(n152), .CLK(clk), .Q(
        rx_bits_remaining[1]), .QN(n350) );
  DFFX1 \rx_bits_remaining_reg[2]  ( .D(n151), .CLK(clk), .Q(
        rx_bits_remaining[2]), .QN() );
  DFFX1 \rx_bits_remaining_reg[3]  ( .D(n162), .CLK(clk), .Q(
        rx_bits_remaining[3]), .QN() );
  DFFX1 \rx_data_reg[7]  ( .D(n150), .CLK(clk), .Q(rx_byte[7]), .QN() );
  DFFX1 \rx_data_reg[6]  ( .D(n149), .CLK(clk), .Q(rx_byte[6]), .QN() );
  DFFX1 \rx_data_reg[5]  ( .D(n148), .CLK(clk), .Q(rx_byte[5]), .QN() );
  DFFX1 \rx_data_reg[4]  ( .D(n147), .CLK(clk), .Q(rx_byte[4]), .QN() );
  DFFX1 \rx_data_reg[3]  ( .D(n146), .CLK(clk), .Q(rx_byte[3]), .QN() );
  DFFX1 \rx_data_reg[2]  ( .D(n145), .CLK(clk), .Q(rx_byte[2]), .QN() );
  DFFX1 \rx_data_reg[1]  ( .D(n144), .CLK(clk), .Q(rx_byte[1]), .QN() );
  DFFX1 \rx_data_reg[0]  ( .D(n143), .CLK(clk), .Q(rx_byte[0]), .QN() );
  DFFX1 \tx_data_reg[7]  ( .D(n122), .CLK(clk), .Q(tx_data[7]), .QN() );
  DFFX1 \tx_data_reg[6]  ( .D(n123), .CLK(clk), .Q(tx_data[6]), .QN() );
  DFFX1 \tx_data_reg[5]  ( .D(n124), .CLK(clk), .Q(tx_data[5]), .QN() );
  DFFX1 \tx_data_reg[4]  ( .D(n125), .CLK(clk), .Q(tx_data[4]), .QN() );
  DFFX1 \tx_data_reg[3]  ( .D(n126), .CLK(clk), .Q(tx_data[3]), .QN() );
  DFFX1 \tx_data_reg[2]  ( .D(n127), .CLK(clk), .Q(tx_data[2]), .QN() );
  DFFX1 \tx_data_reg[1]  ( .D(n128), .CLK(clk), .Q(tx_data[1]), .QN() );
  DFFX1 \tx_data_reg[0]  ( .D(n129), .CLK(clk), .Q(tx_data[0]), .QN() );
  DFFX1 tx_out_reg ( .D(n130), .CLK(clk), .Q(), .QN(n344) );
  DFFX1 \tx_clk_divider_reg[10]  ( .D(N309), .CLK(clk), .Q(tx_clk_divider[10]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[9]  ( .D(N308), .CLK(clk), .Q(tx_clk_divider[9]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[8]  ( .D(N307), .CLK(clk), .Q(tx_clk_divider[8]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[7]  ( .D(N306), .CLK(clk), .Q(tx_clk_divider[7]), 
        .QN(n340) );
  DFFX1 \tx_clk_divider_reg[6]  ( .D(N305), .CLK(clk), .Q(tx_clk_divider[6]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[5]  ( .D(N304), .CLK(clk), .Q(tx_clk_divider[5]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[4]  ( .D(N303), .CLK(clk), .Q(), .QN(n342) );
  DFFX1 \tx_clk_divider_reg[3]  ( .D(N302), .CLK(clk), .Q(tx_clk_divider[3]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[2]  ( .D(N301), .CLK(clk), .Q(tx_clk_divider[2]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[1]  ( .D(N300), .CLK(clk), .Q(tx_clk_divider[1]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[0]  ( .D(N299), .CLK(clk), .Q(tx_clk_divider[0]), 
        .QN(n347) );
  NAND2X0 U193 ( .IN1(n282), .IN2(n281), .QN(n284) );
  NAND2X0 U194 ( .IN1(n263), .IN2(n273), .QN(n285) );
  NAND2X0 U195 ( .IN1(n342), .IN2(n237), .QN(n164) );
  NAND2X0 U196 ( .IN1(n341), .IN2(n225), .QN(n186) );
  NAND2X0 U197 ( .IN1(n213), .IN2(rx), .QN(n262) );
  NAND2X0 U198 ( .IN1(n315), .IN2(n338), .QN(n304) );
  NAND2X0 U199 ( .IN1(tx_clk_divider[2]), .IN2(n233), .QN(n234) );
  NAND2X0 U200 ( .IN1(n201), .IN2(n330), .QN(n246) );
  NAND2X0 U201 ( .IN1(n213), .IN2(n273), .QN(n302) );
  NAND2X0 U202 ( .IN1(n181), .IN2(n255), .QN(n227) );
  NAND2X0 U203 ( .IN1(n180), .IN2(n270), .QN(n255) );
  NAND2X0 U204 ( .IN1(n319), .IN2(n246), .QN(n312) );
  NAND2X0 U205 ( .IN1(n169), .IN2(n168), .QN(N300) );
  NAND2X0 U206 ( .IN1(n192), .IN2(n191), .QN(N309) );
  NAND2X0 U207 ( .IN1(n188), .IN2(n187), .QN(N222) );
  NAND2X0 U208 ( .IN1(n185), .IN2(n188), .QN(N214) );
  NAND2X0 U209 ( .IN1(n208), .IN2(n207), .QN(n136) );
  OR2X1 U210 ( .IN1(tx_state[1]), .IN2(tx_state[0]), .Q(N330) );
  NOR3X0 U211 ( .IN1(n345), .IN2(n335), .IN3(recv_state[1]), .QN(N334) );
  NOR2X0 U212 ( .IN1(outTrojan_ena), .IN2(n344), .QN(tx) );
  NOR2X0 U213 ( .IN1(tx_clk_divider[1]), .IN2(tx_clk_divider[0]), .QN(n232) );
  OR3X1 U214 ( .IN1(tx_clk_divider[2]), .IN2(tx_clk_divider[1]), .IN3(
        tx_clk_divider[0]), .Q(n236) );
  NOR2X0 U215 ( .IN1(tx_clk_divider[3]), .IN2(n236), .QN(n237) );
  XOR2X1 U216 ( .IN1(n342), .IN2(n237), .Q(n193) );
  NOR4X0 U217 ( .IN1(tx_clk_divider[3]), .IN2(tx_clk_divider[2]), .IN3(
        tx_clk_divider[1]), .IN4(n347), .QN(n167) );
  AND2X1 U218 ( .IN1(tx_clk_divider[5]), .IN2(n164), .Q(n238) );
  NOR3X0 U219 ( .IN1(n238), .IN2(tx_clk_divider[7]), .IN3(tx_clk_divider[6]), 
        .QN(n166) );
  NOR2X0 U220 ( .IN1(tx_clk_divider[5]), .IN2(n164), .QN(n239) );
  INVX0 U221 ( .INP(n239), .ZN(n240) );
  NOR2X0 U222 ( .IN1(tx_clk_divider[6]), .IN2(n240), .QN(n241) );
  NAND2X0 U223 ( .IN1(n340), .IN2(n241), .QN(n190) );
  AND2X1 U224 ( .IN1(tx_clk_divider[8]), .IN2(n190), .Q(n244) );
  NOR3X0 U225 ( .IN1(n244), .IN2(tx_clk_divider[10]), .IN3(tx_clk_divider[9]), 
        .QN(n165) );
  NAND4X0 U226 ( .IN1(n193), .IN2(n167), .IN3(n166), .IN4(n165), .QN(n235) );
  INVX0 U227 ( .INP(n235), .ZN(n202) );
  INVX0 U228 ( .INP(rst), .ZN(n333) );
  NAND2X0 U229 ( .IN1(tx_state[0]), .IN2(n333), .QN(n309) );
  AND2X1 U230 ( .IN1(transmit), .IN2(n309), .Q(n201) );
  NAND2X0 U231 ( .IN1(tx_state[1]), .IN2(n333), .QN(n330) );
  INVX0 U232 ( .INP(n246), .ZN(n328) );
  NOR2X0 U233 ( .IN1(n202), .IN2(n328), .QN(n192) );
  INVX0 U234 ( .INP(n192), .ZN(n243) );
  NOR2X0 U235 ( .IN1(n232), .IN2(n243), .QN(n169) );
  NAND2X0 U236 ( .IN1(tx_clk_divider[0]), .IN2(tx_clk_divider[1]), .QN(n168)
         );
  NOR3X0 U237 ( .IN1(rx_countdown[2]), .IN2(rx_countdown[1]), .IN3(
        rx_countdown[0]), .QN(n289) );
  INVX0 U238 ( .INP(n289), .ZN(n288) );
  NOR2X0 U239 ( .IN1(rx_countdown[3]), .IN2(n288), .QN(n170) );
  NAND2X0 U240 ( .IN1(n170), .IN2(n339), .QN(n211) );
  INVX0 U241 ( .INP(n211), .ZN(n298) );
  NOR2X0 U242 ( .IN1(n170), .IN2(n339), .QN(n297) );
  OR4X1 U243 ( .IN1(rx_countdown[3]), .IN2(rx_countdown[2]), .IN3(
        rx_countdown[1]), .IN4(n337), .Q(n171) );
  NOR4X0 U244 ( .IN1(rx_countdown[5]), .IN2(n298), .IN3(n297), .IN4(n171), 
        .QN(n177) );
  NOR2X0 U245 ( .IN1(rx_countdown[5]), .IN2(n211), .QN(n176) );
  OR4X1 U246 ( .IN1(rx_clk_divider[3]), .IN2(rx_clk_divider[2]), .IN3(
        rx_clk_divider[1]), .IN4(rx_clk_divider[0]), .Q(n172) );
  NOR2X0 U247 ( .IN1(rx_clk_divider[4]), .IN2(n172), .QN(n221) );
  INVX0 U248 ( .INP(n221), .ZN(n222) );
  NOR2X0 U249 ( .IN1(rx_clk_divider[5]), .IN2(n222), .QN(n223) );
  INVX0 U250 ( .INP(n223), .ZN(n224) );
  NOR2X0 U251 ( .IN1(rx_clk_divider[6]), .IN2(n224), .QN(n225) );
  XOR2X1 U252 ( .IN1(n341), .IN2(n225), .Q(n226) );
  NOR4X0 U253 ( .IN1(rx_clk_divider[3]), .IN2(rx_clk_divider[2]), .IN3(
        rx_clk_divider[1]), .IN4(n346), .QN(n175) );
  AND2X1 U254 ( .IN1(rx_clk_divider[4]), .IN2(n172), .Q(n220) );
  NOR4X0 U255 ( .IN1(rx_clk_divider[6]), .IN2(rx_clk_divider[5]), .IN3(n221), 
        .IN4(n220), .QN(n174) );
  AND2X1 U256 ( .IN1(rx_clk_divider[8]), .IN2(n186), .Q(n228) );
  NOR3X0 U257 ( .IN1(n228), .IN2(rx_clk_divider[9]), .IN3(rx_clk_divider[10]), 
        .QN(n173) );
  NAND4X0 U258 ( .IN1(n226), .IN2(n175), .IN3(n174), .IN4(n173), .QN(n181) );
  MUX21X1 U259 ( .IN1(n177), .IN2(n176), .S(n181), .Q(n213) );
  INVX0 U260 ( .INP(rx), .ZN(n180) );
  NAND2X0 U261 ( .IN1(n213), .IN2(n180), .QN(n281) );
  NAND2X0 U262 ( .IN1(recv_state[2]), .IN2(n333), .QN(n291) );
  NOR2X0 U263 ( .IN1(n335), .IN2(rst), .QN(n261) );
  INVX0 U264 ( .INP(n261), .ZN(n249) );
  NAND2X0 U265 ( .IN1(n333), .IN2(recv_state[1]), .QN(n259) );
  INVX0 U266 ( .INP(n259), .ZN(n179) );
  NOR2X0 U267 ( .IN1(n249), .IN2(n179), .QN(n282) );
  NAND2X0 U268 ( .IN1(n291), .IN2(n282), .QN(n275) );
  NAND2X0 U269 ( .IN1(n249), .IN2(n291), .QN(n214) );
  NOR2X0 U270 ( .IN1(n214), .IN2(n259), .QN(n273) );
  OA21X1 U271 ( .IN1(n281), .IN2(n275), .IN3(n302), .Q(n300) );
  NAND2X0 U272 ( .IN1(n261), .IN2(n179), .QN(n283) );
  MUX21X1 U273 ( .IN1(n283), .IN2(n213), .S(n291), .Q(n250) );
  OA22X1 U274 ( .IN1(n250), .IN2(n259), .IN3(n283), .IN4(n262), .Q(n178) );
  NAND2X0 U275 ( .IN1(n300), .IN2(n178), .QN(n161) );
  NOR2X0 U276 ( .IN1(rx_clk_divider[1]), .IN2(rx_clk_divider[0]), .QN(n184) );
  NOR2X0 U277 ( .IN1(n179), .IN2(n214), .QN(n270) );
  NOR2X0 U278 ( .IN1(n184), .IN2(n227), .QN(n183) );
  NAND2X0 U279 ( .IN1(rx_clk_divider[0]), .IN2(rx_clk_divider[1]), .QN(n182)
         );
  NAND2X0 U280 ( .IN1(n183), .IN2(n182), .QN(N213) );
  INVX0 U281 ( .INP(n184), .ZN(n217) );
  MUX21X1 U282 ( .IN1(n217), .IN2(n184), .S(rx_clk_divider[2]), .Q(n185) );
  INVX0 U283 ( .INP(n227), .ZN(n188) );
  NOR2X0 U284 ( .IN1(rx_clk_divider[8]), .IN2(n186), .QN(n229) );
  INVX0 U285 ( .INP(n229), .ZN(n230) );
  NOR2X0 U286 ( .IN1(rx_clk_divider[9]), .IN2(n230), .QN(n231) );
  XNOR2X1 U287 ( .IN1(n231), .IN2(rx_clk_divider[10]), .Q(n187) );
  INVX0 U288 ( .INP(n302), .ZN(n301) );
  NOR2X0 U289 ( .IN1(rx_bits_remaining[1]), .IN2(rx_bits_remaining[0]), .QN(
        n194) );
  AO21X1 U290 ( .IN1(n273), .IN2(rx_bits_remaining[0]), .IN3(n300), .Q(n189)
         );
  AO22X1 U291 ( .IN1(n301), .IN2(n194), .IN3(rx_bits_remaining[1]), .IN4(n189), 
        .Q(n152) );
  NOR2X0 U292 ( .IN1(tx_clk_divider[8]), .IN2(n190), .QN(n245) );
  INVX0 U293 ( .INP(n245), .ZN(n247) );
  NOR2X0 U294 ( .IN1(tx_clk_divider[9]), .IN2(n247), .QN(n248) );
  XNOR2X1 U295 ( .IN1(tx_clk_divider[10]), .IN2(n248), .Q(n191) );
  NAND2X0 U296 ( .IN1(n193), .IN2(n192), .QN(N303) );
  INVX0 U297 ( .INP(n194), .ZN(n195) );
  NOR2X0 U298 ( .IN1(rx_bits_remaining[2]), .IN2(n195), .QN(n251) );
  AO21X1 U299 ( .IN1(n301), .IN2(n195), .IN3(n300), .Q(n196) );
  AO22X1 U300 ( .IN1(n301), .IN2(n251), .IN3(rx_bits_remaining[2]), .IN4(n196), 
        .Q(n151) );
  OR3X1 U301 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[2]), .IN3(
        tx_countdown[0]), .Q(n203) );
  NOR2X0 U302 ( .IN1(tx_countdown[3]), .IN2(n203), .QN(n315) );
  OR2X1 U303 ( .IN1(n304), .IN2(tx_countdown[5]), .Q(n200) );
  NOR4X0 U304 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[3]), .IN3(
        tx_countdown[2]), .IN4(n336), .QN(n198) );
  OR2X1 U305 ( .IN1(n338), .IN2(n315), .Q(n197) );
  NAND4X0 U306 ( .IN1(n198), .IN2(n343), .IN3(n304), .IN4(n197), .QN(n199) );
  MUX21X1 U307 ( .IN1(n200), .IN2(n199), .S(n202), .Q(n307) );
  NOR2X0 U308 ( .IN1(n307), .IN2(n309), .QN(n204) );
  OA21X1 U309 ( .IN1(n204), .IN2(n201), .IN3(n330), .Q(n326) );
  NOR2X0 U310 ( .IN1(n202), .IN2(n326), .QN(n318) );
  NOR2X0 U311 ( .IN1(n326), .IN2(n318), .QN(n317) );
  OA221X1 U312 ( .IN1(n315), .IN2(tx_countdown[3]), .IN3(n315), .IN4(n203), 
        .IN5(n317), .Q(n206) );
  NOR4X0 U313 ( .IN1(tx_bits_remaining[3]), .IN2(tx_bits_remaining[0]), .IN3(
        tx_bits_remaining[2]), .IN4(tx_bits_remaining[1]), .QN(n323) );
  INVX0 U314 ( .INP(n323), .ZN(n205) );
  NAND2X0 U315 ( .IN1(n204), .IN2(n330), .QN(n324) );
  NOR2X0 U316 ( .IN1(n205), .IN2(n324), .QN(n306) );
  NOR2X0 U317 ( .IN1(n206), .IN2(n306), .QN(n208) );
  NAND2X0 U318 ( .IN1(n318), .IN2(tx_countdown[3]), .QN(n207) );
  NOR2X0 U319 ( .IN1(n323), .IN2(n324), .QN(n327) );
  INVX0 U320 ( .INP(n327), .ZN(n319) );
  INVX0 U321 ( .INP(n312), .ZN(n329) );
  AO221X1 U322 ( .IN1(n310), .IN2(tx_bits_remaining[0]), .IN3(n310), .IN4(
        tx_bits_remaining[1]), .IN5(n329), .Q(n322) );
  NOR3X0 U323 ( .IN1(tx_bits_remaining[0]), .IN2(tx_bits_remaining[2]), .IN3(
        tx_bits_remaining[1]), .QN(n209) );
  AO22X1 U324 ( .IN1(tx_bits_remaining[2]), .IN2(n322), .IN3(n209), .IN4(n327), 
        .Q(n132) );
  INVX0 U325 ( .INP(n282), .ZN(n290) );
  AOI21X1 U326 ( .IN1(n291), .IN2(n281), .IN3(n290), .QN(n210) );
  NOR3X0 U327 ( .IN1(n301), .IN2(n210), .IN3(n227), .QN(n293) );
  MUX21X1 U328 ( .IN1(n349), .IN2(rx_countdown[5]), .S(n211), .Q(n216) );
  AND2X1 U329 ( .IN1(rx), .IN2(n270), .Q(n287) );
  INVX0 U330 ( .INP(n275), .ZN(n212) );
  NAND2X0 U331 ( .IN1(n212), .IN2(n281), .QN(n215) );
  INVX0 U332 ( .INP(n213), .ZN(n263) );
  NAND2X0 U333 ( .IN1(n214), .IN2(n290), .QN(n274) );
  NAND3X0 U334 ( .IN1(n215), .IN2(n285), .IN3(n274), .QN(n269) );
  INVX0 U335 ( .INP(n293), .ZN(n295) );
  OA21X1 U336 ( .IN1(n287), .IN2(n269), .IN3(n295), .Q(n299) );
  AO22X1 U337 ( .IN1(rx_countdown[5]), .IN2(n293), .IN3(n216), .IN4(n299), .Q(
        n154) );
  OR3X1 U338 ( .IN1(recv_state[0]), .IN2(recv_state[2]), .IN3(recv_state[1]), 
        .Q(N329) );
  AND3X1 U339 ( .IN1(n335), .IN2(recv_state[2]), .IN3(recv_state[1]), .Q(N327)
         );
  INVX0 U340 ( .INP(n255), .ZN(n268) );
  NOR2X0 U341 ( .IN1(rx_clk_divider[0]), .IN2(n268), .QN(N212) );
  NOR2X0 U342 ( .IN1(rx_clk_divider[2]), .IN2(n217), .QN(n218) );
  XNOR2X1 U343 ( .IN1(rx_clk_divider[3]), .IN2(n218), .Q(n219) );
  NOR2X0 U344 ( .IN1(n219), .IN2(n268), .QN(N215) );
  OR3X1 U345 ( .IN1(n221), .IN2(n220), .IN3(n227), .Q(N216) );
  OA221X1 U346 ( .IN1(n223), .IN2(rx_clk_divider[5]), .IN3(n223), .IN4(n222), 
        .IN5(n255), .Q(N217) );
  OA221X1 U347 ( .IN1(n225), .IN2(rx_clk_divider[6]), .IN3(n225), .IN4(n224), 
        .IN5(n255), .Q(N218) );
  NOR2X0 U348 ( .IN1(n226), .IN2(n268), .QN(N219) );
  OR3X1 U349 ( .IN1(n229), .IN2(n228), .IN3(n227), .Q(N220) );
  OA221X1 U350 ( .IN1(n231), .IN2(rx_clk_divider[9]), .IN3(n231), .IN4(n230), 
        .IN5(n255), .Q(N221) );
  NOR2X0 U351 ( .IN1(tx_clk_divider[0]), .IN2(n328), .QN(N299) );
  INVX0 U352 ( .INP(n232), .ZN(n233) );
  NAND4X0 U353 ( .IN1(n236), .IN2(n235), .IN3(n246), .IN4(n234), .QN(N301) );
  OA221X1 U354 ( .IN1(n237), .IN2(tx_clk_divider[3]), .IN3(n237), .IN4(n236), 
        .IN5(n246), .Q(N302) );
  OA21X1 U355 ( .IN1(n239), .IN2(n238), .IN3(n246), .Q(N304) );
  OA221X1 U356 ( .IN1(n241), .IN2(tx_clk_divider[6]), .IN3(n241), .IN4(n240), 
        .IN5(n246), .Q(N305) );
  XOR2X1 U357 ( .IN1(n340), .IN2(n241), .Q(n242) );
  NOR2X0 U358 ( .IN1(n242), .IN2(n328), .QN(N306) );
  OR3X1 U359 ( .IN1(n245), .IN2(n244), .IN3(n243), .Q(N307) );
  OA221X1 U360 ( .IN1(n248), .IN2(tx_clk_divider[9]), .IN3(n248), .IN4(n247), 
        .IN5(n246), .Q(N308) );
  OA22X1 U361 ( .IN1(n250), .IN2(n249), .IN3(n281), .IN4(n283), .Q(n256) );
  OR2X1 U362 ( .IN1(n275), .IN2(n262), .Q(n254) );
  XOR2X1 U363 ( .IN1(rx_bits_remaining[3]), .IN2(n251), .Q(n258) );
  NOR2X0 U364 ( .IN1(rx_bits_remaining[2]), .IN2(n258), .QN(n252) );
  NAND4X0 U365 ( .IN1(n301), .IN2(rx_bits_remaining[0]), .IN3(n252), .IN4(n350), .QN(n253) );
  NAND4X0 U366 ( .IN1(n256), .IN2(n255), .IN3(n254), .IN4(n253), .QN(n163) );
  INVX0 U367 ( .INP(n300), .ZN(n279) );
  OA21X1 U368 ( .IN1(n279), .IN2(rx_bits_remaining[3]), .IN3(n302), .Q(n257)
         );
  AO21X1 U369 ( .IN1(n301), .IN2(n258), .IN3(n257), .Q(n162) );
  INVX0 U370 ( .INP(n291), .ZN(n260) );
  NAND3X0 U371 ( .IN1(n260), .IN2(n263), .IN3(n259), .QN(n266) );
  NAND2X0 U372 ( .IN1(n261), .IN2(recv_state[2]), .QN(n265) );
  OA22X1 U373 ( .IN1(n263), .IN2(n283), .IN3(n262), .IN4(n290), .Q(n264) );
  NAND3X0 U374 ( .IN1(n266), .IN2(n265), .IN3(n264), .QN(n160) );
  NOR2X0 U375 ( .IN1(rx_countdown[1]), .IN2(rx_countdown[0]), .QN(n267) );
  AO21X1 U376 ( .IN1(rx_countdown[0]), .IN2(rx_countdown[1]), .IN3(n267), .Q(
        n271) );
  AO221X1 U377 ( .IN1(n271), .IN2(n270), .IN3(n271), .IN4(n269), .IN5(n268), 
        .Q(n272) );
  MUX21X1 U378 ( .IN1(rx_countdown[1]), .IN2(n272), .S(n295), .Q(n159) );
  MUX21X1 U379 ( .IN1(n293), .IN2(n299), .S(n337), .Q(n158) );
  INVX0 U380 ( .INP(n273), .ZN(n276) );
  NAND3X0 U381 ( .IN1(n276), .IN2(n275), .IN3(n274), .QN(n278) );
  OA21X1 U382 ( .IN1(rx_countdown[1]), .IN2(rx_countdown[0]), .IN3(
        rx_countdown[2]), .Q(n277) );
  OA22X1 U383 ( .IN1(n287), .IN2(n278), .IN3(n289), .IN4(n277), .Q(n280) );
  AO221X1 U384 ( .IN1(n280), .IN2(n295), .IN3(n293), .IN4(rx_countdown[2]), 
        .IN5(n279), .Q(n157) );
  NAND4X0 U385 ( .IN1(n291), .IN2(n285), .IN3(n284), .IN4(n283), .QN(n286) );
  OA222X1 U386 ( .IN1(n289), .IN2(rx_countdown[3]), .IN3(n288), .IN4(n351), 
        .IN5(n287), .IN6(n286), .Q(n294) );
  NOR2X0 U387 ( .IN1(n291), .IN2(n290), .QN(n292) );
  AO221X1 U388 ( .IN1(n294), .IN2(n295), .IN3(n293), .IN4(rx_countdown[3]), 
        .IN5(n292), .Q(n156) );
  NOR2X0 U389 ( .IN1(n339), .IN2(n295), .QN(n296) );
  AO221X1 U390 ( .IN1(n299), .IN2(n298), .IN3(n299), .IN4(n297), .IN5(n296), 
        .Q(n155) );
  MUX21X1 U391 ( .IN1(n301), .IN2(n300), .S(rx_bits_remaining[0]), .Q(n153) );
  MUX21X1 U392 ( .IN1(rx), .IN2(rx_byte[7]), .S(n302), .Q(n150) );
  MUX21X1 U393 ( .IN1(rx_byte[7]), .IN2(rx_byte[6]), .S(n302), .Q(n149) );
  MUX21X1 U394 ( .IN1(rx_byte[6]), .IN2(rx_byte[5]), .S(n302), .Q(n148) );
  MUX21X1 U395 ( .IN1(rx_byte[5]), .IN2(rx_byte[4]), .S(n302), .Q(n147) );
  MUX21X1 U396 ( .IN1(rx_byte[4]), .IN2(rx_byte[3]), .S(n302), .Q(n146) );
  MUX21X1 U397 ( .IN1(rx_byte[3]), .IN2(rx_byte[2]), .S(n302), .Q(n145) );
  MUX21X1 U398 ( .IN1(rx_byte[2]), .IN2(rx_byte[1]), .S(n302), .Q(n144) );
  MUX21X1 U399 ( .IN1(rx_byte[1]), .IN2(rx_byte[0]), .S(n302), .Q(n143) );
  XOR2X1 U400 ( .IN1(tx_countdown[1]), .IN2(n336), .Q(n303) );
  AO22X1 U401 ( .IN1(tx_countdown[1]), .IN2(n318), .IN3(n317), .IN4(n303), .Q(
        n142) );
  MUX21X1 U402 ( .IN1(n343), .IN2(tx_countdown[5]), .S(n304), .Q(n305) );
  AO22X1 U403 ( .IN1(tx_countdown[5]), .IN2(n318), .IN3(n317), .IN4(n305), .Q(
        n141) );
  INVX0 U404 ( .INP(n330), .ZN(n308) );
  AO221X1 U405 ( .IN1(n308), .IN2(tx_state[0]), .IN3(n308), .IN4(n307), .IN5(
        n306), .Q(n140) );
  INVX0 U406 ( .INP(n309), .ZN(n310) );
  AO21X1 U407 ( .IN1(n310), .IN2(n324), .IN3(n312), .Q(n139) );
  MUX21X1 U408 ( .IN1(n318), .IN2(n317), .S(n336), .Q(n138) );
  NOR2X0 U409 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[0]), .QN(n311) );
  MUX21X1 U410 ( .IN1(tx_countdown[2]), .IN2(n348), .S(n311), .Q(n313) );
  AO21X1 U411 ( .IN1(n313), .IN2(n324), .IN3(n312), .Q(n314) );
  MUX21X1 U412 ( .IN1(n314), .IN2(tx_countdown[2]), .S(n318), .Q(n137) );
  MUX21X1 U413 ( .IN1(tx_countdown[4]), .IN2(n338), .S(n315), .Q(n316) );
  AO22X1 U414 ( .IN1(tx_countdown[4]), .IN2(n318), .IN3(n317), .IN4(n316), .Q(
        n135) );
  NOR2X0 U415 ( .IN1(tx_bits_remaining[0]), .IN2(n319), .QN(n321) );
  AO21X1 U416 ( .IN1(n329), .IN2(tx_bits_remaining[0]), .IN3(n321), .Q(n134)
         );
  AO21X1 U417 ( .IN1(tx_bits_remaining[0]), .IN2(n310), .IN3(n329), .Q(n320)
         );
  MUX21X1 U418 ( .IN1(n321), .IN2(n320), .S(tx_bits_remaining[1]), .Q(n133) );
  AO221X1 U419 ( .IN1(tx_bits_remaining[3]), .IN2(tx_bits_remaining[2]), .IN3(
        tx_bits_remaining[3]), .IN4(n322), .IN5(n328), .Q(n131) );
  NOR2X0 U420 ( .IN1(n323), .IN2(tx_data[0]), .QN(n325) );
  OAI22X1 U421 ( .IN1(n326), .IN2(n344), .IN3(n325), .IN4(n324), .QN(n130) );
  AO222X1 U422 ( .IN1(n327), .IN2(tx_data[1]), .IN3(n328), .IN4(tx_byte[0]), 
        .IN5(n329), .IN6(tx_data[0]), .Q(n129) );
  AO222X1 U423 ( .IN1(n327), .IN2(tx_data[2]), .IN3(n328), .IN4(tx_byte[1]), 
        .IN5(tx_data[1]), .IN6(n329), .Q(n128) );
  AO222X1 U424 ( .IN1(n327), .IN2(tx_data[3]), .IN3(n328), .IN4(tx_byte[2]), 
        .IN5(tx_data[2]), .IN6(n329), .Q(n127) );
  AO222X1 U425 ( .IN1(n327), .IN2(tx_data[4]), .IN3(n328), .IN4(tx_byte[3]), 
        .IN5(tx_data[3]), .IN6(n329), .Q(n126) );
  AO222X1 U426 ( .IN1(n327), .IN2(tx_data[5]), .IN3(n328), .IN4(tx_byte[4]), 
        .IN5(tx_data[4]), .IN6(n329), .Q(n125) );
  AO222X1 U427 ( .IN1(n327), .IN2(tx_data[6]), .IN3(n328), .IN4(tx_byte[5]), 
        .IN5(tx_data[5]), .IN6(n329), .Q(n124) );
  AO222X1 U428 ( .IN1(n327), .IN2(tx_data[7]), .IN3(n328), .IN4(tx_byte[6]), 
        .IN5(tx_data[6]), .IN6(n329), .Q(n123) );
  AO22X1 U429 ( .IN1(n329), .IN2(tx_data[7]), .IN3(n328), .IN4(tx_byte[7]), 
        .Q(n122) );
  NOR2X0 U430 ( .IN1(trojan_state[1]), .IN2(n330), .QN(n331) );
  AND2X1 U431 ( .IN1(trojan_state[1]), .IN2(n333), .Q(n334) );
  AO22X1 U432 ( .IN1(tx_state[0]), .IN2(n331), .IN3(trojan_state[0]), .IN4(
        n334), .Q(n121) );
  NAND2X0 U433 ( .IN1(tx_state[1]), .IN2(tx_state[0]), .QN(n332) );
  OA221X1 U434 ( .IN1(trojan_state[1]), .IN2(trojan_state[0]), .IN3(
        trojan_state[1]), .IN4(n332), .IN5(n333), .Q(n120) );
  AO22X1 U435 ( .IN1(n334), .IN2(n352), .IN3(outTrojan_ena), .IN4(n333), .Q(
        n119) );
endmodule

