
0. Create a tb.cpp file to refer to the top level module of the design under analysis

Simply run the command to start analysis:
   $ ./runall.sh



OR following the elabrated steps:
1. Execute the simulator to generate C++ implementation of the simulated Verilog design 
using verilator.sh
   ./verilator.sh

   If everything goes fine (no errors), you should see the obj_dir directory gets created 
   and populated with the C++ files for your RTL design.

2. Replace topp->name() with /*topp->name()*/"TOP" in obj-dir/Vfsm_using_function__Syms.cpp 
(In general, anywhere name() gets called, comment it out and replace with "TOP")

   * Skipping this step will lead to a false positive and prevent you from achieving 
   meaningful coverage during symboluc execution of your RTL design.
   * Use your favorate editor to do this change (hopefully, you will need to do this once. 
   However, every time you run the verilator.sh script, you need to repeat this step).

3. Compile the Verilator generated code using compileSource.sh
   3.1 Make sure wllvm related environment settings have been done
       $ ./exportwllvm.sh

   3.2 Compile the C++ code using wllvm
       $ ./compileSource.sh

4. Extract the LLVM bitcode using extractBitcode.sh
   $ ./extractBitcode.sh

5. Perform symbolic execution using run.sh:
  
   5.1 Make sure to set the DCT environment variable to the full path for the executable
       $ export DCT=~/dct_build_dir/bin/klee
 
   5.2 Run DCT   
       $ ./runBfs.sh obj_dir/Vima_adpcm_enc.bc 2>/dev/null 1>/dev/null &
