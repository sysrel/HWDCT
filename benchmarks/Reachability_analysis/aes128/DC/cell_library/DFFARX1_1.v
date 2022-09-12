`timescale 1ps / 1ps
module DFFARX1_1 (D,CLK,RSTB,Q,QN);

output  Q/*verilator public*/;
output  QN;
input   D;
input   CLK/*verilator public*/;
input   RSTB/*verilator public*/;
reg notifier;
pullup (setb);
saed90_dff_pos d0 (Q_buf, D, CLK, RSTB, setb, notifier);  
buf (Q, Q_buf);
not (QN,Q_buf);


`ifdef TETRAMAX
  `else
    saed90_xbuf d1 (RSTB_SDFCHK, RSTB, 1'b1);
    saed90_xbuf d2 (D_SDFCHK, D, 1'b1);
    saed90_xbuf d3 (CLK_D_SDFCHK, CLK_D, 1'b1);
    saed90_xbuf d4 (CLK_nD_SDFCHK, CLK_nD, 1'b1);
    saed90_xbuf d5 (nCLK_D_SDFCHK, nCLK_D, 1'b1);
    saed90_xbuf d6 (nCLK_nD_SDFCHK, nCLK_nD, 1'b1);
    saed90_xbuf d7 (RSTB_D_SDFCHK, RSTB_D, 1'b1);
    saed90_xbuf d8 (RSTB_nD_SDFCHK, RSTB_nD, 1'b1);
  `endif

    not (nD, D);
    not (nCLK, CLK);
    and (CLK_D, CLK, D);
    and (CLK_nD, CLK, nD);
    and (nCLK_D, nCLK, D);
    and (nCLK_nD, nCLK, nD);
    and (RSTB_D, RSTB, D);
    and (RSTB_nD, RSTB, nD);

    buf      (RSTB_i, RSTB);
    buf  (CLK_check, RSTB_i);
    buf  (D_check, RSTB_i);

  `ifdef TETRAMAX
  `else
    saed90_xbuf d9 (CLK_DEFCHK, CLK_check, 1'b1);
    saed90_xbuf d10 (D_DEFCHK, D_check, 1'b1);
  `endif


`ifdef functional
`else
specify
 specparam tsu_d_h_clk=106,tsu_d_l_clk=75,tsu_rstb_h_clk=0,th_clk_d_h=0,
 th_clk_d_l=0,th_clk_rstb_l=139,tpw_clk_h=110,tpw_clk_l=182,
 tpw_rstb_l=105,clk_lh_qn_lh=159,clk_lh_q_hl=231,clk_lh_qn_hl=136,
 clk_lh_q_lh=207,rstb_hl_qn_lh_1=134,rstb_hl_q_hl_1=60,
 rstb_hl_qn_lh_2=214,rstb_hl_q_hl_2=59,rstb_hl_qn_lh_3=134,
 rstb_hl_q_hl_3=60,rstb_hl_qn_lh_4=214,rstb_hl_q_hl_4=59;
 $setuphold (posedge CLK &&& (RSTB==1'b1),posedge D,tsu_d_h_clk,th_clk_d_l,notifier);
 $setuphold (posedge CLK &&& (RSTB==1'b1),negedge D,tsu_d_l_clk,th_clk_d_h,notifier);
 $recovery (posedge RSTB,posedge CLK &&& (D==1'b1),tsu_rstb_h_clk,notifier);
 $width (posedge CLK &&& (RSTB==1'b1),tpw_clk_h,0,notifier);
 $width (negedge CLK &&& (RSTB==1'b1),tpw_clk_l,0,notifier);
 $width (negedge RSTB,tpw_rstb_l,0,notifier);

$setuphold (posedge CLK &&& RSTB_SDFCHK, posedge D , 0, 0, notifier);
    $setuphold (posedge CLK &&& RSTB_SDFCHK, negedge D , 0, 0, notifier);
    $setuphold (posedge CLK &&& D_DEFCHK, posedge D, 0, 0, notifier);
    $setuphold (posedge CLK &&& D_DEFCHK, negedge D, 0, 0, notifier);
    $recovery (posedge RSTB &&& D_SDFCHK, posedge CLK &&& D_SDFCHK, 0, notifier);
    $recovery (posedge RSTB, posedge CLK, 0, notifier);
    $hold (posedge CLK &&& D_SDFCHK, posedge RSTB , 0, notifier);
    $hold (posedge CLK, posedge RSTB, 0, notifier);

$width (negedge RSTB &&& CLK_D_SDFCHK, 0, 0, notifier);
    $width (negedge RSTB &&& CLK_nD_SDFCHK, 0, 0, notifier);
    $width (negedge RSTB &&& nCLK_D_SDFCHK, 0, 0, notifier);
    $width (negedge RSTB &&& nCLK_nD_SDFCHK, 0, 0, notifier);
    $width (negedge RSTB, 0, 0, notifier);
    $width (posedge CLK &&& RSTB_D_SDFCHK, 0, 0, notifier);
    $width (negedge CLK &&& RSTB_D_SDFCHK, 0, 0, notifier);
    $width (posedge CLK &&& RSTB_nD_SDFCHK, 0, 0, notifier);
    $width (negedge CLK &&& RSTB_nD_SDFCHK, 0, 0, notifier);
    $width (posedge CLK &&& CLK_DEFCHK, 0, 0, notifier);
    $width (negedge CLK &&& CLK_DEFCHK, 0, 0, notifier);
 if (RSTB==1'b1)
 (posedge CLK   => (QN -: D)) = (clk_lh_qn_lh,clk_lh_qn_hl);
 if (RSTB==1'b1)
 (posedge CLK   => (Q  +: D)) = (clk_lh_q_lh,clk_lh_q_hl);
 if ((D==1'b0) && (CLK==1'b0))
 (negedge RSTB  => (QN +: 1'b1)) = (rstb_hl_qn_lh_1,0);
 if ((D==1'b0) && (CLK==1'b0))
 (negedge RSTB  => (Q  -: 1'b1)) = (0,rstb_hl_q_hl_1);
 if ((D==1'b0) && (CLK==1'b1))
 (negedge RSTB  => (QN +: 1'b1)) = (rstb_hl_qn_lh_2,0);
 if ((D==1'b0) && (CLK==1'b1))
 (negedge RSTB  => (Q  -: 1'b1)) = (0,rstb_hl_q_hl_2);
 if ((D==1'b1) && (CLK==1'b0))
 (negedge RSTB  => (QN +: 1'b1)) = (rstb_hl_qn_lh_3,0);
 if ((D==1'b1) && (CLK==1'b0))
 (negedge RSTB  => (Q  -: 1'b1)) = (0,rstb_hl_q_hl_3);
 if ((D==1'b1) && (CLK==1'b1))
 (negedge RSTB  => (QN +: 1'b1)) = (rstb_hl_qn_lh_4,0);
 if ((D==1'b1) && (CLK==1'b1))
 (negedge RSTB  => (Q  -: 1'b1)) = (0,rstb_hl_q_hl_4);
endspecify
`endif

endmodule
