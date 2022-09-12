\rm -r obj_dir
verilator --cc  APB_SLAVE.v -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD  -Mdir obj_dir --exe tb.cpp  -Wno-lint -O3