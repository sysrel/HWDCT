\rm -r obj_dir
verilator --cc  -f l.f --top-module mixcolum -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD  -Mdir obj_dir --exe tb.cpp  -Wno-lint -O0
