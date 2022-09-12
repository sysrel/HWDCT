\rm -r obj_dir
verilator --cc keysched.v --top-module keysched -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD  -Mdir obj_dir --exe tb.cpp  -Wno-lint -O0
