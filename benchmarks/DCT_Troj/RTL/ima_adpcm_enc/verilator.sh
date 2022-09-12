\rm -r obj_dir
verilator --cc ima_adpcm_enc.v -Wno-WIDTH -Wno-WIDTHCONCAT -Wno-CASEINCOMPLETE -Wno-SYMRSVDWORD -O3 -Mdir obj_dir --exe tb.cpp  -Wno-lint
