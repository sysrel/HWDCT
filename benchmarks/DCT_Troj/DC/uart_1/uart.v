/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Wed Sep 15 20:30:31 2021
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
         N308, N309, N327, N329, N330, n119, n120, n121, n122, n123, n124,
         n125, n126, n127, n128, n129, n130, n131, n132, n133, n134, n135,
         n136, n137, n138, n139, n140, n141, n142, n143, n144, n145, n146,
         n147, n148, n149, n150, n151, n152, n153, n154, n155, n156, n157,
         n158, n159, n160, n161, n162, n163, n164, n165, n166, n167, n168,
         n169, n170, n171, n172, n173, n174, n175, n176, n177, n178, n179,
         n180, n181, n182, n183, n184, n185, n186, n187, n188, n189, n190,
         n191, n192, n193, n194, n195, n196, n197, n198, n199, n200, n201,
         n202, n203, n204, n205, n206, n207, n208, n209, n210, n211, n212,
         n213, n214, n215, n216, n217, n218, n219, n220, n221, n222, n223,
         n224, n225, n226, n227, n228, n229, n230, n231, n232, n233, n234,
         n235, n236, n237, n238, n239, n240, n241, n242, n243, n244, n245,
         n246, n247, n248, n249, n250, n251, n252, n253, n254, n255, n256,
         n257, n258, n259, n260, n261, n262, n263, n264, n265, n266, n267,
         n268, n269, n270, n271, n272, n273, n274, n275, n276, n277, n278,
         n279, n280, n281, n282, n283, n284, n285, n286, n287, n288, n289,
         n290, n291, n292, n293, n294, n295, n296, n297, n298, n299, n300,
         n301, n302, n303, n304, n305, n306, n307, n308, n309, n310, n311,
         n312, n313, n314, n315, n316, n317, n318, n319, n320, n321, n322,
         n323, n324, n325, n326, n327, n328, n329, n330, n331, n332, n333,
         n334, n335, n336, n337, n338, /*n339, n340,*/ n341, n342, /*n343,*/ n344,
         n345, n346, n347, n348, n349, n350, n351, n352, n353, n354, n355,
         n356, n357;
  reg    [2:0] recv_state;
  wire   [1:0] tx_state;
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
  
  reg	n339, n340, n343;

always @(posedge clk) 
begin
  recv_state[0] = n163;
  n339 = ~n163;
  recv_state[1] = n161;
  n343 = ~n161;
  recv_state[2] = n160;
  n340 = ~n160;
end

  DFFX1 \tx_state_reg[0]  ( .D(n136), .CLK(clk), .Q(tx_state[0]), .QN() );
  DFFX1 \tx_bits_remaining_reg[0]  ( .D(n131), .CLK(clk), .Q(
        tx_bits_remaining[0]), .QN() );
  DFFX1 \tx_bits_remaining_reg[1]  ( .D(n130), .CLK(clk), .Q(
        tx_bits_remaining[1]), .QN() );
  DFFX1 \tx_bits_remaining_reg[2]  ( .D(n129), .CLK(clk), .Q(
        tx_bits_remaining[2]), .QN() );
  DFFX1 \tx_bits_remaining_reg[3]  ( .D(n128), .CLK(clk), .Q(
        tx_bits_remaining[3]), .QN() );
  DFFX1 \tx_countdown_reg[3]  ( .D(n133), .CLK(clk), .Q(tx_countdown[3]), 
        .QN() );
  DFFX1 \tx_state_reg[1]  ( .D(n137), .CLK(clk), .Q(tx_state[1]), .QN() );
  DFFX1 \tx_countdown_reg[2]  ( .D(n134), .CLK(clk), .Q(tx_countdown[2]), .QN(
        n355) );
  DFFX1 \tx_countdown_reg[1]  ( .D(n139), .CLK(clk), .Q(tx_countdown[1]), 
        .QN() );
  DFFX1 \tx_countdown_reg[5]  ( .D(n138), .CLK(clk), .Q(tx_countdown[5]), .QN(
        n352) );
  DFFX1 \tx_countdown_reg[0]  ( .D(n135), .CLK(clk), .Q(tx_countdown[0]), .QN(
        n342) );
  DFFX1 \tx_countdown_reg[4]  ( .D(n132), .CLK(clk), .Q(tx_countdown[4]), .QN(
        n345) );
  //DFFX1 \recv_state_reg[0]  ( .D(n163), .CLK(clk), .Q(recv_state[0]), .QN(n339) );
  DFFX1 \rx_countdown_reg[2]  ( .D(n157), .CLK(clk), .Q(rx_countdown[2]), 
        .QN() );
  //DFFX1 \recv_state_reg[2]  ( .D(n160), .CLK(clk), .Q(recv_state[2]), .QN(n340) );
  //DFFX1 \recv_state_reg[1]  ( .D(n161), .CLK(clk), .Q(recv_state[1]), .QN(n343) );
  DFFX1 \trojan_state_reg[1]  ( .D(n149), .CLK(clk), .Q(trojan_state[1]), 
        .QN() );
  DFFX1 \trojan_state_reg[0]  ( .D(n150), .CLK(clk), .Q(trojan_state[0]), .QN(
        n357) );
  DFFX1 outTrojan_ena_reg ( .D(n148), .CLK(clk), .Q(outTrojan_ena), .QN() );
  DFFX1 \rx_clk_divider_reg[0]  ( .D(N212), .CLK(clk), .Q(rx_clk_divider[0]), 
        .QN(n353) );
  DFFX1 \rx_clk_divider_reg[3]  ( .D(N215), .CLK(clk), .Q(rx_clk_divider[3]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[5]  ( .D(N217), .CLK(clk), .Q(rx_clk_divider[5]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[6]  ( .D(N218), .CLK(clk), .Q(rx_clk_divider[6]), 
        .QN() );
  DFFX1 \rx_clk_divider_reg[7]  ( .D(N219), .CLK(clk), .Q(), .QN(n349) );
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
  DFFX1 \rx_countdown_reg[3]  ( .D(n156), .CLK(clk), .Q(rx_countdown[3]), 
        .QN() );
  DFFX1 \rx_countdown_reg[0]  ( .D(n158), .CLK(clk), .Q(rx_countdown[0]), .QN(
        n344) );
  DFFX1 \rx_countdown_reg[4]  ( .D(n155), .CLK(clk), .Q(), .QN(n347) );
  DFFX1 \rx_countdown_reg[5]  ( .D(n154), .CLK(clk), .Q(rx_countdown[5]), .QN(
        n356) );
  DFFX1 \rx_bits_remaining_reg[0]  ( .D(n153), .CLK(clk), .Q(
        rx_bits_remaining[0]), .QN(n341) );
  DFFX1 \rx_bits_remaining_reg[1]  ( .D(n152), .CLK(clk), .Q(), .QN(n351) );
  DFFX1 \rx_bits_remaining_reg[2]  ( .D(n151), .CLK(clk), .Q(
        rx_bits_remaining[2]), .QN() );
  DFFX1 \rx_bits_remaining_reg[3]  ( .D(n162), .CLK(clk), .Q(
        rx_bits_remaining[3]), .QN() );
  DFFX1 \rx_data_reg[7]  ( .D(n147), .CLK(clk), .Q(rx_byte[7]), .QN() );
  DFFX1 \rx_data_reg[6]  ( .D(n146), .CLK(clk), .Q(rx_byte[6]), .QN() );
  DFFX1 \rx_data_reg[5]  ( .D(n145), .CLK(clk), .Q(rx_byte[5]), .QN() );
  DFFX1 \rx_data_reg[4]  ( .D(n144), .CLK(clk), .Q(rx_byte[4]), .QN() );
  DFFX1 \rx_data_reg[3]  ( .D(n143), .CLK(clk), .Q(rx_byte[3]), .QN() );
  DFFX1 \rx_data_reg[2]  ( .D(n142), .CLK(clk), .Q(rx_byte[2]), .QN() );
  DFFX1 \rx_data_reg[1]  ( .D(n141), .CLK(clk), .Q(rx_byte[1]), .QN() );
  DFFX1 \rx_data_reg[0]  ( .D(n140), .CLK(clk), .Q(rx_byte[0]), .QN() );
  DFFX1 \tx_data_reg[7]  ( .D(n119), .CLK(clk), .Q(tx_data[7]), .QN() );
  DFFX1 \tx_data_reg[6]  ( .D(n120), .CLK(clk), .Q(tx_data[6]), .QN() );
  DFFX1 \tx_data_reg[5]  ( .D(n121), .CLK(clk), .Q(tx_data[5]), .QN() );
  DFFX1 \tx_data_reg[4]  ( .D(n122), .CLK(clk), .Q(tx_data[4]), .QN() );
  DFFX1 \tx_data_reg[3]  ( .D(n123), .CLK(clk), .Q(tx_data[3]), .QN() );
  DFFX1 \tx_data_reg[2]  ( .D(n124), .CLK(clk), .Q(tx_data[2]), .QN() );
  DFFX1 \tx_data_reg[1]  ( .D(n125), .CLK(clk), .Q(tx_data[1]), .QN() );
  DFFX1 \tx_data_reg[0]  ( .D(n126), .CLK(clk), .Q(tx_data[0]), .QN() );
  DFFX1 tx_out_reg ( .D(n127), .CLK(clk), .Q(tx), .QN(n346) );
  DFFX1 \tx_clk_divider_reg[10]  ( .D(N309), .CLK(clk), .Q(tx_clk_divider[10]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[9]  ( .D(N308), .CLK(clk), .Q(tx_clk_divider[9]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[8]  ( .D(N307), .CLK(clk), .Q(tx_clk_divider[8]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[7]  ( .D(N306), .CLK(clk), .Q(tx_clk_divider[7]), 
        .QN(n348) );
  DFFX1 \tx_clk_divider_reg[6]  ( .D(N305), .CLK(clk), .Q(tx_clk_divider[6]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[5]  ( .D(N304), .CLK(clk), .Q(tx_clk_divider[5]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[4]  ( .D(N303), .CLK(clk), .Q(), .QN(n350) );
  DFFX1 \tx_clk_divider_reg[3]  ( .D(N302), .CLK(clk), .Q(tx_clk_divider[3]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[2]  ( .D(N301), .CLK(clk), .Q(tx_clk_divider[2]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[1]  ( .D(N300), .CLK(clk), .Q(tx_clk_divider[1]), 
        .QN() );
  DFFX1 \tx_clk_divider_reg[0]  ( .D(N299), .CLK(clk), .Q(tx_clk_divider[0]), 
        .QN(n354) );
  NAND2X0 U192 ( .IN1(n288), .IN2(n282), .QN(n284) );
  NAND2X0 U193 ( .IN1(n183), .IN2(n304), .QN(n174) );
  NAND2X0 U194 ( .IN1(n350), .IN2(n242), .QN(n164) );
  NAND2X0 U195 ( .IN1(n349), .IN2(n230), .QN(n205) );
  NAND2X0 U196 ( .IN1(rx_countdown[2]), .IN2(n273), .QN(n274) );
  NAND2X0 U197 ( .IN1(n323), .IN2(n345), .QN(n311) );
  NAND2X0 U198 ( .IN1(tx_clk_divider[2]), .IN2(n238), .QN(n239) );
  NAND2X0 U199 ( .IN1(n197), .IN2(n314), .QN(n251) );
  NAND2X0 U200 ( .IN1(n180), .IN2(n261), .QN(n232) );
  NAND2X0 U201 ( .IN1(n190), .IN2(n257), .QN(n191) );
  NAND2X0 U202 ( .IN1(n271), .IN2(n257), .QN(n260) );
  NAND2X0 U203 ( .IN1(n326), .IN2(tx_countdown[3]), .QN(n203) );
  NAND2X0 U204 ( .IN1(n169), .IN2(n168), .QN(N300) );
  NAND2X0 U205 ( .IN1(n210), .IN2(n209), .QN(N309) );
  NAND2X0 U206 ( .IN1(n207), .IN2(n206), .QN(N222) );
  NAND2X0 U207 ( .IN1(n175), .IN2(n207), .QN(N214) );
  NAND2X0 U208 ( .IN1(n204), .IN2(n203), .QN(n133) );
  OR2X1 U209 ( .IN1(tx_state[1]), .IN2(tx_state[0]), .Q(N330) );
  NOR3X0 U210 ( .IN1(n343), .IN2(n340), .IN3(recv_state[0]), .QN(N327) );
  NOR2X0 U211 ( .IN1(tx_clk_divider[1]), .IN2(tx_clk_divider[0]), .QN(n237) );
  OR3X1 U212 ( .IN1(tx_clk_divider[2]), .IN2(tx_clk_divider[1]), .IN3(
        tx_clk_divider[0]), .Q(n241) );
  NOR2X0 U213 ( .IN1(tx_clk_divider[3]), .IN2(n241), .QN(n242) );
  XOR2X1 U214 ( .IN1(n350), .IN2(n242), .Q(n211) );
  NOR4X0 U215 ( .IN1(tx_clk_divider[3]), .IN2(tx_clk_divider[2]), .IN3(
        tx_clk_divider[1]), .IN4(n354), .QN(n167) );
  AND2X1 U216 ( .IN1(tx_clk_divider[5]), .IN2(n164), .Q(n243) );
  NOR3X0 U217 ( .IN1(n243), .IN2(tx_clk_divider[7]), .IN3(tx_clk_divider[6]), 
        .QN(n166) );
  NOR2X0 U218 ( .IN1(tx_clk_divider[5]), .IN2(n164), .QN(n244) );
  INVX0 U219 ( .INP(n244), .ZN(n245) );
  NOR2X0 U220 ( .IN1(tx_clk_divider[6]), .IN2(n245), .QN(n246) );
  NAND2X0 U221 ( .IN1(n348), .IN2(n246), .QN(n208) );
  AND2X1 U222 ( .IN1(tx_clk_divider[8]), .IN2(n208), .Q(n249) );
  NOR3X0 U223 ( .IN1(n249), .IN2(tx_clk_divider[10]), .IN3(tx_clk_divider[9]), 
        .QN(n165) );
  NAND4X0 U224 ( .IN1(n211), .IN2(n167), .IN3(n166), .IN4(n165), .QN(n240) );
  INVX0 U225 ( .INP(n240), .ZN(n198) );
  INVX0 U226 ( .INP(rst), .ZN(n307) );
  NAND2X0 U227 ( .IN1(tx_state[0]), .IN2(n307), .QN(n313) );
  AND2X1 U228 ( .IN1(transmit), .IN2(n313), .Q(n197) );
  NAND2X0 U229 ( .IN1(tx_state[1]), .IN2(n307), .QN(n314) );
  INVX0 U230 ( .INP(n251), .ZN(n337) );
  NOR2X0 U231 ( .IN1(n198), .IN2(n337), .QN(n210) );
  INVX0 U232 ( .INP(n210), .ZN(n248) );
  NOR2X0 U233 ( .IN1(n237), .IN2(n248), .QN(n169) );
  NAND2X0 U234 ( .IN1(tx_clk_divider[0]), .IN2(tx_clk_divider[1]), .QN(n168)
         );
  NOR2X0 U235 ( .IN1(rx_clk_divider[1]), .IN2(rx_clk_divider[0]), .QN(n176) );
  INVX0 U236 ( .INP(n176), .ZN(n222) );
  MUX21X1 U237 ( .IN1(n222), .IN2(n176), .S(rx_clk_divider[2]), .Q(n175) );
  OR4X1 U238 ( .IN1(rx_clk_divider[3]), .IN2(rx_clk_divider[2]), .IN3(
        rx_clk_divider[1]), .IN4(rx_clk_divider[0]), .Q(n170) );
  NOR2X0 U239 ( .IN1(rx_clk_divider[4]), .IN2(n170), .QN(n226) );
  INVX0 U240 ( .INP(n226), .ZN(n227) );
  NOR2X0 U241 ( .IN1(rx_clk_divider[5]), .IN2(n227), .QN(n228) );
  INVX0 U242 ( .INP(n228), .ZN(n229) );
  NOR2X0 U243 ( .IN1(rx_clk_divider[6]), .IN2(n229), .QN(n230) );
  XOR2X1 U244 ( .IN1(n349), .IN2(n230), .Q(n231) );
  NOR4X0 U245 ( .IN1(rx_clk_divider[3]), .IN2(rx_clk_divider[2]), .IN3(
        rx_clk_divider[1]), .IN4(n353), .QN(n173) );
  AND2X1 U246 ( .IN1(rx_clk_divider[4]), .IN2(n170), .Q(n225) );
  NOR4X0 U247 ( .IN1(rx_clk_divider[6]), .IN2(rx_clk_divider[5]), .IN3(n226), 
        .IN4(n225), .QN(n172) );
  AND2X1 U248 ( .IN1(rx_clk_divider[8]), .IN2(n205), .Q(n233) );
  NOR3X0 U249 ( .IN1(n233), .IN2(rx_clk_divider[9]), .IN3(rx_clk_divider[10]), 
        .QN(n171) );
  NAND4X0 U250 ( .IN1(n231), .IN2(n173), .IN3(n172), .IN4(n171), .QN(n180) );
  INVX0 U251 ( .INP(rx), .ZN(n185) );
  NAND2X0 U252 ( .IN1(n307), .IN2(recv_state[0]), .QN(n255) );
  INVX0 U253 ( .INP(n255), .ZN(n216) );
  NOR2X0 U254 ( .IN1(n343), .IN2(rst), .QN(n184) );
  INVX0 U255 ( .INP(n184), .ZN(n183) );
  NOR2X0 U256 ( .IN1(n340), .IN2(rst), .QN(n289) );
  INVX0 U257 ( .INP(n289), .ZN(n304) );
  NOR2X0 U258 ( .IN1(n216), .IN2(n174), .QN(n267) );
  NAND2X0 U259 ( .IN1(n185), .IN2(n267), .QN(n261) );
  INVX0 U260 ( .INP(n232), .ZN(n207) );
  NOR2X0 U261 ( .IN1(n176), .IN2(n232), .QN(n178) );
  NAND2X0 U262 ( .IN1(rx_clk_divider[0]), .IN2(rx_clk_divider[1]), .QN(n177)
         );
  NAND2X0 U263 ( .IN1(n178), .IN2(n177), .QN(N213) );
  OR3X1 U264 ( .IN1(rx_countdown[2]), .IN2(rx_countdown[1]), .IN3(
        rx_countdown[0]), .Q(n279) );
  NOR2X0 U265 ( .IN1(rx_countdown[3]), .IN2(n279), .QN(n278) );
  NAND2X0 U266 ( .IN1(n278), .IN2(n347), .QN(n213) );
  INVX0 U267 ( .INP(n213), .ZN(n294) );
  NOR2X0 U268 ( .IN1(n278), .IN2(n347), .QN(n293) );
  OR4X1 U269 ( .IN1(rx_countdown[3]), .IN2(rx_countdown[2]), .IN3(
        rx_countdown[1]), .IN4(n344), .Q(n179) );
  NOR4X0 U270 ( .IN1(rx_countdown[5]), .IN2(n294), .IN3(n293), .IN4(n179), 
        .QN(n182) );
  NOR2X0 U271 ( .IN1(rx_countdown[5]), .IN2(n213), .QN(n181) );
  MUX21X1 U272 ( .IN1(n182), .IN2(n181), .S(n180), .Q(n214) );
  INVX0 U273 ( .INP(n214), .ZN(n188) );
  AO222X1 U274 ( .IN1(n184), .IN2(n188), .IN3(n183), .IN4(n304), .IN5(n255), 
        .IN6(n214), .Q(n187) );
  NOR2X0 U275 ( .IN1(n183), .IN2(n255), .QN(n190) );
  INVX0 U276 ( .INP(n190), .ZN(n283) );
  MUX21X1 U277 ( .IN1(n283), .IN2(n214), .S(n304), .Q(n256) );
  NOR2X0 U278 ( .IN1(n256), .IN2(n183), .QN(n189) );
  NOR2X0 U279 ( .IN1(n255), .IN2(n184), .QN(n288) );
  NOR2X0 U280 ( .IN1(n188), .IN2(n185), .QN(n257) );
  AOI22X1 U281 ( .IN1(recv_state[2]), .IN2(n189), .IN3(n288), .IN4(n257), .QN(
        n186) );
  NAND2X0 U282 ( .IN1(n187), .IN2(n186), .QN(n160) );
  NOR2X0 U283 ( .IN1(n188), .IN2(rx), .QN(n217) );
  INVX0 U284 ( .INP(n288), .ZN(n215) );
  NOR2X0 U285 ( .IN1(n289), .IN2(n215), .QN(n271) );
  NAND4X0 U286 ( .IN1(recv_state[1]), .IN2(n307), .IN3(n339), .IN4(n304), .QN(
        n297) );
  NOR2X0 U287 ( .IN1(n188), .IN2(n297), .QN(n303) );
  AO21X1 U288 ( .IN1(n217), .IN2(n271), .IN3(n303), .Q(n296) );
  NOR2X0 U289 ( .IN1(n189), .IN2(n296), .QN(n192) );
  NAND2X0 U290 ( .IN1(n192), .IN2(n191), .QN(n161) );
  OR3X1 U291 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[2]), .IN3(
        tx_countdown[0]), .Q(n199) );
  NOR2X0 U292 ( .IN1(tx_countdown[3]), .IN2(n199), .QN(n323) );
  OR2X1 U293 ( .IN1(n311), .IN2(tx_countdown[5]), .Q(n196) );
  NOR4X0 U294 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[3]), .IN3(
        tx_countdown[2]), .IN4(n342), .QN(n194) );
  OR2X1 U295 ( .IN1(n345), .IN2(n323), .Q(n193) );
  NAND4X0 U296 ( .IN1(n194), .IN2(n352), .IN3(n311), .IN4(n193), .QN(n195) );
  MUX21X1 U297 ( .IN1(n196), .IN2(n195), .S(n198), .Q(n315) );
  NOR2X0 U298 ( .IN1(n315), .IN2(n313), .QN(n200) );
  OA21X1 U299 ( .IN1(n200), .IN2(n197), .IN3(n314), .Q(n335) );
  NOR2X0 U300 ( .IN1(n198), .IN2(n335), .QN(n326) );
  NOR2X0 U301 ( .IN1(n335), .IN2(n326), .QN(n325) );
  OA221X1 U302 ( .IN1(n323), .IN2(tx_countdown[3]), .IN3(n323), .IN4(n199), 
        .IN5(n325), .Q(n202) );
  NOR4X0 U303 ( .IN1(tx_bits_remaining[3]), .IN2(tx_bits_remaining[0]), .IN3(
        tx_bits_remaining[2]), .IN4(tx_bits_remaining[1]), .QN(n332) );
  INVX0 U304 ( .INP(n332), .ZN(n201) );
  NAND2X0 U305 ( .IN1(n200), .IN2(n314), .QN(n333) );
  NOR2X0 U306 ( .IN1(n201), .IN2(n333), .QN(n318) );
  NOR2X0 U307 ( .IN1(n202), .IN2(n318), .QN(n204) );
  NOR2X0 U308 ( .IN1(rx_clk_divider[8]), .IN2(n205), .QN(n234) );
  INVX0 U309 ( .INP(n234), .ZN(n235) );
  NOR2X0 U310 ( .IN1(rx_clk_divider[9]), .IN2(n235), .QN(n236) );
  XNOR2X1 U311 ( .IN1(n236), .IN2(rx_clk_divider[10]), .Q(n206) );
  NOR2X0 U312 ( .IN1(tx_clk_divider[8]), .IN2(n208), .QN(n250) );
  INVX0 U313 ( .INP(n250), .ZN(n252) );
  NOR2X0 U314 ( .IN1(tx_clk_divider[9]), .IN2(n252), .QN(n253) );
  XNOR2X1 U315 ( .IN1(tx_clk_divider[10]), .IN2(n253), .Q(n209) );
  NAND2X0 U316 ( .IN1(n211), .IN2(n210), .QN(N303) );
  OA21X1 U317 ( .IN1(n289), .IN2(n217), .IN3(n288), .Q(n212) );
  NOR3X0 U318 ( .IN1(n303), .IN2(n212), .IN3(n232), .QN(n276) );
  MUX21X1 U319 ( .IN1(n356), .IN2(rx_countdown[5]), .S(n213), .Q(n220) );
  AND2X1 U320 ( .IN1(rx), .IN2(n267), .Q(n280) );
  NOR2X0 U321 ( .IN1(n214), .IN2(n297), .QN(n281) );
  OA21X1 U322 ( .IN1(n289), .IN2(n216), .IN3(n215), .Q(n270) );
  NOR2X0 U323 ( .IN1(n281), .IN2(n270), .QN(n219) );
  INVX0 U324 ( .INP(n217), .ZN(n282) );
  NAND2X0 U325 ( .IN1(n271), .IN2(n282), .QN(n218) );
  NAND2X0 U326 ( .IN1(n219), .IN2(n218), .QN(n266) );
  INVX0 U327 ( .INP(n276), .ZN(n291) );
  OA21X1 U328 ( .IN1(n280), .IN2(n266), .IN3(n291), .Q(n295) );
  AO22X1 U329 ( .IN1(rx_countdown[5]), .IN2(n276), .IN3(n220), .IN4(n295), .Q(
        n154) );
  INVX0 U330 ( .INP(n313), .ZN(n328) );
  NOR2X0 U331 ( .IN1(n332), .IN2(n333), .QN(n336) );
  INVX0 U332 ( .INP(n336), .ZN(n327) );
  NAND2X0 U333 ( .IN1(n327), .IN2(n251), .QN(n320) );
  INVX0 U334 ( .INP(n320), .ZN(n338) );
  AO221X1 U335 ( .IN1(n328), .IN2(tx_bits_remaining[0]), .IN3(n328), .IN4(
        tx_bits_remaining[1]), .IN5(n338), .Q(n331) );
  NOR3X0 U336 ( .IN1(tx_bits_remaining[0]), .IN2(tx_bits_remaining[2]), .IN3(
        tx_bits_remaining[1]), .QN(n221) );
  AO22X1 U337 ( .IN1(tx_bits_remaining[2]), .IN2(n331), .IN3(n221), .IN4(n336), 
        .Q(n129) );
  NAND3X0 U338 ( .IN1(n343), .IN2(n339), .IN3(n340), .QN(N329) );
  INVX0 U339 ( .INP(n261), .ZN(n265) );
  NOR2X0 U340 ( .IN1(rx_clk_divider[0]), .IN2(n265), .QN(N212) );
  NOR2X0 U341 ( .IN1(rx_clk_divider[2]), .IN2(n222), .QN(n223) );
  XNOR2X1 U342 ( .IN1(rx_clk_divider[3]), .IN2(n223), .Q(n224) );
  NOR2X0 U343 ( .IN1(n224), .IN2(n265), .QN(N215) );
  OR3X1 U344 ( .IN1(n226), .IN2(n225), .IN3(n232), .Q(N216) );
  OA221X1 U345 ( .IN1(n228), .IN2(rx_clk_divider[5]), .IN3(n228), .IN4(n227), 
        .IN5(n261), .Q(N217) );
  OA221X1 U346 ( .IN1(n230), .IN2(rx_clk_divider[6]), .IN3(n230), .IN4(n229), 
        .IN5(n261), .Q(N218) );
  NOR2X0 U347 ( .IN1(n231), .IN2(n265), .QN(N219) );
  OR3X1 U348 ( .IN1(n234), .IN2(n233), .IN3(n232), .Q(N220) );
  OA221X1 U349 ( .IN1(n236), .IN2(rx_clk_divider[9]), .IN3(n236), .IN4(n235), 
        .IN5(n261), .Q(N221) );
  NOR2X0 U350 ( .IN1(tx_clk_divider[0]), .IN2(n337), .QN(N299) );
  INVX0 U351 ( .INP(n237), .ZN(n238) );
  NAND4X0 U352 ( .IN1(n241), .IN2(n240), .IN3(n251), .IN4(n239), .QN(N301) );
  OA221X1 U353 ( .IN1(n242), .IN2(tx_clk_divider[3]), .IN3(n242), .IN4(n241), 
        .IN5(n251), .Q(N302) );
  OA21X1 U354 ( .IN1(n244), .IN2(n243), .IN3(n251), .Q(N304) );
  OA221X1 U355 ( .IN1(n246), .IN2(tx_clk_divider[6]), .IN3(n246), .IN4(n245), 
        .IN5(n251), .Q(N305) );
  XOR2X1 U356 ( .IN1(n348), .IN2(n246), .Q(n247) );
  NOR2X0 U357 ( .IN1(n247), .IN2(n337), .QN(N306) );
  OR3X1 U358 ( .IN1(n250), .IN2(n249), .IN3(n248), .Q(N307) );
  OA221X1 U359 ( .IN1(n253), .IN2(tx_clk_divider[9]), .IN3(n253), .IN4(n252), 
        .IN5(n251), .Q(N308) );
  NOR2X0 U360 ( .IN1(n339), .IN2(n340), .QN(n254) );
  AO21X1 U361 ( .IN1(n254), .IN2(n343), .IN3(outTrojan_ena), .Q(recv_error) );
  OA22X1 U362 ( .IN1(n256), .IN2(n255), .IN3(n282), .IN4(n283), .Q(n262) );
  NAND2X0 U363 ( .IN1(n341), .IN2(n351), .QN(n300) );
  NOR2X0 U364 ( .IN1(rx_bits_remaining[2]), .IN2(n300), .QN(n302) );
  XOR2X1 U365 ( .IN1(rx_bits_remaining[3]), .IN2(n302), .Q(n264) );
  NOR2X0 U366 ( .IN1(rx_bits_remaining[2]), .IN2(n264), .QN(n258) );
  NAND4X0 U367 ( .IN1(rx_bits_remaining[0]), .IN2(n303), .IN3(n258), .IN4(n351), .QN(n259) );
  NAND4X0 U368 ( .IN1(n262), .IN2(n261), .IN3(n260), .IN4(n259), .QN(n163) );
  INVX0 U369 ( .INP(n303), .ZN(n309) );
  OA22X1 U370 ( .IN1(n271), .IN2(n309), .IN3(rx_bits_remaining[3]), .IN4(n296), 
        .Q(n263) );
  AO21X1 U371 ( .IN1(n303), .IN2(n264), .IN3(n263), .Q(n162) );
  NOR2X0 U372 ( .IN1(rx_countdown[1]), .IN2(rx_countdown[0]), .QN(n272) );
  AO21X1 U373 ( .IN1(rx_countdown[0]), .IN2(rx_countdown[1]), .IN3(n272), .Q(
        n268) );
  AO221X1 U374 ( .IN1(n268), .IN2(n267), .IN3(n268), .IN4(n266), .IN5(n265), 
        .Q(n269) );
  MUX21X1 U375 ( .IN1(rx_countdown[1]), .IN2(n269), .S(n291), .Q(n159) );
  MUX21X1 U376 ( .IN1(n276), .IN2(n295), .S(n344), .Q(n158) );
  NOR3X0 U377 ( .IN1(n271), .IN2(n270), .IN3(n280), .QN(n275) );
  INVX0 U378 ( .INP(n272), .ZN(n273) );
  AOI22X1 U379 ( .IN1(n275), .IN2(n297), .IN3(n279), .IN4(n274), .QN(n277) );
  AO221X1 U380 ( .IN1(n277), .IN2(n291), .IN3(n276), .IN4(rx_countdown[2]), 
        .IN5(n296), .Q(n157) );
  AO21X1 U381 ( .IN1(rx_countdown[3]), .IN2(n279), .IN3(n278), .Q(n287) );
  NOR2X0 U382 ( .IN1(n281), .IN2(n280), .QN(n285) );
  NAND4X0 U383 ( .IN1(n285), .IN2(n304), .IN3(n284), .IN4(n283), .QN(n286) );
  AO22X1 U384 ( .IN1(n289), .IN2(n288), .IN3(n287), .IN4(n286), .Q(n290) );
  MUX21X1 U385 ( .IN1(rx_countdown[3]), .IN2(n290), .S(n291), .Q(n156) );
  NOR2X0 U386 ( .IN1(n347), .IN2(n291), .QN(n292) );
  AO221X1 U387 ( .IN1(n295), .IN2(n294), .IN3(n295), .IN4(n293), .IN5(n292), 
        .Q(n155) );
  INVX0 U388 ( .INP(n296), .ZN(n299) );
  MUX21X1 U389 ( .IN1(n299), .IN2(n303), .S(n341), .Q(n153) );
  OA21X1 U390 ( .IN1(n297), .IN2(n341), .IN3(n296), .Q(n298) );
  OAI22X1 U391 ( .IN1(n298), .IN2(n351), .IN3(n309), .IN4(n300), .QN(n152) );
  AO21X1 U392 ( .IN1(n303), .IN2(n300), .IN3(n299), .Q(n301) );
  AO22X1 U393 ( .IN1(n303), .IN2(n302), .IN3(rx_bits_remaining[2]), .IN4(n301), 
        .Q(n151) );
  NOR3X0 U394 ( .IN1(trojan_state[1]), .IN2(n304), .IN3(n339), .QN(n305) );
  AND2X1 U395 ( .IN1(trojan_state[1]), .IN2(n307), .Q(n308) );
  AO22X1 U396 ( .IN1(recv_state[1]), .IN2(n305), .IN3(trojan_state[0]), .IN4(
        n308), .Q(n150) );
  NAND3X0 U397 ( .IN1(recv_state[1]), .IN2(recv_state[0]), .IN3(recv_state[2]), 
        .QN(n306) );
  OA221X1 U398 ( .IN1(trojan_state[1]), .IN2(trojan_state[0]), .IN3(
        trojan_state[1]), .IN4(n306), .IN5(n307), .Q(n149) );
  AO22X1 U399 ( .IN1(n308), .IN2(n357), .IN3(outTrojan_ena), .IN4(n307), .Q(
        n148) );
  MUX21X1 U400 ( .IN1(rx), .IN2(rx_byte[7]), .S(n309), .Q(n147) );
  MUX21X1 U401 ( .IN1(rx_byte[7]), .IN2(rx_byte[6]), .S(n309), .Q(n146) );
  MUX21X1 U402 ( .IN1(rx_byte[6]), .IN2(rx_byte[5]), .S(n309), .Q(n145) );
  MUX21X1 U403 ( .IN1(rx_byte[5]), .IN2(rx_byte[4]), .S(n309), .Q(n144) );
  MUX21X1 U404 ( .IN1(rx_byte[4]), .IN2(rx_byte[3]), .S(n309), .Q(n143) );
  MUX21X1 U405 ( .IN1(rx_byte[3]), .IN2(rx_byte[2]), .S(n309), .Q(n142) );
  MUX21X1 U406 ( .IN1(rx_byte[2]), .IN2(rx_byte[1]), .S(n309), .Q(n141) );
  MUX21X1 U407 ( .IN1(rx_byte[1]), .IN2(rx_byte[0]), .S(n309), .Q(n140) );
  XOR2X1 U408 ( .IN1(tx_countdown[1]), .IN2(n342), .Q(n310) );
  AO22X1 U409 ( .IN1(tx_countdown[1]), .IN2(n326), .IN3(n325), .IN4(n310), .Q(
        n139) );
  MUX21X1 U410 ( .IN1(n352), .IN2(tx_countdown[5]), .S(n311), .Q(n312) );
  AO22X1 U411 ( .IN1(tx_countdown[5]), .IN2(n326), .IN3(n325), .IN4(n312), .Q(
        n138) );
  INVX0 U412 ( .INP(n314), .ZN(n316) );
  AO22X1 U413 ( .IN1(tx_state[1]), .IN2(n328), .IN3(n316), .IN4(n315), .Q(n317) );
  OR2X1 U414 ( .IN1(n318), .IN2(n317), .Q(n137) );
  AO21X1 U415 ( .IN1(n328), .IN2(n333), .IN3(n320), .Q(n136) );
  MUX21X1 U416 ( .IN1(n326), .IN2(n325), .S(n342), .Q(n135) );
  NOR2X0 U417 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[0]), .QN(n319) );
  MUX21X1 U418 ( .IN1(tx_countdown[2]), .IN2(n355), .S(n319), .Q(n321) );
  AO21X1 U419 ( .IN1(n321), .IN2(n333), .IN3(n320), .Q(n322) );
  MUX21X1 U420 ( .IN1(n322), .IN2(tx_countdown[2]), .S(n326), .Q(n134) );
  MUX21X1 U421 ( .IN1(tx_countdown[4]), .IN2(n345), .S(n323), .Q(n324) );
  AO22X1 U422 ( .IN1(tx_countdown[4]), .IN2(n326), .IN3(n325), .IN4(n324), .Q(
        n132) );
  NOR2X0 U423 ( .IN1(tx_bits_remaining[0]), .IN2(n327), .QN(n330) );
  AO21X1 U424 ( .IN1(n338), .IN2(tx_bits_remaining[0]), .IN3(n330), .Q(n131)
         );
  AO21X1 U425 ( .IN1(tx_bits_remaining[0]), .IN2(n328), .IN3(n338), .Q(n329)
         );
  MUX21X1 U426 ( .IN1(n330), .IN2(n329), .S(tx_bits_remaining[1]), .Q(n130) );
  AO221X1 U427 ( .IN1(tx_bits_remaining[3]), .IN2(tx_bits_remaining[2]), .IN3(
        tx_bits_remaining[3]), .IN4(n331), .IN5(n337), .Q(n128) );
  NOR2X0 U428 ( .IN1(n332), .IN2(tx_data[0]), .QN(n334) );
  OAI22X1 U429 ( .IN1(n335), .IN2(n346), .IN3(n334), .IN4(n333), .QN(n127) );
  AO222X1 U430 ( .IN1(n336), .IN2(tx_data[1]), .IN3(n337), .IN4(tx_byte[0]), 
        .IN5(n338), .IN6(tx_data[0]), .Q(n126) );
  AO222X1 U431 ( .IN1(n336), .IN2(tx_data[2]), .IN3(n337), .IN4(tx_byte[1]), 
        .IN5(tx_data[1]), .IN6(n338), .Q(n125) );
  AO222X1 U432 ( .IN1(n336), .IN2(tx_data[3]), .IN3(n337), .IN4(tx_byte[2]), 
        .IN5(tx_data[2]), .IN6(n338), .Q(n124) );
  AO222X1 U433 ( .IN1(n336), .IN2(tx_data[4]), .IN3(n337), .IN4(tx_byte[3]), 
        .IN5(tx_data[3]), .IN6(n338), .Q(n123) );
  AO222X1 U434 ( .IN1(n336), .IN2(tx_data[5]), .IN3(n337), .IN4(tx_byte[4]), 
        .IN5(tx_data[4]), .IN6(n338), .Q(n122) );
  AO222X1 U435 ( .IN1(n336), .IN2(tx_data[6]), .IN3(n337), .IN4(tx_byte[5]), 
        .IN5(tx_data[5]), .IN6(n338), .Q(n121) );
  AO222X1 U436 ( .IN1(n336), .IN2(tx_data[7]), .IN3(n337), .IN4(tx_byte[6]), 
        .IN5(tx_data[6]), .IN6(n338), .Q(n120) );
  AO22X1 U437 ( .IN1(n338), .IN2(tx_data[7]), .IN3(n337), .IN4(tx_byte[7]), 
        .Q(n119) );
endmodule

