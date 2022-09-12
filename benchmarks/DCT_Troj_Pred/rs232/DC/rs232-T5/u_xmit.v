/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Mon Oct 11 13:25:04 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module u_xmit ( clk, rst, uart_xmitH, xmitH, xmit_dataH, xmit_doneH );
  input [7:0] xmit_dataH;
  input clk, rst, xmitH;
  output uart_xmitH, xmit_doneH;
  wire   N37, N38, N39, N40, N58, N59, N60, N61, N62, N63, N64, N65,
         Trojan_ena, N122, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105,  n107, n108;
  wire   [7:0] xmit_ShiftRegH;
  wire   [3:0] bitCell_cntrH/*verilator public*/;
  reg    [2:0] state/*verilator public*/;
  wire   [3:0] bitCountH/*verilator public*/;
  wire   [2:0] next_state;
  wire   [1:0] trojan_state;

  reg	 n106;
  
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
  n106 = ~next_state[0];
  state[1] = next_state[1];
  //n104 = ~next_state[1];
  state[2] = next_state[2];
  end
end

  //DFFARX1 \state_reg[0]  ( .D(next_state[0]), .CLK(clk), .RSTB(rst), .Q(        state[0]), .QN(n106) );
  //DFFARX1 \state_reg[1]  ( .D(next_state[1]), .CLK(clk), .RSTB(rst), .Q(        state[1]), .QN() );
  //DFFARX1 \state_reg[2]  ( .D(next_state[2]), .CLK(clk), .RSTB(rst), .Q(        state[2]), .QN() );
  DFFARX1 \bitCell_cntrH_reg[0]  ( .D(N37), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[0]), .QN(n103) );
  DFFARX1 \bitCell_cntrH_reg[1]  ( .D(N38), .CLK(clk), .RSTB(rst), .Q(
        bitCell_cntrH[1]), .QN(n105) );
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
  DFFARX1 \bitCountH_reg[3]  ( .D(n55), .CLK(clk), .RSTB(rst), .Q(bitCountH[3]), .QN(n104) );
  DFFARX1 \bitCountH_reg[0]  ( .D(n58), .CLK(clk), .RSTB(rst), .Q(bitCountH[0]), .QN() );
  DFFARX1 \bitCountH_reg[1]  ( .D(n57), .CLK(clk), .RSTB(rst), .Q(bitCountH[1]), .QN(n107) );
  DFFARX1 \bitCountH_reg[2]  ( .D(n56), .CLK(clk), .RSTB(rst), .Q(bitCountH[2]), .QN() );
  DFFARX1 \trojan_state_reg[0]  ( .D(n54), .CLK(clk), .RSTB(rst), .Q(
        trojan_state[0]), .QN(n108) );
  DFFARX1 \trojan_state_reg[1]  ( .D(n53), .CLK(clk), .RSTB(rst), .Q(
        trojan_state[1]), .QN() );
  DFFARX1 Trojan_ena_reg ( .D(n52), .CLK(clk), .RSTB(rst), .Q(Trojan_ena), 
        .QN() );
  DFFARX1 xmit_doneH_reg ( .D(N122), .CLK(clk), .RSTB(rst), .Q(xmit_doneH), 
        .QN() );
  NAND2X0 U78 ( .IN1(n87), .IN2(n85), .QN(n95) );
  NAND2X0 U79 ( .IN1(xmitH), .IN2(n77), .QN(n83) );
  NAND2X0 U80 ( .IN1(bitCell_cntrH[3]), .IN2(n70), .QN(n79) );
  NAND2X0 U81 ( .IN1(n86), .IN2(n99), .QN(n60) );
  NAND2X0 U82 ( .IN1(n63), .IN2(n75), .QN(next_state[2]) );
  NAND2X0 U83 ( .IN1(state[0]), .IN2(state[1]), .QN(n73) );
  INVX0 U84 ( .INP(n73), .ZN(n65) );
  NAND2X0 U85 ( .IN1(state[2]), .IN2(n106), .QN(n74) );
  INVX0 U86 ( .INP(n74), .ZN(n82) );
  NOR2X0 U87 ( .IN1(n65), .IN2(n82), .QN(n61) );
  NOR2X0 U88 ( .IN1(state[1]), .IN2(state[2]), .QN(n77) );
  INVX0 U89 ( .INP(n77), .ZN(n86) );
  NAND2X0 U90 ( .IN1(state[0]), .IN2(state[2]), .QN(n99) );
  NOR2X0 U91 ( .IN1(n61), .IN2(n60), .QN(n59) );
  AO22X1 U92 ( .IN1(n61), .IN2(n60), .IN3(xmit_ShiftRegH[0]), .IN4(n59), .Q(
        uart_xmitH) );
  NAND4X0 U93 ( .IN1(bitCell_cntrH[2]), .IN2(bitCell_cntrH[1]), .IN3(
        bitCell_cntrH[3]), .IN4(n103), .QN(n64) );
  NOR2X0 U94 ( .IN1(n73), .IN2(n64), .QN(n87) );
  INVX0 U95 ( .INP(n87), .ZN(n63) );
  INVX0 U96 ( .INP(n99), .ZN(n62) );
  AND3X1 U97 ( .IN1(bitCell_cntrH[1]), .IN2(bitCell_cntrH[2]), .IN3(
        bitCell_cntrH[0]), .Q(n70) );
  NAND2X0 U98 ( .IN1(n62), .IN2(n79), .QN(n75) );
  NAND2X0 U99 ( .IN1(n106), .IN2(state[1]), .QN(n98) );
  NAND2X0 U100 ( .IN1(n65), .IN2(n64), .QN(n78) );
  AND2X1 U101 ( .IN1(n75), .IN2(n78), .Q(n66) );
  NAND2X0 U102 ( .IN1(n98), .IN2(n66), .QN(n71) );
  INVX0 U103 ( .INP(n71), .ZN(n69) );
  NOR2X0 U104 ( .IN1(bitCell_cntrH[0]), .IN2(n69), .QN(N37) );
  OA221X1 U105 ( .IN1(bitCell_cntrH[0]), .IN2(bitCell_cntrH[1]), .IN3(n103), 
        .IN4(n105), .IN5(n71), .Q(N38) );
  NOR2X0 U106 ( .IN1(n105), .IN2(n103), .QN(n67) );
  NOR2X0 U107 ( .IN1(bitCell_cntrH[2]), .IN2(n67), .QN(n68) );
  NOR3X0 U108 ( .IN1(n70), .IN2(n69), .IN3(n68), .QN(N39) );
  OA221X1 U110 ( .IN1(1'b0), .IN2(n71), .IN3(bitCell_cntrH[3]), .IN4(n70), 
        .IN5(n79), .Q(N40) );
  OR4X1 U111 ( .IN1(n104), .IN2(bitCountH[1]), .IN3(bitCountH[2]), .IN4(
        bitCountH[0]), .Q(n85) );
  OA22X1 U112 ( .IN1(n73), .IN2(n85), .IN3(n98), .IN4(n79), .Q(n76) );
  NAND4X0 U113 ( .IN1(n76), .IN2(n75), .IN3(n78), .IN4(n74), .QN(next_state[0]) );
  INVX0 U114 ( .INP(n83), .ZN(n84) );
  NOR2X0 U115 ( .IN1(n82), .IN2(n84), .QN(n81) );
  NAND3X0 U116 ( .IN1(n81), .IN2(n98), .IN3(n78), .QN(next_state[1]) );
  OA22X1 U117 ( .IN1(xmitH), .IN2(n86), .IN3(n79), .IN4(n99), .Q(n80) );
  NOR2X0 U118 ( .IN1(Trojan_ena), .IN2(n80), .QN(N122) );
  AO222X1 U119 ( .IN1(n82), .IN2(xmit_ShiftRegH[1]), .IN3(n84), .IN4(
        xmit_dataH[0]), .IN5(xmit_ShiftRegH[0]), .IN6(n81), .Q(N58) );
  AO222X1 U120 ( .IN1(n82), .IN2(xmit_ShiftRegH[2]), .IN3(n81), .IN4(
        xmit_ShiftRegH[1]), .IN5(n84), .IN6(xmit_dataH[1]), .Q(N59) );
  AO222X1 U121 ( .IN1(n82), .IN2(xmit_ShiftRegH[3]), .IN3(n81), .IN4(
        xmit_ShiftRegH[2]), .IN5(n84), .IN6(xmit_dataH[2]), .Q(N60) );
  AO222X1 U122 ( .IN1(n82), .IN2(xmit_ShiftRegH[4]), .IN3(n81), .IN4(
        xmit_ShiftRegH[3]), .IN5(n84), .IN6(xmit_dataH[3]), .Q(N61) );
  AO222X1 U123 ( .IN1(n82), .IN2(xmit_ShiftRegH[5]), .IN3(n81), .IN4(
        xmit_ShiftRegH[4]), .IN5(n84), .IN6(xmit_dataH[4]), .Q(N62) );
  AO222X1 U124 ( .IN1(n82), .IN2(xmit_ShiftRegH[6]), .IN3(n81), .IN4(
        xmit_ShiftRegH[5]), .IN5(n84), .IN6(xmit_dataH[5]), .Q(N63) );
  AO222X1 U125 ( .IN1(n82), .IN2(xmit_ShiftRegH[7]), .IN3(n81), .IN4(
        xmit_ShiftRegH[6]), .IN5(n84), .IN6(xmit_dataH[6]), .Q(N64) );
  AO221X1 U126 ( .IN1(n84), .IN2(xmit_dataH[7]), .IN3(n83), .IN4(
        xmit_ShiftRegH[7]), .IN5(n82), .Q(N65) );
  OA221X1 U127 ( .IN1(n86), .IN2(state[0]), .IN3(n86), .IN4(xmitH), .IN5(n95), 
        .Q(n89) );
  NOR2X0 U128 ( .IN1(bitCountH[0]), .IN2(n95), .QN(n88) );
  AO21X1 U129 ( .IN1(n89), .IN2(bitCountH[0]), .IN3(n88), .Q(n58) );
  NAND2X0 U130 ( .IN1(n87), .IN2(bitCountH[0]), .QN(n91) );
  NOR2X0 U131 ( .IN1(n89), .IN2(n88), .QN(n92) );
  MUX21X1 U132 ( .IN1(n91), .IN2(n92), .S(bitCountH[1]), .Q(n90) );
  INVX0 U133 ( .INP(n90), .ZN(n57) );
  NOR2X0 U134 ( .IN1(n107), .IN2(n91), .QN(n97) );
  OA21X1 U135 ( .IN1(bitCountH[1]), .IN2(n95), .IN3(n92), .Q(n94) );
  INVX0 U136 ( .INP(n94), .ZN(n93) );
  MUX21X1 U137 ( .IN1(n97), .IN2(n93), .S(bitCountH[2]), .Q(n56) );
  OAI21X1 U138 ( .IN1(bitCountH[2]), .IN2(n95), .IN3(n94), .QN(n96) );
  OA222X1 U139 ( .IN1(bitCountH[3]), .IN2(bitCountH[2]), .IN3(bitCountH[3]), 
        .IN4(n97), .IN5(n104), .IN6(n96), .Q(n55) );
  NOR2X0 U140 ( .IN1(n98), .IN2(state[2]), .QN(n102) );
  INVX0 U141 ( .INP(n102), .ZN(n101) );
  NOR3X0 U142 ( .IN1(state[1]), .IN2(trojan_state[1]), .IN3(n99), .QN(n100) );
  AO221X1 U143 ( .IN1(trojan_state[0]), .IN2(trojan_state[1]), .IN3(
        trojan_state[0]), .IN4(n101), .IN5(n100), .Q(n54) );
  AO21X1 U144 ( .IN1(trojan_state[0]), .IN2(n102), .IN3(trojan_state[1]), .Q(
        n53) );
  AO21X1 U145 ( .IN1(trojan_state[1]), .IN2(n108), .IN3(Trojan_ena), .Q(n52)
         );
endmodule

