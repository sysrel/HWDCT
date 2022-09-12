`timescale 1ps / 1ps
module saed90_dff_pos (q, d, clk, rstb, setb, notifier);
   output q;
   input d, clk, rstb, setb, notifier;
   reg q;
   table
   // d   clk   rstb   setb  ntfr	  Q
      ?     ?     0     ?     ?  :  ?  :  0  ; // RST dominate SET
      ?     ?     1     0     ?  :  ?  :  1  ; // SET is set   
      ?     ?     1     x     ?  :  0  :  x  ; // SET affect Q
      ?     ?     1     x     ?  :  1  :  1  ; // Q=1,preset=X
      ?     ?     x     1     ?  :  0  :  0  ; // Q=0,clear=X
      0    (01)   ?     1     ?  :  ?  :  0  ; // Latch 0
      0     *     ?     1     ?  :  0  :  0  ; // Keep 0 (D==Q)
      1    (01)   1     ?     ?  :  ?  :  1  ; // Latch 1   
      1     *     1     ?     ?  :  1  :  1  ; // Keep 1 (D==Q)
      ?    (1?)   1     1     ?  :  ?  :  -  ; // ignore negative edge of clock
      ?    (?0)   1     1     ?  :  ?  :  -  ; // ignore negative edge of clock
      ?     ?    (?1)   1     ?  :  ?  :  -  ; // ignore positive edge of RST
      ?     ?     1    (?1)   ?  :  ?  :  -  ; // ignore posative edge of SET
      *     ?     1     1     ?  :  ?  :  -  ; // ignore data change on steady clock
//    ?     ?     ?     ?     *  :  ?  :  x  ; // timing check violation
   endtable
endmodule
