\rm -r obj_dir
verilator --cc uart.v -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD -O3 -Mdir obj_dir --exe tb.cpp  -Wno-lint
