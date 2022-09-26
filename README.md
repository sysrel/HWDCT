# HWDCT
## Description
This is the repository for the HWDCT tool described in our [TODAES '22](https://dl.acm.org/doi/10.1145/3558392) paper.

## Publication
*Ruochen Dai and Tuba Yavuz. A Symbolic Approach to Detecting Hardware Trojans Triggered by Don’t Care Transitions. Accepted to ACM Transactions on Design Automation of Electronic Systems, 2022.

Please refer to this link for more details: https://nam10.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdoi.org%2F10.1145%2F3558392&amp;data=05%7C01%7Cruochendai%40ufl.edu%7C5efa56ed482145372dac08da9fc5f367%7C0d4da0f84a314d76ace60a62331e1b84%7C0%7C0%7C637997969779219388%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=KfyorwJcl9Cj0bScvFlon3fY6rILEO0JrTUwpvskhSQ%3D&amp;reserved=0

## Prerequisites
### Klee
Please refer to website: [https://klee.github.io/releases/docs/v2.1/build-llvm38/](https://klee.github.io/releases/docs/v2.1/build-llvm38/) about 
how to build KLEE.

### WLLVM

As of August 2016 WLLVM is now a pip package. You can just do:

```
pip install wllvm
```

or

```
sudo pip install wllvm
```

For additional information, please refer to website: [https://github.com/travitch/whole-program-llvm](https://github.com/travitch/whole-program-llvm).

### Verilator

```
git clone http://git.veripool.org/git/verilator
git checkout verilator_3_900
cd verilator
autoconf
./configure
make
sudo make install
```
For additional information, please refer to website: [http://www.veripool.org/projects/verilator/wiki/Installing](http://www.veripool.org/projects/verilator/wiki/Installing).

Update the Makefile with your own `KLEE_ROOT` and `KLEE_INCLUDE`:

```
vim verilator/verilated.mk
KLEE_ROOT = (use your own klee_root)
KLEE_INCLUDE = (use your own klee_include)
```

Update Verilator's Makefile with Klee and WLLVM:

```
mv /usr/local/share/verilator/include/verilated.mk /usr/local/share/verilator/include/verilated.mk.bak
cp verilator/verilated.mk /usr/local/share/verilator/include
```



## Build

1. **Get HWDCT source:**

```bash
 git clone https://github.com/sysrel/HWDCT
```

2. **Configure HWDCT:**

```bash
mkdir hwdct_build_dir
```

HWDCT must be built “out of source” so first make a binary build directory!!!

```bash
$ cd klee_build_dir
$ cmake <CMAKE_OPTIONS> <KLEE_SRC_DIRECTORY>
```

```bash
cmake \
  -DENABLE_SOLVER_STP=ON \
  -DENABLE_POSIX_RUNTIME=ON \
  -DENABLE_KLEE_UCLIBC=ON \
  -DKLEE_UCLIBC_PATH=<KLEE_UCLIBC_SOURCE_DIR> \
  -DGTEST_SRC_DIR=<GTEST_SOURCE_DIR> \
  -DENABLE_SYSTEM_TESTS=ON \
  -DENABLE_UNIT_TESTS=ON \
  -DLLVM_CONFIG_BINARY=<PATH_TO_LLVM38_llvm-config> \
  -DLLVMCC=<PATH_TO_clang-3.8> \
  -DLLVMCXX=<PATH_TO_clang++-3.8>
  <HWDCT_SRC_DIRECTORY>
```

3. **Build HWDCT:**

```bash
$ make
```
