#!/bin/sh -e

clang_ver=12
gcc_ver=10
python_ver=38
python_major_ver=`echo $python_ver | cut -c 1`
perl_ver=5
java_ver=11

clang=clang$clang_ver
clangxx=clang++$clang_ver
flang="flang"
flang_flags="-I /usr/local/flang/include"

gcc=gcc$gcc_ver
gxx=g++$gcc_ver
gfortran=gfortran$gcc_ver

: ${PREFIX:=/usr/local}
javac=$PREFIX/openjdk$java_ver/bin/javac
java=$PREFIX/openjdk$java_ver/bin/java

python=python$python_major_ver

FLAGS=-O2
