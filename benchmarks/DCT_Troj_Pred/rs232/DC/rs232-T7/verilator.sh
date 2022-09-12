\rm -r obj_dir
verilator -public --flatten -Wno-lint -O0 --top-module uart +incdir+/home/UFAD/ruochendai/Documents/DCT_Trojan/dontDC/fsm_eg/cell_library --cc u_xmit.v timescale.v /home/UFAD/ruochendai/Documents/DCT_Trojan/dontDC/fsm_eg/cell_library/*.v --top-module u_xmit -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD  -Mdir obj_dir --exe tb.cpp
