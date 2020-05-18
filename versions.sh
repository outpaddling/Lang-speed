#!/bin/sh -e

clang_ver=10
gcc_ver=9
python_ver=37
python_major_ver=`echo $python_ver | cut -c 1`
perl_ver=5
java_ver=8

clang=clang$clang_ver
clangxx=clang++$clang_ver
flang="flang"
flang_flags="-I /usr/local/flang/include"

gcc=gcc$gcc_ver
gxx=g++$gcc_ver
gfortran=gfortran$gcc_ver

python=python$python_major_ver

FLAGS=-O2
