#!/bin/bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
benchmark_name=$(echo $script_dir | rev | cut -d "/" -f 4 | rev)
project_name=$(echo $script_dir | rev | cut -d "/" -f 3 | rev)
bug_id=$(echo $script_dir | rev | cut -d "/" -f 2 | rev)
dir_name=/experiment/$benchmark_name/$project_name/$bug_id

fix_file=$dir_name/src/$2

# (1) patch another (unrelated) bug
cd $dir_name/src
sed -i '2695s/^.*$/while (cc-- > 1) {/' tools/tiff2ps.c

# (2) add instrumentation for fuzzrepair
cd $dir_name/src
sed -i '2470i if(0) return;' tools/tiff2ps.c
sed -i '2441i if(0) return;' tools/tiff2ps.c


