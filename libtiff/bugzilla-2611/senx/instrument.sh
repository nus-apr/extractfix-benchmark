#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
benchmark_name=$(echo $script_dir | rev | cut -d "/" -f 4 | rev)
project_name=$(echo $script_dir | rev | cut -d "/" -f 3 | rev)
bug_id=$(echo $script_dir | rev | cut -d "/" -f 2 | rev)
dir_name=/experiment/$benchmark_name/$project_name/$bug_id
mkdir $dir_name/senx

cd $dir_name/src

make clean
CC=wllvm CXX=wllvm++  ./configure CFLAGS="-g -O0 -static"  --enable-static --disable-shared
CC=wllvm CXX=wllvm++ make CFLAGS="-g -O0 -static" -j32

binary_dir=$dir_name/src/tools
binary_name=tiffmedian

extract-bc $binary_dir/$binary_name
analyze_bc $binary_dir/$binary_name.bc
cd $dir_name/senx
cp $binary_dir/$binary_name .
cp $binary_dir/$binary_name.bc .
cp $binary_dir/$binary_name.bc.talos .

llvm-dis $binary_name.bc
cp ../../../../../scripts/senx/prepare_gdb_script.py .
python3 prepare_gdb_script.py $binary_name
cp def_file $binary_dir



