
0. Create a tb.cpp file to refer to the top level module of the design under analysis
   $ gcc -g gen_dct_and_troj_tb.c -o tb_troj -lm
   $ ./tb_troj -t uart -c clk -r rst_1 -i rx_1 -i transmit_1 -i tx_byte_10 -s recv_state_3 -N 4

Simply run the command to start analysis:
   $ ./runall.sh
   


OR following the elabrated steps:
1. Execute the simulator to generate C++ implementation of the simulated Verilog design 
using verilator.sh
   $ ./verilator.sh

   If everything goes fine (no errors), you should see the obj_dir directory gets created 
   and populated with the C++ files for your RTL design.

2. Compile the Verilator generated code using compileSource.sh
   2.1 Make sure wllvm related environment settings have been done
       $ ./exportwllvm.sh

   2.2 Compile the C++ code using wllvm
       $ ./compileSource.sh

3. Extract the LLVM bitcode using extractBitcode.sh
   $ ./extractBitcode.sh

4. Perform symbolic execution using run.sh:
  
   4.1 Make sure to set the DCT3D environment variable to the full path for the executable
       $ export DCT3D=~/DCT3D_build_dir/bin/klee
 
   4.2 Run DCT   
       $ ./runBfs.sh obj_dir/Vuart.bc 2>/dev/null 1>/dev/null &
