/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Thu Feb 24 17:06:56 2022
/////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module tap_top ( tms_pad_i, tck_pad_i, trstn_pad_i, tdi_pad_i, tdo_pad_o, 
        tdo_padoe_o, test_logic_reset_o, run_test_idle_o, shift_dr_o, 
        pause_dr_o, update_dr_o, capture_dr_o, extest_select_o, 
        sample_preload_select_o, mbist_select_o, debug_select_o, tdi_o, 
        debug_tdo_i, bs_chain_tdo_i, mbist_tdo_i );
  input tms_pad_i, tck_pad_i, trstn_pad_i, tdi_pad_i, debug_tdo_i,
         bs_chain_tdo_i, mbist_tdo_i;
  output tdo_pad_o, tdo_padoe_o, test_logic_reset_o, run_test_idle_o,
         shift_dr_o, pause_dr_o, update_dr_o, capture_dr_o, extest_select_o,
         sample_preload_select_o, mbist_select_o, debug_select_o, tdi_o;
  wire   tdi_o, tdo_mux_out, N309, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n128, n133, n182, n183, n184,
         n185, n186, n187, n188, n189, n190, n191, n192, n193, n194, n195,
         n197, n198, n199, n200, n201, n202, n203, n204, n205, n206, n207,
         n208, n209, n210, n211, n212, n213, n214, n215, n216, n217, n218,
         n219, n220, n221, n222, n223, n224, n225, n226;
  wire   [3:0] TAP_state/*verilator public*/;
  wire   [3:0] jtag_ir;
  wire   [3:0] latched_jtag_ir;
  wire   [31:0] idcode_reg;
  assign tdi_o = tdi_pad_i;

  DFFASX1 \TAP_state_reg[0]  ( .D(n87), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(TAP_state[0]), .QN(n226) );
  DFFASX1 \TAP_state_reg[1]  ( .D(n86), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(n220), .QN(n128) );
  DFFASX1 \TAP_state_reg[2]  ( .D(n89), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(TAP_state[2]), .QN(n223) );
  DFFASX1 \TAP_state_reg[3]  ( .D(n88), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(TAP_state[3]), .QN(n222) );
  DFFASX1 \idcode_reg_reg[28]  ( .D(n50), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[28]) );
  DFFASX1 \idcode_reg_reg[26]  ( .D(n52), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[26]) );
  DFFASX1 \idcode_reg_reg[23]  ( .D(n55), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[23]) );
  DFFASX1 \idcode_reg_reg[20]  ( .D(n58), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[20]) );
  DFFASX1 \idcode_reg_reg[18]  ( .D(n60), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[18]) );
  DFFASX1 \idcode_reg_reg[16]  ( .D(n62), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[16]) );
  DFFASX1 \idcode_reg_reg[12]  ( .D(n66), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[12]) );
  DFFASX1 \idcode_reg_reg[8]  ( .D(n70), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[8]) );
  DFFASX1 \idcode_reg_reg[7]  ( .D(n71), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[7]) );
  DFFASX1 \idcode_reg_reg[6]  ( .D(n72), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[6]) );
  DFFASX1 \idcode_reg_reg[1]  ( .D(n77), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[1]) );
  DFFASX1 \idcode_reg_reg[0]  ( .D(n46), .CLK(tck_pad_i), .SETB(trstn_pad_i), 
        .Q(idcode_reg[0]) );
  DFFARX1 \jtag_ir_reg[3]  ( .D(n83), .CLK(tck_pad_i), .RSTB(trstn_pad_i), .Q(
        jtag_ir[3]) );
  DFFARX1 \jtag_ir_reg[2]  ( .D(n84), .CLK(tck_pad_i), .RSTB(trstn_pad_i), .Q(
        jtag_ir[2]) );
  DFFARX1 \jtag_ir_reg[1]  ( .D(n85), .CLK(tck_pad_i), .RSTB(trstn_pad_i), .Q(
        jtag_ir[1]) );
  DFFARX1 \jtag_ir_reg[0]  ( .D(n82), .CLK(tck_pad_i), .RSTB(trstn_pad_i), .Q(
        jtag_ir[0]) );
  DFFARX1 \idcode_reg_reg[31]  ( .D(n47), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[31]) );
  DFFARX1 \idcode_reg_reg[30]  ( .D(n48), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[30]) );
  DFFARX1 \idcode_reg_reg[29]  ( .D(n49), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[29]) );
  DFFARX1 \idcode_reg_reg[27]  ( .D(n51), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[27]) );
  DFFARX1 \idcode_reg_reg[25]  ( .D(n53), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[25]) );
  DFFARX1 \idcode_reg_reg[24]  ( .D(n54), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[24]) );
  DFFARX1 \idcode_reg_reg[22]  ( .D(n56), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[22]) );
  DFFARX1 \idcode_reg_reg[21]  ( .D(n57), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[21]) );
  DFFARX1 \idcode_reg_reg[19]  ( .D(n59), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[19]) );
  DFFARX1 \idcode_reg_reg[17]  ( .D(n61), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[17]) );
  DFFARX1 \idcode_reg_reg[15]  ( .D(n63), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[15]) );
  DFFARX1 \idcode_reg_reg[14]  ( .D(n64), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[14]) );
  DFFARX1 \idcode_reg_reg[13]  ( .D(n65), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[13]) );
  DFFARX1 \idcode_reg_reg[11]  ( .D(n67), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[11]) );
  DFFARX1 \idcode_reg_reg[10]  ( .D(n68), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[10]) );
  DFFARX1 \idcode_reg_reg[9]  ( .D(n69), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[9]) );
  DFFARX1 \idcode_reg_reg[5]  ( .D(n73), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[5]) );
  DFFARX1 \idcode_reg_reg[4]  ( .D(n74), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[4]) );
  DFFARX1 \idcode_reg_reg[3]  ( .D(n75), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[3]) );
  DFFARX1 \idcode_reg_reg[2]  ( .D(n76), .CLK(tck_pad_i), .RSTB(trstn_pad_i), 
        .Q(idcode_reg[2]) );
  DFFARX1 bypass_reg_reg ( .D(n45), .CLK(tck_pad_i), .RSTB(trstn_pad_i), .QN(
        n133) );
  DFFNARX1 \latched_jtag_ir_reg[3]  ( .D(n81), .CLK(tck_pad_i), .RSTB(
        trstn_pad_i), .Q(latched_jtag_ir[3]), .QN(n221) );
  DFFNARX1 \latched_jtag_ir_reg[2]  ( .D(n80), .CLK(tck_pad_i), .RSTB(
        trstn_pad_i), .Q(latched_jtag_ir[2]), .QN(n219) );
  DFFNARX1 \latched_jtag_ir_reg[0]  ( .D(n78), .CLK(tck_pad_i), .RSTB(
        trstn_pad_i), .Q(latched_jtag_ir[0]), .QN(n224) );
  DFFNASX1 \latched_jtag_ir_reg[1]  ( .D(n79), .CLK(tck_pad_i), .SETB(
        trstn_pad_i), .Q(latched_jtag_ir[1]), .QN(n225) );
  DFFNX1 tdo_pad_o_reg ( .D(tdo_mux_out), .CLK(tck_pad_i), .Q(tdo_pad_o) );
  DFFX1 tdo_padoe_o_reg ( .D(N309), .CLK(tck_pad_i), .Q(tdo_padoe_o) );
  NAND2X0 U209 ( .IN1(mbist_select_o), .IN2(mbist_tdo_i), .QN(n189) );
  NAND2X0 U210 ( .IN1(latched_jtag_ir[3]), .IN2(n215), .QN(n185) );
  NAND2X0 U211 ( .IN1(n220), .IN2(n226), .QN(n213) );
  NOR2X0 U212 ( .IN1(TAP_state[2]), .IN2(n213), .QN(N309) );
  AND2X1 U213 ( .IN1(n222), .IN2(N309), .Q(shift_dr_o) );
  NAND3X0 U214 ( .IN1(TAP_state[3]), .IN2(TAP_state[0]), .IN3(TAP_state[2]), 
        .QN(n200) );
  NOR2X0 U215 ( .IN1(n128), .IN2(n200), .QN(test_logic_reset_o) );
  AND2X1 U216 ( .IN1(TAP_state[3]), .IN2(N309), .Q(n192) );
  NOR2X0 U217 ( .IN1(n222), .IN2(n213), .QN(n205) );
  NOR2X0 U218 ( .IN1(test_logic_reset_o), .IN2(n205), .QN(n207) );
  AO22X1 U219 ( .IN1(n192), .IN2(tdi_o), .IN3(n207), .IN4(jtag_ir[3]), .Q(n83)
         );
  NOR3X0 U220 ( .IN1(TAP_state[3]), .IN2(n213), .IN3(n223), .QN(capture_dr_o)
         );
  NOR2X0 U221 ( .IN1(latched_jtag_ir[2]), .IN2(latched_jtag_ir[1]), .QN(n215)
         );
  NOR2X0 U222 ( .IN1(n224), .IN2(n185), .QN(mbist_select_o) );
  INVX0 U223 ( .INP(tms_pad_i), .ZN(n197) );
  NAND2X0 U224 ( .IN1(TAP_state[3]), .IN2(TAP_state[2]), .QN(n182) );
  NAND3X0 U225 ( .IN1(TAP_state[0]), .IN2(n220), .IN3(n182), .QN(n183) );
  OA222X1 U226 ( .IN1(tms_pad_i), .IN2(TAP_state[0]), .IN3(tms_pad_i), .IN4(
        n223), .IN5(n197), .IN6(n183), .Q(n87) );
  AO22X1 U227 ( .IN1(n128), .IN2(tms_pad_i), .IN3(TAP_state[2]), .IN4(n213), 
        .Q(n89) );
  AO22X1 U228 ( .IN1(n192), .IN2(jtag_ir[2]), .IN3(n207), .IN4(jtag_ir[1]), 
        .Q(n85) );
  NAND3X0 U229 ( .IN1(n219), .IN2(n224), .IN3(n221), .QN(n212) );
  NOR2X0 U230 ( .IN1(n225), .IN2(n212), .QN(n186) );
  NAND2X0 U231 ( .IN1(n186), .IN2(shift_dr_o), .QN(n209) );
  INVX0 U232 ( .INP(n209), .ZN(n210) );
  AO21X1 U233 ( .IN1(n186), .IN2(capture_dr_o), .IN3(test_logic_reset_o), .Q(
        n208) );
  NOR2X0 U234 ( .IN1(n210), .IN2(n208), .QN(n184) );
  AO22X1 U235 ( .IN1(n210), .IN2(tdi_o), .IN3(n184), .IN4(idcode_reg[31]), .Q(
        n47) );
  AO22X1 U236 ( .IN1(n210), .IN2(idcode_reg[31]), .IN3(n184), .IN4(
        idcode_reg[30]), .Q(n48) );
  AO22X1 U237 ( .IN1(n210), .IN2(idcode_reg[30]), .IN3(n184), .IN4(
        idcode_reg[29]), .Q(n49) );
  AO22X1 U238 ( .IN1(n210), .IN2(idcode_reg[28]), .IN3(n184), .IN4(
        idcode_reg[27]), .Q(n51) );
  AO22X1 U239 ( .IN1(n210), .IN2(idcode_reg[26]), .IN3(n184), .IN4(
        idcode_reg[25]), .Q(n53) );
  AO22X1 U240 ( .IN1(n210), .IN2(idcode_reg[25]), .IN3(n184), .IN4(
        idcode_reg[24]), .Q(n54) );
  AO22X1 U241 ( .IN1(n210), .IN2(idcode_reg[23]), .IN3(n184), .IN4(
        idcode_reg[22]), .Q(n56) );
  AO22X1 U242 ( .IN1(n210), .IN2(idcode_reg[22]), .IN3(n184), .IN4(
        idcode_reg[21]), .Q(n57) );
  AO22X1 U243 ( .IN1(n210), .IN2(idcode_reg[20]), .IN3(n184), .IN4(
        idcode_reg[19]), .Q(n59) );
  AO22X1 U244 ( .IN1(n210), .IN2(idcode_reg[18]), .IN3(n184), .IN4(
        idcode_reg[17]), .Q(n61) );
  AO22X1 U245 ( .IN1(n210), .IN2(idcode_reg[16]), .IN3(n184), .IN4(
        idcode_reg[15]), .Q(n63) );
  AO22X1 U246 ( .IN1(n210), .IN2(idcode_reg[15]), .IN3(n184), .IN4(
        idcode_reg[14]), .Q(n64) );
  AO22X1 U247 ( .IN1(n210), .IN2(idcode_reg[14]), .IN3(n184), .IN4(
        idcode_reg[13]), .Q(n65) );
  AO22X1 U248 ( .IN1(n210), .IN2(idcode_reg[12]), .IN3(n184), .IN4(
        idcode_reg[11]), .Q(n67) );
  AO22X1 U249 ( .IN1(n210), .IN2(idcode_reg[11]), .IN3(n184), .IN4(
        idcode_reg[10]), .Q(n68) );
  AO22X1 U250 ( .IN1(n210), .IN2(idcode_reg[10]), .IN3(n184), .IN4(
        idcode_reg[9]), .Q(n69) );
  AO22X1 U251 ( .IN1(n210), .IN2(idcode_reg[6]), .IN3(n184), .IN4(
        idcode_reg[5]), .Q(n73) );
  AO22X1 U252 ( .IN1(n210), .IN2(idcode_reg[5]), .IN3(n184), .IN4(
        idcode_reg[4]), .Q(n74) );
  AO22X1 U253 ( .IN1(n210), .IN2(idcode_reg[4]), .IN3(n184), .IN4(
        idcode_reg[3]), .Q(n75) );
  AO22X1 U254 ( .IN1(n210), .IN2(idcode_reg[3]), .IN3(n184), .IN4(
        idcode_reg[2]), .Q(n76) );
  NAND2X0 U255 ( .IN1(n128), .IN2(TAP_state[2]), .QN(n199) );
  NOR2X0 U256 ( .IN1(n200), .IN2(n199), .QN(n195) );
  AO22X1 U257 ( .IN1(latched_jtag_ir[3]), .IN2(n200), .IN3(jtag_ir[3]), .IN4(
        n195), .Q(n81) );
  AO22X1 U258 ( .IN1(latched_jtag_ir[2]), .IN2(n200), .IN3(jtag_ir[2]), .IN4(
        n195), .Q(n80) );
  AO22X1 U259 ( .IN1(latched_jtag_ir[0]), .IN2(n200), .IN3(jtag_ir[0]), .IN4(
        n195), .Q(n78) );
  NOR2X0 U260 ( .IN1(latched_jtag_ir[0]), .IN2(n185), .QN(debug_select_o) );
  AOI22X1 U261 ( .IN1(debug_select_o), .IN2(debug_tdo_i), .IN3(idcode_reg[0]), 
        .IN4(n186), .QN(n191) );
  NOR2X0 U262 ( .IN1(latched_jtag_ir[0]), .IN2(latched_jtag_ir[3]), .QN(n187)
         );
  AO221X1 U263 ( .IN1(n219), .IN2(n187), .IN3(n219), .IN4(n225), .IN5(n133), 
        .Q(n190) );
  NAND3X0 U264 ( .IN1(n215), .IN2(bs_chain_tdo_i), .IN3(n221), .QN(n188) );
  NAND4X0 U265 ( .IN1(n191), .IN2(n190), .IN3(n189), .IN4(n188), .QN(n193) );
  MUX21X1 U266 ( .IN1(n193), .IN2(jtag_ir[0]), .S(n192), .Q(tdo_mux_out) );
  NOR4X0 U267 ( .IN1(TAP_state[3]), .IN2(n128), .IN3(TAP_state[2]), .IN4(n226), 
        .QN(pause_dr_o) );
  NOR2X0 U268 ( .IN1(TAP_state[0]), .IN2(n199), .QN(n203) );
  AND2X1 U269 ( .IN1(TAP_state[3]), .IN2(n203), .Q(run_test_idle_o) );
  AND2X1 U271 ( .IN1(n200), .IN2(latched_jtag_ir[1]), .Q(n194) );
  AO221X1 U272 ( .IN1(1'b1), .IN2(test_logic_reset_o), .IN3(jtag_ir[1]), .IN4(
        n195), .IN5(n194), .Q(n79) );
  AND3X1 U273 ( .IN1(latched_jtag_ir[0]), .IN2(n215), .IN3(n221), .Q(
        sample_preload_select_o) );
  INVX0 U274 ( .INP(n199), .ZN(n198) );
  AND3X1 U275 ( .IN1(TAP_state[0]), .IN2(n198), .IN3(n222), .Q(update_dr_o) );
  NOR2X0 U276 ( .IN1(latched_jtag_ir[1]), .IN2(n212), .QN(extest_select_o) );
  AO222X1 U277 ( .IN1(TAP_state[3]), .IN2(n199), .IN3(n222), .IN4(n203), .IN5(
        n198), .IN6(n197), .Q(n88) );
  NAND2X0 U278 ( .IN1(n200), .IN2(n199), .QN(n202) );
  NOR2X0 U279 ( .IN1(n202), .IN2(tms_pad_i), .QN(n201) );
  AO221X1 U280 ( .IN1(n203), .IN2(n222), .IN3(n202), .IN4(tms_pad_i), .IN5(
        n201), .Q(n86) );
  OA21X1 U281 ( .IN1(TAP_state[2]), .IN2(jtag_ir[3]), .IN3(n205), .Q(n204) );
  AO21X1 U282 ( .IN1(n207), .IN2(jtag_ir[2]), .IN3(n204), .Q(n84) );
  OA21X1 U283 ( .IN1(TAP_state[2]), .IN2(jtag_ir[1]), .IN3(n205), .Q(n206) );
  AO21X1 U284 ( .IN1(jtag_ir[0]), .IN2(n207), .IN3(n206), .Q(n82) );
  AO221X1 U285 ( .IN1(n210), .IN2(idcode_reg[2]), .IN3(n209), .IN4(
        idcode_reg[1]), .IN5(n208), .Q(n77) );
  AO221X1 U286 ( .IN1(n210), .IN2(idcode_reg[7]), .IN3(n209), .IN4(
        idcode_reg[6]), .IN5(n208), .Q(n72) );
  AO221X1 U287 ( .IN1(n210), .IN2(idcode_reg[8]), .IN3(n209), .IN4(
        idcode_reg[7]), .IN5(n208), .Q(n71) );
  AO221X1 U288 ( .IN1(n210), .IN2(idcode_reg[9]), .IN3(n209), .IN4(
        idcode_reg[8]), .IN5(n208), .Q(n70) );
  AO221X1 U289 ( .IN1(n210), .IN2(idcode_reg[13]), .IN3(n209), .IN4(
        idcode_reg[12]), .IN5(n208), .Q(n66) );
  AO221X1 U290 ( .IN1(n210), .IN2(idcode_reg[17]), .IN3(n209), .IN4(
        idcode_reg[16]), .IN5(n208), .Q(n62) );
  AO221X1 U291 ( .IN1(n210), .IN2(idcode_reg[19]), .IN3(n209), .IN4(
        idcode_reg[18]), .IN5(n208), .Q(n60) );
  AO221X1 U292 ( .IN1(n210), .IN2(idcode_reg[21]), .IN3(n209), .IN4(
        idcode_reg[20]), .IN5(n208), .Q(n58) );
  AO221X1 U293 ( .IN1(n210), .IN2(idcode_reg[24]), .IN3(n209), .IN4(
        idcode_reg[23]), .IN5(n208), .Q(n55) );
  AO221X1 U294 ( .IN1(n210), .IN2(idcode_reg[27]), .IN3(n209), .IN4(
        idcode_reg[26]), .IN5(n208), .Q(n52) );
  AO221X1 U295 ( .IN1(n210), .IN2(idcode_reg[29]), .IN3(n209), .IN4(
        idcode_reg[28]), .IN5(n208), .Q(n50) );
  AO221X1 U296 ( .IN1(n210), .IN2(idcode_reg[1]), .IN3(n209), .IN4(
        idcode_reg[0]), .IN5(n208), .Q(n46) );
  INVX0 U297 ( .INP(capture_dr_o), .ZN(n211) );
  NAND2X0 U298 ( .IN1(tdi_o), .IN2(n211), .QN(n217) );
  INVX0 U299 ( .INP(n212), .ZN(n214) );
  NOR4X0 U300 ( .IN1(n215), .IN2(n214), .IN3(TAP_state[3]), .IN4(n213), .QN(
        n216) );
  MUX21X1 U301 ( .IN1(n133), .IN2(n217), .S(n216), .Q(n218) );
  NOR2X0 U302 ( .IN1(test_logic_reset_o), .IN2(n218), .QN(n45) );
endmodule
