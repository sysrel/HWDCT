/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Sat Jun 12 16:51:05 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module uart ( clk, rst, rx, tx, transmit, tx_byte, received, rx_byte, 
        is_receiving, is_transmitting, recv_error );
  input [7:0] tx_byte;
  output [7:0] rx_byte;
  input clk, rst, rx, transmit;
  output tx, received, is_receiving, is_transmitting, recv_error;
  wire   N181, N182, N183, N184, N185, N186, N187, N188, N189, N190, N191,
         N268, N269, N270, N271, N272, N273, N274, N275, N276, N277, N278,
         N298, N299, n115, n116, n117, n118, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145,
         n146, n147, n148, n149, n150, n151, n152, n153, n154, n155, n156,
         n159, n160, n161, n162, n163, n164, n165, n166, n167, n168, n169,
         n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180,
         n181, n182, n183, n184, n185, n186, n187, n188, n189, n190, n191,
         n192, n193, n194, n195, n196, n197, n198, n199, n200, n201, n202,
         n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, n213,
         n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, n224,
         n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235,
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246,
         n247, n248, n249, n250, n251, n252, n253, n254, n255, n256, n257,
         n258, n259, n260, n261, n262, n263, n264, n265, n266, n267, n268,
         n269, n270, n271, n272, n273, n274, n275, n276, n277, n278, n279,
         n280, n281, n282, n283, n284, n285, n286, n287, n288, n289, n290,
         n291, n292, n293, n294, n295, n296, n297, n298, n299, n300, n301,
         n302, n303, n304, n305, n306, n307, n308, n309, n310, n311, n312,
         n313, n314, n315, n316, n317, n318, n319, n320, n321, n322, n323,
         n324, n325, n326, n327, n328, n329, n330, n331, n332, n333, n334,
         n335, /*n336, */n337, n338, n339, n340, n341, n342, /*n343, */n344;
  reg    [2:0] recv_state;
  wire   [1:0] tx_state;
  wire   [3:0] tx_bits_remaining;
  wire   [7:0] tx_data;
  wire   [10:0] rx_clk_divider;
  wire   [5:0] rx_countdown;
  wire   [10:0] tx_clk_divider;
  wire   [5:0] tx_countdown;
  wire   [3:0] rx_bits_remaining;
  assign is_receiving = N298;
  assign is_transmitting = N299;

  reg    n336, n343;
always @(posedge clk) 
begin
  recv_state[0] = n156;
  n336 = ~n156;
  recv_state[1] = n154;
  n343 = ~n154;
  recv_state[2] = n153;
end

  DFFX1 \tx_state_reg[0]  ( .D(n132), .CLK(clk), .Q(tx_state[0]) );
  DFFX1 \tx_bits_remaining_reg[0]  ( .D(n127), .CLK(clk), .Q(
        tx_bits_remaining[0]) );
  DFFX1 \tx_bits_remaining_reg[1]  ( .D(n126), .CLK(clk), .Q(
        tx_bits_remaining[1]) );
  DFFX1 \tx_bits_remaining_reg[2]  ( .D(n125), .CLK(clk), .Q(
        tx_bits_remaining[2]) );
  DFFX1 \tx_bits_remaining_reg[3]  ( .D(n124), .CLK(clk), .Q(
        tx_bits_remaining[3]) );
  DFFX1 \tx_countdown_reg[3]  ( .D(n129), .CLK(clk), .Q(tx_countdown[3]) );
  DFFX1 \tx_state_reg[1]  ( .D(n133), .CLK(clk), .Q(tx_state[1]) );
  DFFX1 \tx_countdown_reg[2]  ( .D(n130), .CLK(clk), .Q(tx_countdown[2]), .QN(
        n339) );
  DFFX1 \tx_countdown_reg[1]  ( .D(n135), .CLK(clk), .Q(tx_countdown[1]) );
  DFFX1 \tx_countdown_reg[5]  ( .D(n134), .CLK(clk), .Q(tx_countdown[5]), .QN(
        n335) );
  DFFX1 \tx_countdown_reg[0]  ( .D(n131), .CLK(clk), .Q(tx_countdown[0]), .QN(
        n328) );
  DFFX1 \tx_countdown_reg[4]  ( .D(n128), .CLK(clk), .Q(tx_countdown[4]), .QN(
        n330) );
  //DFFX1 \recv_state_reg[0]  ( .D(n156), .CLK(clk), .Q(recv_state[0]), .QN(n336) );
  DFFX1 \rx_countdown_reg[2]  ( .D(n150), .CLK(clk), .Q(rx_countdown[2]) );
  //DFFX1 \recv_state_reg[2]  ( .D(n153), .CLK(clk), .Q(recv_state[2]) );
  //DFFX1 \recv_state_reg[1]  ( .D(n154), .CLK(clk), .Q(recv_state[1]), .QN(n343) );
  DFFX1 \rx_clk_divider_reg[0]  ( .D(N181), .CLK(clk), .Q(rx_clk_divider[0]), 
        .QN(n337) );
  DFFX1 \rx_clk_divider_reg[3]  ( .D(N184), .CLK(clk), .Q(rx_clk_divider[3])
         );
  DFFX1 \rx_clk_divider_reg[5]  ( .D(N186), .CLK(clk), .Q(rx_clk_divider[5])
         );
  DFFX1 \rx_clk_divider_reg[6]  ( .D(N187), .CLK(clk), .Q(rx_clk_divider[6])
         );
  DFFX1 \rx_clk_divider_reg[7]  ( .D(N188), .CLK(clk), .QN(n333) );
  DFFX1 \rx_clk_divider_reg[9]  ( .D(N190), .CLK(clk), .Q(rx_clk_divider[9])
         );
  DFFX1 \rx_clk_divider_reg[1]  ( .D(N182), .CLK(clk), .Q(rx_clk_divider[1])
         );
  DFFX1 \rx_clk_divider_reg[2]  ( .D(N183), .CLK(clk), .Q(rx_clk_divider[2])
         );
  DFFX1 \rx_clk_divider_reg[4]  ( .D(N185), .CLK(clk), .Q(rx_clk_divider[4])
         );
  DFFX1 \rx_clk_divider_reg[8]  ( .D(N189), .CLK(clk), .Q(rx_clk_divider[8])
         );
  DFFX1 \rx_clk_divider_reg[10]  ( .D(N191), .CLK(clk), .Q(rx_clk_divider[10])
         );
  DFFX1 \rx_countdown_reg[1]  ( .D(n152), .CLK(clk), .Q(rx_countdown[1]) );
  DFFX1 \rx_countdown_reg[3]  ( .D(n149), .CLK(clk), .Q(rx_countdown[3]), .QN(
        n342) );
  DFFX1 \rx_countdown_reg[0]  ( .D(n151), .CLK(clk), .Q(rx_countdown[0]), .QN(
        n329) );
  DFFX1 \rx_countdown_reg[4]  ( .D(n148), .CLK(clk), .QN(n331) );
  DFFX1 \rx_countdown_reg[5]  ( .D(n147), .CLK(clk), .Q(rx_countdown[5]), .QN(
        n340) );
  DFFX1 \rx_bits_remaining_reg[0]  ( .D(n146), .CLK(clk), .Q(
        rx_bits_remaining[0]) );
  DFFX1 \rx_bits_remaining_reg[1]  ( .D(n145), .CLK(clk), .Q(
        rx_bits_remaining[1]), .QN(n341) );
  DFFX1 \rx_bits_remaining_reg[2]  ( .D(n144), .CLK(clk), .Q(
        rx_bits_remaining[2]) );
  DFFX1 \rx_bits_remaining_reg[3]  ( .D(n155), .CLK(clk), .Q(
        rx_bits_remaining[3]) );
  DFFX1 \rx_data_reg[7]  ( .D(n143), .CLK(clk), .Q(rx_byte[7]) );
  DFFX1 \rx_data_reg[6]  ( .D(n142), .CLK(clk), .Q(rx_byte[6]) );
  DFFX1 \rx_data_reg[5]  ( .D(n141), .CLK(clk), .Q(rx_byte[5]) );
  DFFX1 \rx_data_reg[4]  ( .D(n140), .CLK(clk), .Q(rx_byte[4]) );
  DFFX1 \rx_data_reg[3]  ( .D(n139), .CLK(clk), .Q(rx_byte[3]) );
  DFFX1 \rx_data_reg[2]  ( .D(n138), .CLK(clk), .Q(rx_byte[2]) );
  DFFX1 \rx_data_reg[1]  ( .D(n137), .CLK(clk), .Q(rx_byte[1]) );
  DFFX1 \rx_data_reg[0]  ( .D(n136), .CLK(clk), .Q(rx_byte[0]) );
  DFFX1 \tx_data_reg[7]  ( .D(n115), .CLK(clk), .Q(tx_data[7]) );
  DFFX1 \tx_data_reg[6]  ( .D(n116), .CLK(clk), .Q(tx_data[6]) );
  DFFX1 \tx_data_reg[5]  ( .D(n117), .CLK(clk), .Q(tx_data[5]) );
  DFFX1 \tx_data_reg[4]  ( .D(n118), .CLK(clk), .Q(tx_data[4]) );
  DFFX1 \tx_data_reg[3]  ( .D(n119), .CLK(clk), .Q(tx_data[3]) );
  DFFX1 \tx_data_reg[2]  ( .D(n120), .CLK(clk), .Q(tx_data[2]) );
  DFFX1 \tx_data_reg[1]  ( .D(n121), .CLK(clk), .Q(tx_data[1]) );
  DFFX1 \tx_data_reg[0]  ( .D(n122), .CLK(clk), .Q(tx_data[0]) );
  DFFX1 tx_out_reg ( .D(n123), .CLK(clk), .Q(tx), .QN(n344) );
  DFFX1 \tx_clk_divider_reg[10]  ( .D(N278), .CLK(clk), .Q(tx_clk_divider[10])
         );
  DFFX1 \tx_clk_divider_reg[9]  ( .D(N277), .CLK(clk), .Q(tx_clk_divider[9])
         );
  DFFX1 \tx_clk_divider_reg[8]  ( .D(N276), .CLK(clk), .Q(tx_clk_divider[8])
         );
  DFFX1 \tx_clk_divider_reg[7]  ( .D(N275), .CLK(clk), .Q(tx_clk_divider[7]), 
        .QN(n332) );
  DFFX1 \tx_clk_divider_reg[6]  ( .D(N274), .CLK(clk), .Q(tx_clk_divider[6])
         );
  DFFX1 \tx_clk_divider_reg[5]  ( .D(N273), .CLK(clk), .Q(tx_clk_divider[5])
         );
  DFFX1 \tx_clk_divider_reg[4]  ( .D(N272), .CLK(clk), .QN(n334) );
  DFFX1 \tx_clk_divider_reg[3]  ( .D(N271), .CLK(clk), .Q(tx_clk_divider[3])
         );
  DFFX1 \tx_clk_divider_reg[2]  ( .D(N270), .CLK(clk), .Q(tx_clk_divider[2])
         );
  DFFX1 \tx_clk_divider_reg[1]  ( .D(N269), .CLK(clk), .Q(tx_clk_divider[1])
         );
  DFFX1 \tx_clk_divider_reg[0]  ( .D(N268), .CLK(clk), .Q(tx_clk_divider[0]), 
        .QN(n338) );
  NAND2X0 U185 ( .IN1(n303), .IN2(n302), .QN(n305) );
  NAND2X0 U186 ( .IN1(n239), .IN2(n311), .QN(n295) );
  NAND2X0 U187 ( .IN1(n334), .IN2(n271), .QN(n161) );
  NAND2X0 U188 ( .IN1(n333), .IN2(n261), .QN(n192) );
  NAND2X0 U189 ( .IN1(n206), .IN2(rx), .QN(n282) );
  NAND2X0 U190 ( .IN1(n228), .IN2(n330), .QN(n226) );
  NAND2X0 U191 ( .IN1(tx_clk_divider[2]), .IN2(n267), .QN(n268) );
  NAND2X0 U192 ( .IN1(n168), .IN2(n217), .QN(n277) );
  NAND2X0 U193 ( .IN1(n206), .IN2(n294), .QN(n290) );
  NAND2X0 U194 ( .IN1(n187), .IN2(n287), .QN(n242) );
  NAND2X0 U195 ( .IN1(n186), .IN2(n245), .QN(n287) );
  NAND2X0 U196 ( .IN1(n231), .IN2(tx_countdown[3]), .QN(n173) );
  NAND2X0 U197 ( .IN1(n205), .IN2(n204), .QN(N269) );
  NAND2X0 U198 ( .IN1(n203), .IN2(n201), .QN(N278) );
  NAND2X0 U199 ( .IN1(n194), .IN2(n193), .QN(N191) );
  NAND2X0 U200 ( .IN1(n174), .IN2(n173), .QN(n129) );
  INVX0 U201 ( .INP(rst), .ZN(n183) );
  NAND2X0 U202 ( .IN1(tx_state[0]), .IN2(n183), .QN(n216) );
  INVX0 U203 ( .INP(n216), .ZN(n214) );
  NOR4X0 U204 ( .IN1(tx_bits_remaining[3]), .IN2(tx_bits_remaining[0]), .IN3(
        tx_bits_remaining[2]), .IN4(tx_bits_remaining[1]), .QN(n252) );
  OR3X1 U205 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[2]), .IN3(
        tx_countdown[0]), .Q(n170) );
  NOR2X0 U206 ( .IN1(tx_countdown[3]), .IN2(n170), .QN(n228) );
  OR2X1 U207 ( .IN1(n226), .IN2(tx_countdown[5]), .Q(n166) );
  NOR4X0 U208 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[3]), .IN3(
        tx_countdown[2]), .IN4(n328), .QN(n160) );
  OR2X1 U209 ( .IN1(n330), .IN2(n228), .Q(n159) );
  NAND4X0 U210 ( .IN1(n160), .IN2(n335), .IN3(n226), .IN4(n159), .QN(n165) );
  OR3X1 U211 ( .IN1(tx_clk_divider[2]), .IN2(tx_clk_divider[1]), .IN3(
        tx_clk_divider[0]), .Q(n270) );
  NOR2X0 U212 ( .IN1(tx_clk_divider[3]), .IN2(n270), .QN(n271) );
  XOR2X1 U213 ( .IN1(n334), .IN2(n271), .Q(n202) );
  NOR4X0 U214 ( .IN1(tx_clk_divider[3]), .IN2(tx_clk_divider[2]), .IN3(
        tx_clk_divider[1]), .IN4(n338), .QN(n164) );
  AND2X1 U215 ( .IN1(tx_clk_divider[5]), .IN2(n161), .Q(n272) );
  NOR3X0 U216 ( .IN1(n272), .IN2(tx_clk_divider[7]), .IN3(tx_clk_divider[6]), 
        .QN(n163) );
  NOR2X0 U217 ( .IN1(tx_clk_divider[5]), .IN2(n161), .QN(n273) );
  INVX0 U218 ( .INP(n273), .ZN(n274) );
  NOR2X0 U219 ( .IN1(tx_clk_divider[6]), .IN2(n274), .QN(n275) );
  NAND2X0 U220 ( .IN1(n332), .IN2(n275), .QN(n200) );
  AND2X1 U221 ( .IN1(tx_clk_divider[8]), .IN2(n200), .Q(n250) );
  NOR3X0 U222 ( .IN1(n250), .IN2(tx_clk_divider[10]), .IN3(tx_clk_divider[9]), 
        .QN(n162) );
  NAND4X0 U223 ( .IN1(n202), .IN2(n164), .IN3(n163), .IN4(n162), .QN(n269) );
  INVX0 U224 ( .INP(n269), .ZN(n199) );
  MUX21X1 U225 ( .IN1(n166), .IN2(n165), .S(n199), .Q(n218) );
  NOR2X0 U226 ( .IN1(n218), .IN2(n216), .QN(n169) );
  NAND2X0 U227 ( .IN1(tx_state[1]), .IN2(n183), .QN(n217) );
  NAND2X0 U228 ( .IN1(n169), .IN2(n217), .QN(n322) );
  NOR2X0 U229 ( .IN1(n252), .IN2(n322), .QN(n327) );
  INVX0 U230 ( .INP(n327), .ZN(n213) );
  AND2X1 U231 ( .IN1(transmit), .IN2(n216), .Q(n168) );
  NAND2X0 U232 ( .IN1(n213), .IN2(n277), .QN(n321) );
  INVX0 U233 ( .INP(n321), .ZN(n325) );
  AO221X1 U234 ( .IN1(n214), .IN2(tx_bits_remaining[0]), .IN3(n214), .IN4(
        tx_bits_remaining[1]), .IN5(n325), .Q(n324) );
  NOR3X0 U235 ( .IN1(tx_bits_remaining[0]), .IN2(tx_bits_remaining[2]), .IN3(
        tx_bits_remaining[1]), .QN(n167) );
  AO22X1 U236 ( .IN1(tx_bits_remaining[2]), .IN2(n324), .IN3(n167), .IN4(n327), 
        .Q(n125) );
  OA21X1 U237 ( .IN1(n169), .IN2(n168), .IN3(n217), .Q(n254) );
  NOR2X0 U238 ( .IN1(n199), .IN2(n254), .QN(n231) );
  NOR2X0 U239 ( .IN1(n254), .IN2(n231), .QN(n230) );
  OA221X1 U240 ( .IN1(n228), .IN2(tx_countdown[3]), .IN3(n228), .IN4(n170), 
        .IN5(n230), .Q(n172) );
  INVX0 U241 ( .INP(n252), .ZN(n171) );
  NOR2X0 U242 ( .IN1(n171), .IN2(n322), .QN(n221) );
  NOR2X0 U243 ( .IN1(n172), .IN2(n221), .QN(n174) );
  NOR3X0 U244 ( .IN1(rx_countdown[2]), .IN2(rx_countdown[1]), .IN3(
        rx_countdown[0]), .QN(n310) );
  INVX0 U245 ( .INP(n310), .ZN(n309) );
  NOR2X0 U246 ( .IN1(rx_countdown[3]), .IN2(n309), .QN(n175) );
  NAND2X0 U247 ( .IN1(n175), .IN2(n331), .QN(n247) );
  INVX0 U248 ( .INP(n247), .ZN(n319) );
  NOR2X0 U249 ( .IN1(n175), .IN2(n331), .QN(n318) );
  OR4X1 U250 ( .IN1(rx_countdown[3]), .IN2(rx_countdown[2]), .IN3(
        rx_countdown[1]), .IN4(n329), .Q(n176) );
  NOR4X0 U251 ( .IN1(rx_countdown[5]), .IN2(n319), .IN3(n318), .IN4(n176), 
        .QN(n182) );
  NOR2X0 U252 ( .IN1(rx_countdown[5]), .IN2(n247), .QN(n181) );
  OR4X1 U253 ( .IN1(rx_clk_divider[3]), .IN2(rx_clk_divider[2]), .IN3(
        rx_clk_divider[1]), .IN4(rx_clk_divider[0]), .Q(n177) );
  NOR2X0 U254 ( .IN1(rx_clk_divider[4]), .IN2(n177), .QN(n233) );
  INVX0 U255 ( .INP(n233), .ZN(n258) );
  NOR2X0 U256 ( .IN1(rx_clk_divider[5]), .IN2(n258), .QN(n259) );
  INVX0 U257 ( .INP(n259), .ZN(n260) );
  NOR2X0 U258 ( .IN1(rx_clk_divider[6]), .IN2(n260), .QN(n261) );
  XOR2X1 U259 ( .IN1(n333), .IN2(n261), .Q(n263) );
  NOR4X0 U260 ( .IN1(rx_clk_divider[3]), .IN2(rx_clk_divider[2]), .IN3(
        rx_clk_divider[1]), .IN4(n337), .QN(n180) );
  AND2X1 U261 ( .IN1(rx_clk_divider[4]), .IN2(n177), .Q(n232) );
  NOR4X0 U262 ( .IN1(rx_clk_divider[6]), .IN2(rx_clk_divider[5]), .IN3(n233), 
        .IN4(n232), .QN(n179) );
  AND2X1 U263 ( .IN1(rx_clk_divider[8]), .IN2(n192), .Q(n234) );
  NOR3X0 U264 ( .IN1(n234), .IN2(rx_clk_divider[9]), .IN3(rx_clk_divider[10]), 
        .QN(n178) );
  NAND4X0 U265 ( .IN1(n263), .IN2(n180), .IN3(n179), .IN4(n178), .QN(n187) );
  MUX21X1 U266 ( .IN1(n182), .IN2(n181), .S(n187), .Q(n206) );
  INVX0 U267 ( .INP(rx), .ZN(n186) );
  NAND2X0 U268 ( .IN1(n206), .IN2(n186), .QN(n302) );
  NAND2X0 U269 ( .IN1(recv_state[2]), .IN2(n183), .QN(n312) );
  NOR2X0 U270 ( .IN1(n336), .IN2(rst), .QN(n209) );
  INVX0 U271 ( .INP(n209), .ZN(n280) );
  NAND2X0 U272 ( .IN1(n183), .IN2(recv_state[1]), .QN(n207) );
  INVX0 U273 ( .INP(n207), .ZN(n185) );
  NOR2X0 U274 ( .IN1(n280), .IN2(n185), .QN(n303) );
  NAND2X0 U275 ( .IN1(n312), .IN2(n303), .QN(n296) );
  NAND2X0 U276 ( .IN1(n280), .IN2(n312), .QN(n239) );
  NOR2X0 U277 ( .IN1(n239), .IN2(n207), .QN(n294) );
  OA21X1 U278 ( .IN1(n302), .IN2(n296), .IN3(n290), .Q(n289) );
  NAND2X0 U279 ( .IN1(n209), .IN2(n185), .QN(n304) );
  MUX21X1 U280 ( .IN1(n304), .IN2(n206), .S(n312), .Q(n281) );
  OA22X1 U281 ( .IN1(n281), .IN2(n207), .IN3(n304), .IN4(n282), .Q(n184) );
  NAND2X0 U282 ( .IN1(n289), .IN2(n184), .QN(n154) );
  NOR2X0 U283 ( .IN1(rx_clk_divider[1]), .IN2(rx_clk_divider[0]), .QN(n190) );
  NOR2X0 U284 ( .IN1(n185), .IN2(n239), .QN(n245) );
  NOR2X0 U285 ( .IN1(n190), .IN2(n242), .QN(n189) );
  NAND2X0 U286 ( .IN1(rx_clk_divider[0]), .IN2(rx_clk_divider[1]), .QN(n188)
         );
  NAND2X0 U287 ( .IN1(n189), .IN2(n188), .QN(N182) );
  INVX0 U288 ( .INP(n190), .ZN(n255) );
  MUX21X1 U289 ( .IN1(n255), .IN2(n190), .S(rx_clk_divider[2]), .Q(n191) );
  INVX0 U290 ( .INP(n242), .ZN(n194) );
  NAND2X0 U291 ( .IN1(n191), .IN2(n194), .QN(N183) );
  NOR2X0 U292 ( .IN1(rx_clk_divider[8]), .IN2(n192), .QN(n235) );
  INVX0 U293 ( .INP(n235), .ZN(n264) );
  NOR2X0 U294 ( .IN1(rx_clk_divider[9]), .IN2(n264), .QN(n265) );
  XNOR2X1 U295 ( .IN1(n265), .IN2(rx_clk_divider[10]), .Q(n193) );
  INVX0 U296 ( .INP(n290), .ZN(n293) );
  NOR2X0 U297 ( .IN1(rx_bits_remaining[1]), .IN2(rx_bits_remaining[0]), .QN(
        n196) );
  AO21X1 U298 ( .IN1(n294), .IN2(rx_bits_remaining[0]), .IN3(n289), .Q(n195)
         );
  AO22X1 U299 ( .IN1(n293), .IN2(n196), .IN3(rx_bits_remaining[1]), .IN4(n195), 
        .Q(n145) );
  INVX0 U300 ( .INP(n196), .ZN(n197) );
  NOR2X0 U301 ( .IN1(rx_bits_remaining[2]), .IN2(n197), .QN(n283) );
  AO21X1 U302 ( .IN1(n293), .IN2(n197), .IN3(n289), .Q(n198) );
  AO22X1 U303 ( .IN1(n293), .IN2(n283), .IN3(rx_bits_remaining[2]), .IN4(n198), 
        .Q(n144) );
  INVX0 U304 ( .INP(n277), .ZN(n326) );
  NOR2X0 U305 ( .IN1(n199), .IN2(n326), .QN(n203) );
  NOR2X0 U306 ( .IN1(tx_clk_divider[8]), .IN2(n200), .QN(n251) );
  INVX0 U307 ( .INP(n251), .ZN(n278) );
  NOR2X0 U308 ( .IN1(tx_clk_divider[9]), .IN2(n278), .QN(n279) );
  XNOR2X1 U309 ( .IN1(tx_clk_divider[10]), .IN2(n279), .Q(n201) );
  NAND2X0 U310 ( .IN1(n202), .IN2(n203), .QN(N272) );
  NOR2X0 U311 ( .IN1(tx_clk_divider[1]), .IN2(tx_clk_divider[0]), .QN(n266) );
  INVX0 U312 ( .INP(n203), .ZN(n249) );
  NOR2X0 U313 ( .IN1(n266), .IN2(n249), .QN(n205) );
  NAND2X0 U314 ( .IN1(tx_clk_divider[0]), .IN2(tx_clk_divider[1]), .QN(n204)
         );
  INVX0 U315 ( .INP(n312), .ZN(n208) );
  INVX0 U316 ( .INP(n206), .ZN(n238) );
  NAND3X0 U317 ( .IN1(n208), .IN2(n238), .IN3(n207), .QN(n212) );
  NAND2X0 U318 ( .IN1(n209), .IN2(recv_state[2]), .QN(n211) );
  INVX0 U319 ( .INP(n303), .ZN(n311) );
  OA22X1 U320 ( .IN1(n238), .IN2(n304), .IN3(n282), .IN4(n311), .Q(n210) );
  NAND3X0 U321 ( .IN1(n212), .IN2(n211), .IN3(n210), .QN(n153) );
  NOR2X0 U322 ( .IN1(tx_bits_remaining[0]), .IN2(n213), .QN(n323) );
  AO21X1 U323 ( .IN1(tx_bits_remaining[0]), .IN2(n214), .IN3(n325), .Q(n215)
         );
  MUX21X1 U324 ( .IN1(n323), .IN2(n215), .S(tx_bits_remaining[1]), .Q(n126) );
  INVX0 U325 ( .INP(n217), .ZN(n219) );
  AO22X1 U326 ( .IN1(tx_state[1]), .IN2(n214), .IN3(n219), .IN4(n218), .Q(n220) );
  OR2X1 U327 ( .IN1(n221), .IN2(n220), .Q(n133) );
  NOR2X0 U328 ( .IN1(tx_countdown[1]), .IN2(tx_countdown[0]), .QN(n222) );
  MUX21X1 U329 ( .IN1(tx_countdown[2]), .IN2(n339), .S(n222), .Q(n223) );
  AO21X1 U330 ( .IN1(n223), .IN2(n322), .IN3(n321), .Q(n224) );
  MUX21X1 U331 ( .IN1(n224), .IN2(tx_countdown[2]), .S(n231), .Q(n130) );
  XOR2X1 U332 ( .IN1(tx_countdown[1]), .IN2(n328), .Q(n225) );
  AO22X1 U333 ( .IN1(tx_countdown[1]), .IN2(n231), .IN3(n230), .IN4(n225), .Q(
        n135) );
  MUX21X1 U334 ( .IN1(n335), .IN2(tx_countdown[5]), .S(n226), .Q(n227) );
  AO22X1 U335 ( .IN1(tx_countdown[5]), .IN2(n231), .IN3(n230), .IN4(n227), .Q(
        n134) );
  MUX21X1 U336 ( .IN1(n231), .IN2(n230), .S(n328), .Q(n131) );
  MUX21X1 U337 ( .IN1(tx_countdown[4]), .IN2(n330), .S(n228), .Q(n229) );
  AO22X1 U338 ( .IN1(tx_countdown[4]), .IN2(n231), .IN3(n230), .IN4(n229), .Q(
        n128) );
  OR3X1 U339 ( .IN1(n233), .IN2(n232), .IN3(n242), .Q(N185) );
  OR3X1 U340 ( .IN1(n235), .IN2(n234), .IN3(n242), .Q(N189) );
  NOR2X0 U341 ( .IN1(rx_countdown[1]), .IN2(rx_countdown[0]), .QN(n236) );
  AO21X1 U342 ( .IN1(rx_countdown[0]), .IN2(rx_countdown[1]), .IN3(n236), .Q(
        n241) );
  INVX0 U343 ( .INP(n296), .ZN(n237) );
  NAND2X0 U344 ( .IN1(n237), .IN2(n302), .QN(n240) );
  NAND2X0 U345 ( .IN1(n238), .IN2(n294), .QN(n306) );
  NAND3X0 U346 ( .IN1(n240), .IN2(n306), .IN3(n295), .QN(n246) );
  INVX0 U347 ( .INP(n287), .ZN(n262) );
  AO221X1 U348 ( .IN1(n241), .IN2(n245), .IN3(n241), .IN4(n246), .IN5(n262), 
        .Q(n244) );
  AOI21X1 U349 ( .IN1(n312), .IN2(n302), .IN3(n311), .QN(n243) );
  NOR3X0 U350 ( .IN1(n293), .IN2(n243), .IN3(n242), .QN(n314) );
  INVX0 U351 ( .INP(n314), .ZN(n316) );
  MUX21X1 U352 ( .IN1(rx_countdown[1]), .IN2(n244), .S(n316), .Q(n152) );
  AND2X1 U353 ( .IN1(rx), .IN2(n245), .Q(n308) );
  OA21X1 U354 ( .IN1(n308), .IN2(n246), .IN3(n316), .Q(n320) );
  MUX21X1 U355 ( .IN1(n314), .IN2(n320), .S(n329), .Q(n151) );
  MUX21X1 U356 ( .IN1(n340), .IN2(rx_countdown[5]), .S(n247), .Q(n248) );
  AO22X1 U357 ( .IN1(rx_countdown[5]), .IN2(n314), .IN3(n248), .IN4(n320), .Q(
        n147) );
  MUX21X1 U358 ( .IN1(n293), .IN2(n289), .S(rx_bits_remaining[0]), .Q(n146) );
  MUX21X1 U359 ( .IN1(rx), .IN2(rx_byte[7]), .S(n290), .Q(n143) );
  MUX21X1 U360 ( .IN1(rx_byte[7]), .IN2(rx_byte[6]), .S(n290), .Q(n142) );
  MUX21X1 U361 ( .IN1(rx_byte[6]), .IN2(rx_byte[5]), .S(n290), .Q(n141) );
  MUX21X1 U362 ( .IN1(rx_byte[5]), .IN2(rx_byte[4]), .S(n290), .Q(n140) );
  MUX21X1 U363 ( .IN1(rx_byte[4]), .IN2(rx_byte[3]), .S(n290), .Q(n139) );
  MUX21X1 U364 ( .IN1(rx_byte[3]), .IN2(rx_byte[2]), .S(n290), .Q(n138) );
  MUX21X1 U365 ( .IN1(rx_byte[2]), .IN2(rx_byte[1]), .S(n290), .Q(n137) );
  MUX21X1 U366 ( .IN1(rx_byte[1]), .IN2(rx_byte[0]), .S(n290), .Q(n136) );
  AO22X1 U367 ( .IN1(n325), .IN2(tx_data[7]), .IN3(n326), .IN4(tx_byte[7]), 
        .Q(n115) );
  OR3X1 U368 ( .IN1(n251), .IN2(n250), .IN3(n249), .Q(N276) );
  NOR2X0 U369 ( .IN1(n252), .IN2(tx_data[0]), .QN(n253) );
  OAI22X1 U370 ( .IN1(n254), .IN2(n344), .IN3(n253), .IN4(n322), .QN(n123) );
  OR3X1 U371 ( .IN1(recv_state[0]), .IN2(recv_state[2]), .IN3(recv_state[1]), 
        .Q(N298) );
  OR2X1 U372 ( .IN1(tx_state[1]), .IN2(tx_state[0]), .Q(N299) );
  NOR2X0 U373 ( .IN1(rx_clk_divider[0]), .IN2(n262), .QN(N181) );
  NOR2X0 U374 ( .IN1(rx_clk_divider[2]), .IN2(n255), .QN(n256) );
  XNOR2X1 U375 ( .IN1(rx_clk_divider[3]), .IN2(n256), .Q(n257) );
  NOR2X0 U376 ( .IN1(n257), .IN2(n262), .QN(N184) );
  OA221X1 U377 ( .IN1(n259), .IN2(rx_clk_divider[5]), .IN3(n259), .IN4(n258), 
        .IN5(n287), .Q(N186) );
  OA221X1 U378 ( .IN1(n261), .IN2(rx_clk_divider[6]), .IN3(n261), .IN4(n260), 
        .IN5(n287), .Q(N187) );
  NOR2X0 U379 ( .IN1(n263), .IN2(n262), .QN(N188) );
  OA221X1 U380 ( .IN1(n265), .IN2(rx_clk_divider[9]), .IN3(n265), .IN4(n264), 
        .IN5(n287), .Q(N190) );
  NOR2X0 U381 ( .IN1(tx_clk_divider[0]), .IN2(n326), .QN(N268) );
  INVX0 U382 ( .INP(n266), .ZN(n267) );
  NAND4X0 U383 ( .IN1(n270), .IN2(n269), .IN3(n277), .IN4(n268), .QN(N270) );
  OA221X1 U384 ( .IN1(n271), .IN2(tx_clk_divider[3]), .IN3(n271), .IN4(n270), 
        .IN5(n277), .Q(N271) );
  OA21X1 U385 ( .IN1(n273), .IN2(n272), .IN3(n277), .Q(N273) );
  OA221X1 U386 ( .IN1(n275), .IN2(tx_clk_divider[6]), .IN3(n275), .IN4(n274), 
        .IN5(n277), .Q(N274) );
  XOR2X1 U387 ( .IN1(n332), .IN2(n275), .Q(n276) );
  NOR2X0 U388 ( .IN1(n276), .IN2(n326), .QN(N275) );
  OA221X1 U389 ( .IN1(n279), .IN2(tx_clk_divider[9]), .IN3(n279), .IN4(n278), 
        .IN5(n277), .Q(N277) );
  AND3X1 U390 ( .IN1(recv_state[2]), .IN2(recv_state[0]), .IN3(n343), .Q(
        recv_error) );
  AND3X1 U391 ( .IN1(n336), .IN2(recv_state[2]), .IN3(recv_state[1]), .Q(
        received) );
  OA22X1 U392 ( .IN1(n281), .IN2(n280), .IN3(n302), .IN4(n304), .Q(n288) );
  OR2X1 U393 ( .IN1(n296), .IN2(n282), .Q(n286) );
  XOR2X1 U394 ( .IN1(rx_bits_remaining[3]), .IN2(n283), .Q(n292) );
  NOR2X0 U395 ( .IN1(rx_bits_remaining[2]), .IN2(n292), .QN(n284) );
  NAND4X0 U396 ( .IN1(n293), .IN2(rx_bits_remaining[0]), .IN3(n284), .IN4(n341), .QN(n285) );
  NAND4X0 U397 ( .IN1(n288), .IN2(n287), .IN3(n286), .IN4(n285), .QN(n156) );
  INVX0 U398 ( .INP(n289), .ZN(n300) );
  OA21X1 U399 ( .IN1(n300), .IN2(rx_bits_remaining[3]), .IN3(n290), .Q(n291)
         );
  AO21X1 U400 ( .IN1(n293), .IN2(n292), .IN3(n291), .Q(n155) );
  INVX0 U401 ( .INP(n294), .ZN(n297) );
  NAND3X0 U402 ( .IN1(n297), .IN2(n296), .IN3(n295), .QN(n299) );
  OA21X1 U403 ( .IN1(rx_countdown[1]), .IN2(rx_countdown[0]), .IN3(
        rx_countdown[2]), .Q(n298) );
  OA22X1 U404 ( .IN1(n308), .IN2(n299), .IN3(n310), .IN4(n298), .Q(n301) );
  AO221X1 U405 ( .IN1(n301), .IN2(n316), .IN3(n314), .IN4(rx_countdown[2]), 
        .IN5(n300), .Q(n150) );
  NAND4X0 U406 ( .IN1(n312), .IN2(n306), .IN3(n305), .IN4(n304), .QN(n307) );
  OA222X1 U407 ( .IN1(n310), .IN2(rx_countdown[3]), .IN3(n309), .IN4(n342), 
        .IN5(n308), .IN6(n307), .Q(n315) );
  NOR2X0 U408 ( .IN1(n312), .IN2(n311), .QN(n313) );
  AO221X1 U409 ( .IN1(n315), .IN2(n316), .IN3(n314), .IN4(rx_countdown[3]), 
        .IN5(n313), .Q(n149) );
  NOR2X0 U410 ( .IN1(n331), .IN2(n316), .QN(n317) );
  AO221X1 U411 ( .IN1(n320), .IN2(n319), .IN3(n320), .IN4(n318), .IN5(n317), 
        .Q(n148) );
  AO21X1 U412 ( .IN1(n214), .IN2(n322), .IN3(n321), .Q(n132) );
  AO21X1 U413 ( .IN1(n325), .IN2(tx_bits_remaining[0]), .IN3(n323), .Q(n127)
         );
  AO221X1 U414 ( .IN1(tx_bits_remaining[3]), .IN2(tx_bits_remaining[2]), .IN3(
        tx_bits_remaining[3]), .IN4(n324), .IN5(n326), .Q(n124) );
  AO222X1 U415 ( .IN1(n327), .IN2(tx_data[1]), .IN3(n326), .IN4(tx_byte[0]), 
        .IN5(n325), .IN6(tx_data[0]), .Q(n122) );
  AO222X1 U416 ( .IN1(n327), .IN2(tx_data[2]), .IN3(n326), .IN4(tx_byte[1]), 
        .IN5(tx_data[1]), .IN6(n325), .Q(n121) );
  AO222X1 U417 ( .IN1(n327), .IN2(tx_data[3]), .IN3(n326), .IN4(tx_byte[2]), 
        .IN5(tx_data[2]), .IN6(n325), .Q(n120) );
  AO222X1 U418 ( .IN1(n327), .IN2(tx_data[4]), .IN3(n326), .IN4(tx_byte[3]), 
        .IN5(tx_data[3]), .IN6(n325), .Q(n119) );
  AO222X1 U419 ( .IN1(n327), .IN2(tx_data[5]), .IN3(n326), .IN4(tx_byte[4]), 
        .IN5(tx_data[4]), .IN6(n325), .Q(n118) );
  AO222X1 U420 ( .IN1(n327), .IN2(tx_data[6]), .IN3(n326), .IN4(tx_byte[5]), 
        .IN5(tx_data[5]), .IN6(n325), .Q(n117) );
  AO222X1 U421 ( .IN1(n327), .IN2(tx_data[7]), .IN3(n326), .IN4(tx_byte[6]), 
        .IN5(tx_data[6]), .IN6(n325), .Q(n116) );
endmodule

