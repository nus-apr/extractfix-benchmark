#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
benchmark_name=$(echo $script_dir | rev | cut -d "/" -f 4 | rev)
project_name=$(echo $script_dir | rev | cut -d "/" -f 3 | rev)
bug_id=$(echo $script_dir | rev | cut -d "/" -f 2 | rev)
dir_name=/experiment/$benchmark_name/$project_name/$bug_id

cd $dir_name/src
cp $script_dir/bug.json $dir_name/bug.json


./autogen.sh

cd $dir_name/src
sed -i 's/fabs/fabs_crepair/g' libtiff/tif_luv.c
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git add  libtiff/tif_luv.c
git commit -m 'replace fabs with proxy function'

# see #62
find tools -name "*.c" | xargs -n1 sed -i 's@"tif_config.h"@"../libtiff/tif_config.h"@g'
find tools -name "*.c" | xargs -n1 sed -i 's@"tiffio.h"@"../libtiff/tiffio.h"@g'
find tools -name "*.h" | xargs -n1 sed -i 's@"tif_config.h"@"../libtiff/tif_config.h"@g'
find tools -sed -i 's@"tiffio.h"@"./tiffio.h"@g' libtiff/tiffio.h
sed -i 's@"tiffvers.h"@"./tiffvers.h"@g' libtiff/tiffio.h
sed -i 's@"tiffio.h"@"./tiffio.h"@g' libtiff/tiffiop.h
git add libtiff/*.h tools/*.c tools/*.h
git commit -m "resolve ambiguity in includes"

./configure --enable-static --disable-shared
