echo "****************************"
echo "change shell file permission"
echo "****************************"
echo "chmod +x *.sh"
chmod +x *.sh

echo "                            "
echo "****************************"
echo "translate with verilator"
echo "****************************"
echo "./verilator.sh"
./verilator.sh

echo "                            "
echo "****************************"
echo "set wllvm environment"
echo "****************************"
echo "export LLVM_COMPILER=clang "
echo "export LLVM_COMPILER_PATH=/usr/lib/llvm-3.8/bin"
export LLVM_COMPILER=clang
export LLVM_COMPILER_PATH=/usr/lib/llvm-3.8/bin

echo "                            "
echo "****************************"
echo "compiler c++ using wllvm"
echo "****************************"
echo "./compileSource.sh "
./compileSource.sh
echo "                            "
echo "****************************"
echo "extract llvm Bitcode"
echo "****************************"
echo "./extractBitcode.sh"
./extractBitcode.sh

echo "                            "
echo "****************************"
echo "set symbolic execution path"
echo "****************************"
echo "export DCT3D=~/DCT3D_build_dir/bin/klee"
export DCT3D=~/DCT3D_build_dir/bin/klee

echo "                            "
echo "****************************"
echo "run symbolic execution using bfs pruning"
echo "****************************"
echo " ./runBfs.sh obj_dir/VKeyExpand128.bc 2>/dev/null 1>/dev/null &"
./runBfs.sh obj_dir/Vtap_top.bc 2>/dev/null 1>/dev/null &
echo "pid = $!"