#!/bin/sh -e

clang_ver=''
gcc_ver=''
python_ver=38
python_major_ver=`echo $python_ver | cut -c 1`
perl_ver=5
java_ver=11

clang=clang$clang_ver
clangxx=clang++$clang_ver
flang="flang"
flang_flags="-I /usr/local/flang/include"

if [ `uname` = Darwin ] && [ `which gcc` = /usr/bin/gcc ]; then
    printf "gcc in PATH is Apple clang, skipping.\n"
    gcc=''
    gxx=''
    gfortran=''
else
    gcc=gcc$gcc_ver
    gxx=g++$gcc_ver
    gfortran=gfortran$gcc_ver
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

FLAGS=-O2
