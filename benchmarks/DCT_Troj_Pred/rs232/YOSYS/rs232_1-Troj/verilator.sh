\rm -r obj_dir
verilator --cc -public *.v --top-module u_xmit -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD  -Mdir obj_dir --exe tb.cpp  -Wno-lint -O0
