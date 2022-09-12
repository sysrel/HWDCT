//////////////////////////////////////////////////////////////////////
////                                                              ////
//// APB- SPI 0.1 IP Core                                         ////
////                                                              ////
//// This file is part of the APB- SPI 0.1 IP Core project        ////
//// http://www.opencores.org/cores/APB- SPI 0.1 IP Core/         ////
////                                                              ////
//// Description                                                  ////
//// Implementation of XXX IP core according to                   ////
//// XXX IP core specification document.                          ////
////                                                              ////
//// To Do:                                                       ////
//// -                                                            ////
////                                                              ////
//// Author(s):                                                   ////
//// - Lakshmi Narayanan Vernugopal, email@opencores.org          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2009 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE. See the GNU Lesser General Public License for more  ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              //// ///
///////////////////////////////////////////////////////////////////
`define APB_DATA_WIDTH  8
`define SPI_REG_WIDTH   8
`define APB_ADDR_WIDTH  3
//`define CLK_DIV_WIDTH 16
//`timescale 1ns/1ps
module APB_SPI_top
(
 // APB SLAVE PORT INTERFACE 
 input                         PCLK,
 input                         PRESETn,
 input [`APB_ADDR_WIDTH-1:0 ]  PADDR,
 input                         PWRITE,
 input                         PSEL,
 input                         PENABLE,
 input [`APB_DATA_WIDTH-1:0 ]  PWDATA,
 output [`APB_DATA_WIDTH-1:0 ] PRDATA,
 output                        PREADY,
 input                         TrFr,
 // SPI INTERFACE
 ////if Master/Slave Mode
 //inout                         SCLK,
 //inout                         MISO,
 //inout                         MOSI,
 //output                        SS,
 //if only Master Mode
 output                        SCLK,
 input                         MISO,
 output                        MOSI,
 output                        SS
 ////if only Slave Mode
 //input                         SCLK,
 //output                        MISO,
 //input                         MOSI,
 //input                         SS
 
);


  //APB Slave Interface Module
  APB_SLAVE APB_SL
  (
   .PCLK           (PCLK   ),
   .PRESETn        (PRESETn),
   .PADDR          (PADDR  ),
   .PWRITE         (PWRITE ),
   .PSEL           (PSEL   ),
   .PENABLE        (PENABLE),
   .PWDATA         (PWDATA ),
   .PRDATA         (PRDATA ),
   .PREADY         (PREADY ),
   .TrFr           (TrFr ),
                   
   .SPI_CR_1       (),
   .SPI_CR_2       (),
   .SPI_BR_R       (),
   .SPI_ST_R       (),
   .SPI_DATA_Reg_1 (), 
   .SPI_DATA_Reg_2 (),
   .SPI_DATA_Reg_3 (),
   .SPI_DATA_Reg_4 ()    
   
  );


`ifdef ENABLED
  // SPI Master Definition
  SPI_Master SPI_M
  (
  
  );


  // SPI Slave Definition
  SPI_Slave SPI_S
  (
  
  );



  // Contains the register definiation of the 
  Register_Def Reg_Def
  (
  
  );


  // Baud Rate Generator for the SPI Speed of operation
  Clock_Gen CLK_Gen
  (
  
  );


  // Selection of the IO PAD type for the MISO and MOSI based on the Configuration of Registers
  IO_PAD_Instance IO_Pad
  (
  
  );
`endif

endmodule