\rm -r obj_dir
verilator --cc xtea.v -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD -O3 -Mdir obj_dir --exe tb.cpp  -Wno-lint
