/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Mon Oct 11 13:21:28 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module u_xmit ( clk, rst, uart_xmitH, xmitH, xmit_dataH, xmit_doneH );
  input [7:0] xmit_dataH;
  input clk, rst, xmitH;
  output uart_xmitH, xmit_doneH;
  wire   N37, N38, N39, N40, N58, N59, N60, N61, N62, N63, N64, N65,
         Trojan_ena, N122, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n69, n70, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n106, n107;
  wire   [7:0] xmit_ShiftRegH;
  wire   [3:0] bitCell_cntrH/*verilator public*/;
  reg    [2:0] state/*verilator public*/;
  wire   [3:0] bitCountH/*verilator public*/;
  wire   [2:0] next_state;
  wire   [1:0] trojan_state;
  
  reg	 n105;
  
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
  //n103 = ~next_state[1];
  state[2] = next_state[2];
  end
end

  //DFFARX1 \state_reg[0]  ( .D(next_state[0]), .CLK(clk), .RSTB(rst), .Q(   state[0]), .QN(n105) );
  //DFFARX1 \state_reg[1]  ( .D(next_state[1]), .CLK(clk), .RSTB(rst), .Q(        state[1]), .QN() );
  //DFFARX1 \state_reg[2]  ( .D(next_state[2]), .CLK(clk), .RSTB(rst), .Q(        state[2]), .QN() );
  DFFARX1 \bitCell_cntrH_reg[0]  ( .D(N37), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[0]), .QN(n102) );
  DFFARX1 \bitCell_cntrH_reg[1]  ( .D(N38), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[1]), .QN(n104) );
  DFFARX1 \bitCell_cntrH_reg[2]  ( .D(N39), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[2]), .QN() );
  DFFARX1 \bitCell_cntrH_reg[3]  ( .D(N40), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[3]), .QN() );
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
  DFFARX1 \bitCountH_reg[3]  ( .D(n55), .CLK(clk), .RSTB(rst), .Q(bitCountH[3]), .QN(n103) );
  DFFARX1 \bitCountH_reg[0]  ( .D(n58), .CLK(clk), .RSTB(rst), .Q(bitCountH[0]), .QN() );
  DFFARX1 \bitCountH_reg[1]  ( .D(n57), .CLK(clk), .RSTB(rst), .Q(bitCountH[1]), .QN(n106) );
  DFFARX1 \bitCountH_reg[2]  ( .D(n56), .CLK(clk), .RSTB(rst), .Q(bitCountH[2]), .QN() );
  DFFARX1 \trojan_state_reg[0]  ( .D(n54), .CLK(clk), .RSTB(rst), .Q(
        trojan_state[0]), .QN(n107) );
  DFFARX1 \trojan_state_reg[1]  ( .D(n53), .CLK(clk), .RSTB(rst), .Q(
        trojan_state[1]), .QN() );
  DFFARX1 Trojan_ena_reg ( .D(n52), .CLK(clk), .RSTB(rst), .Q(Trojan_ena), 
        .QN() );
  DFFARX1 xmit_doneH_reg ( .D(N122), .CLK(clk), .RSTB(rst), .Q(xmit_doneH), 
        .QN() );
  NAND2X0 U78 ( .IN1(n86), .IN2(n84), .QN(n94) );
  NAND2X0 U79 ( .IN1(xmitH), .IN2(n75), .QN(n82) );
  NAND2X0 U80 ( .IN1(bitCell_cntrH[3]), .IN2(n69), .QN(n78) );
  NAND2X0 U81 ( .IN1(n85), .IN2(n77), .QN(n60) );
  NAND2X0 U82 ( .IN1(n62), .IN2(n73), .QN(next_state[2]) );
  NAND2X0 U83 ( .IN1(state[0]), .IN2(state[1]), .QN(n72) );
  INVX0 U84 ( .INP(n72), .ZN(n64) );
  NAND2X0 U85 ( .IN1(state[2]), .IN2(n105), .QN(n98) );
  INVX0 U86 ( .INP(n98), .ZN(n81) );
  NOR2X0 U87 ( .IN1(n64), .IN2(n81), .QN(n61) );
  NOR2X0 U88 ( .IN1(state[1]), .IN2(state[2]), .QN(n75) );
  INVX0 U89 ( .INP(n75), .ZN(n85) );
  NAND2X0 U90 ( .IN1(state[0]), .IN2(state[2]), .QN(n77) );
  NOR2X0 U91 ( .IN1(n61), .IN2(n60), .QN(n59) );
  AO22X1 U92 ( .IN1(n61), .IN2(n60), .IN3(xmit_ShiftRegH[0]), .IN4(n59), .Q(
        uart_xmitH) );
  NAND4X0 U93 ( .IN1(bitCell_cntrH[2]), .IN2(bitCell_cntrH[1]), .IN3(
        bitCell_cntrH[3]), .IN4(n102), .QN(n63) );
  NOR2X0 U94 ( .IN1(n72), .IN2(n63), .QN(n86) );
  INVX0 U95 ( .INP(n86), .ZN(n62) );
  AND3X1 U96 ( .IN1(bitCell_cntrH[1]), .IN2(bitCell_cntrH[2]), .IN3(
        bitCell_cntrH[0]), .Q(n69) );
  NAND3X0 U97 ( .IN1(state[2]), .IN2(state[0]), .IN3(n78), .QN(n73) );
  NAND2X0 U98 ( .IN1(n105), .IN2(state[1]), .QN(n97) );
  NAND2X0 U99 ( .IN1(n64), .IN2(n63), .QN(n76) );
  AND2X1 U100 ( .IN1(n73), .IN2(n76), .Q(n65) );
  NAND2X0 U101 ( .IN1(n97), .IN2(n65), .QN(n70) );
  INVX0 U102 ( .INP(n70), .ZN(n68) );
  NOR2X0 U103 ( .IN1(bitCell_cntrH[0]), .IN2(n68), .QN(N37) );
  OA221X1 U104 ( .IN1(bitCell_cntrH[0]), .IN2(bitCell_cntrH[1]), .IN3(n102), 
        .IN4(n104), .IN5(n70), .Q(N38) );
  NOR2X0 U105 ( .IN1(n104), .IN2(n102), .QN(n66) );
  NOR2X0 U106 ( .IN1(bitCell_cntrH[2]), .IN2(n66), .QN(n67) );
  NOR3X0 U107 ( .IN1(n69), .IN2(n68), .IN3(n67), .QN(N39) );
  OA221X1 U109 ( .IN1(1'b0), .IN2(n70), .IN3(bitCell_cntrH[3]), .IN4(n69), 
        .IN5(n78), .Q(N40) );
  OR4X1 U110 ( .IN1(n103), .IN2(bitCountH[1]), .IN3(bitCountH[2]), .IN4(
        bitCountH[0]), .Q(n84) );
  OA22X1 U111 ( .IN1(n72), .IN2(n84), .IN3(n97), .IN4(n78), .Q(n74) );
  NAND4X0 U112 ( .IN1(n74), .IN2(n73), .IN3(n76), .IN4(n98), .QN(next_state[0]) );
  INVX0 U113 ( .INP(n82), .ZN(n83) );
  NOR2X0 U114 ( .IN1(n81), .IN2(n83), .QN(n80) );
  NAND3X0 U115 ( .IN1(n80), .IN2(n97), .IN3(n76), .QN(next_state[1]) );
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
        .Q(n88) );
  NOR2X0 U127 ( .IN1(bitCountH[0]), .IN2(n94), .QN(n87) );
  AO21X1 U128 ( .IN1(n88), .IN2(bitCountH[0]), .IN3(n87), .Q(n58) );
  NAND2X0 U129 ( .IN1(n86), .IN2(bitCountH[0]), .QN(n90) );
  NOR2X0 U130 ( .IN1(n88), .IN2(n87), .QN(n91) );
  MUX21X1 U131 ( .IN1(n90), .IN2(n91), .S(bitCountH[1]), .Q(n89) );
  INVX0 U132 ( .INP(n89), .ZN(n57) );
  NOR2X0 U133 ( .IN1(n106), .IN2(n90), .QN(n96) );
  OA21X1 U134 ( .IN1(bitCountH[1]), .IN2(n94), .IN3(n91), .Q(n93) );
  INVX0 U135 ( .INP(n93), .ZN(n92) );
  MUX21X1 U136 ( .IN1(n96), .IN2(n92), .S(bitCountH[2]), .Q(n56) );
  OAI21X1 U137 ( .IN1(bitCountH[2]), .IN2(n94), .IN3(n93), .QN(n95) );
  OA222X1 U138 ( .IN1(bitCountH[3]), .IN2(bitCountH[2]), .IN3(bitCountH[3]), 
        .IN4(n96), .IN5(n103), .IN6(n95), .Q(n55) );
  NOR2X0 U139 ( .IN1(n97), .IN2(state[2]), .QN(n101) );
  INVX0 U140 ( .INP(n101), .ZN(n100) );
  NOR3X0 U141 ( .IN1(state[1]), .IN2(trojan_state[1]), .IN3(n98), .QN(n99) );
  AO221X1 U142 ( .IN1(trojan_state[0]), .IN2(trojan_state[1]), .IN3(
        trojan_state[0]), .IN4(n100), .IN5(n99), .Q(n54) );
  AO21X1 U143 ( .IN1(trojan_state[0]), .IN2(n101), .IN3(trojan_state[1]), .Q(
        n53) );
  AO21X1 U144 ( .IN1(trojan_state[1]), .IN2(n107), .IN3(Trojan_ena), .Q(n52)
         );
endmodule

