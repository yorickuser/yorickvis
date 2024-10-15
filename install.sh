#!/bin/bash -eu

echo installing yorick...
set -x
cd Yorick/
rm -rf yorick
git clone https://github.com/LLNL/yorick.git -b y_2_2_04
cd yorick/
./configure
make
cd ../
set +x

echo yorick has been installed.

echo making simbolic link ~/Yorick

set -x


ln -s $(pwd) ~/Yorick
cd ../
set +x

echo yorickvis has been installed.

