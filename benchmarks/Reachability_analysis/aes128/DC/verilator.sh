\rm -r obj_dir
verilator --flatten -Wno-lint -O3 --top-module keysched +incdir+fsm_eg/cell_library --cc keysched.v timescale.v /cell_library/*.v -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD  -Mdir obj_dir --exe tb.cpp 
