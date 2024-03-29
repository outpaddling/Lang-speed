#!/bin/sh -e

for clang_ver in 13 12 11 10 ''; do
    if which clang$clang_ver; then
	break;
    fi
done

for gcc_ver in 14 13 12 11 10 9 8 ''; do
    if which gcc$gcc_ver; then
	break;
    fi
done

# The flang included with llvm13 is a wrapper around gfortran
# This should pick up the FreeBSD devel/flang port
for flang_ver in 13 12 11 10; do
    if which flang$flang_ver; then
	break;
    fi
done

for python_ver in 3.9 3.8 3.7 ''; do
    if which python$python_ver; then
	break;
    fi
done

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

FLAGS=-O2
