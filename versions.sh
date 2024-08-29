#!/bin/sh -e

# Update these to the latest mainstream
clang_ver=18
gcc_ver=14
flang_ver=14
python_ver=3.11

python_major_ver=`echo $python_ver | cut -c 1`
python_condensed_ver=`echo $python_ver | tr -d '.'`
perl_ver=5
java_ver=11

clang=clang$clang_ver
clangxx=clang++$clang_ver

if [ `uname` = Darwin ] && [ `which gcc` = /usr/bin/gcc ]; then
    printf "gcc in PATH is Apple clang, skipping.\n"
    gcc=''
    gxx=''
    gfortran=''
else
    gcc=gcc$gcc_ver
    gxx=g++$gcc_ver
    gfortran=gfortran$gcc_ver
    flang=flang$flang_ver
fi
: ${PREFIX:=/usr/local}
if [ `uname` == FreeBSD ]; then
    javac=$PREFIX/openjdk$java_ver/bin/javac
    java=$PREFIX/openjdk$java_ver/bin/java
else
    javac=javac
    java=java
fi

python=python$python_major_ver
python_suffix=$(printf "$python_ver" | tr -d '.')

FLAGS='-O2 -funroll-loops -march=native'
