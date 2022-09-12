/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Fri Jun 11 22:45:32 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module prep3 ( clk, rst, in, out );
  input [7:0] in;
  output [7:0] out;
  input clk, rst;
  wire   n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62/*, n63, n64, n65*/;
  reg   [2:0] state/*verilator public*/;
  reg	n63, n64, n65;
  wire   [7:0] next_out;

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
  state[0] = n34;
  n65 = ~n34;
  state[1] = n33;
  n63 = ~n33;
  state[2] = n32;
  n64 = ~n32;
  end
end

  //DFFARX1 \state_reg[0]  ( .D(n34), .CLK(clk), .RSTB(rst), .Q(state[0]), .QN(n65) );
  //DFFARX1 \state_reg[2]  ( .D(n32), .CLK(clk), .RSTB(rst), .Q(state[2]), .QN(n64) );
  //DFFARX1 \state_reg[1]  ( .D(n33), .CLK(clk), .RSTB(rst), .Q(state[1]), .QN(n63) );
  DFFARX1 \out_reg[7]  ( .D(next_out[7]), .CLK(clk), .RSTB(rst), .Q(out[7]) );
  DFFARX1 \out_reg[6]  ( .D(next_out[6]), .CLK(clk), .RSTB(rst), .Q(out[6]) );
  DFFARX1 \out_reg[5]  ( .D(n35), .CLK(clk), .RSTB(rst), .Q(out[5]) );
  DFFARX1 \out_reg[4]  ( .D(next_out[4]), .CLK(clk), .RSTB(rst), .Q(out[4]) );
  DFFARX1 \out_reg[3]  ( .D(next_out[3]), .CLK(clk), .RSTB(rst), .Q(out[3]) );
  DFFARX1 \out_reg[2]  ( .D(next_out[2]), .CLK(clk), .RSTB(rst), .Q(out[2]) );
  DFFARX1 \out_reg[1]  ( .D(n31), .CLK(clk), .RSTB(rst), .Q(out[1]) );
  DFFARX1 \out_reg[0]  ( .D(next_out[0]), .CLK(clk), .RSTB(rst), .Q(out[0]) );
  NAND2X0 U44 ( .IN1(state[2]), .IN2(n65), .QN(n53) );
  NAND2X0 U45 ( .IN1(state[1]), .IN2(n64), .QN(n36) );
  NAND2X0 U46 ( .IN1(n53), .IN2(n36), .QN(n32) );
  NAND2X0 U47 ( .IN1(state[1]), .IN2(n65), .QN(n49) );
  NOR2X0 U48 ( .IN1(state[2]), .IN2(n49), .QN(next_out[4]) );
  NAND3X0 U49 ( .IN1(state[0]), .IN2(n63), .IN3(n64), .QN(n50) );
  INVX0 U50 ( .INP(n50), .ZN(n57) );
  NAND2X0 U51 ( .IN1(in[1]), .IN2(in[3]), .QN(n37) );
  NOR2X0 U52 ( .IN1(in[6]), .IN2(n37), .QN(n40) );
  INVX0 U53 ( .INP(in[7]), .ZN(n38) );
  NAND2X0 U54 ( .IN1(n40), .IN2(n38), .QN(n60) );
  INVX0 U55 ( .INP(in[5]), .ZN(n39) );
  NAND4X0 U56 ( .IN1(in[4]), .IN2(in[0]), .IN3(in[2]), .IN4(n39), .QN(n58) );
  NOR2X0 U57 ( .IN1(n60), .IN2(n58), .QN(n51) );
  NAND2X0 U58 ( .IN1(n57), .IN2(n51), .QN(n44) );
  NOR4X0 U59 ( .IN1(in[0]), .IN2(in[4]), .IN3(in[2]), .IN4(n39), .QN(n42) );
  NAND3X0 U60 ( .IN1(in[7]), .IN2(n42), .IN3(n40), .QN(n55) );
  NAND2X0 U61 ( .IN1(next_out[4]), .IN2(n55), .QN(n41) );
  NAND2X0 U62 ( .IN1(n44), .IN2(n41), .QN(n35) );
  INVX0 U63 ( .INP(n55), .ZN(n43) );
  INVX0 U64 ( .INP(n42), .ZN(n59) );
  OR2X1 U65 ( .IN1(n59), .IN2(n60), .Q(n61) );
  OA22X1 U66 ( .IN1(n43), .IN2(n49), .IN3(n61), .IN4(n50), .Q(n45) );
  NAND3X0 U67 ( .IN1(n45), .IN2(n53), .IN3(n44), .QN(n33) );
  NAND2X0 U68 ( .IN1(in[4]), .IN2(in[2]), .QN(n46) );
  NOR3X0 U69 ( .IN1(in[6]), .IN2(in[0]), .IN3(n46), .QN(n48) );
  NOR4X0 U70 ( .IN1(state[1]), .IN2(state[0]), .IN3(in[7]), .IN4(in[1]), .QN(
        n47) );
  NAND4X0 U71 ( .IN1(in[5]), .IN2(in[3]), .IN3(n48), .IN4(n47), .QN(n54) );
  OAI21X1 U72 ( .IN1(state[1]), .IN2(n53), .IN3(n54), .QN(next_out[7]) );
  OA22X1 U73 ( .IN1(n51), .IN2(n50), .IN3(n55), .IN4(n49), .Q(n52) );
  NAND3X0 U74 ( .IN1(n52), .IN2(n53), .IN3(n54), .QN(n34) );
  OAI22X1 U75 ( .IN1(state[2]), .IN2(n54), .IN3(n63), .IN4(n53), .QN(n31) );
  NOR2X0 U76 ( .IN1(state[0]), .IN2(n55), .QN(n56) );
  OA221X1 U77 ( .IN1(state[2]), .IN2(n56), .IN3(n64), .IN4(state[0]), .IN5(
        state[1]), .Q(next_out[0]) );
  OA221X1 U78 ( .IN1(n60), .IN2(n59), .IN3(n60), .IN4(n58), .IN5(n57), .Q(
        next_out[2]) );
  NAND2X0 U79 ( .IN1(n64), .IN2(n61), .QN(n62) );
  AND3X1 U80 ( .IN1(n63), .IN2(state[0]), .IN3(n62), .Q(next_out[6]) );
  NOR3X0 U81 ( .IN1(n63), .IN2(n65), .IN3(state[2]), .QN(next_out[3]) );
endmodule

