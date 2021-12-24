#!/bin/sh -e

clang_ver=12
gcc_ver=10
perl_ver=5
python_ver=38
java_ver=11

if which pkgin; then
    pkgin install -y \
	llvm$clang_ver \
	gcc$gcc_ver \
	flang \
	rust \
	go \
	perl$perl_ver \
	python$python_ver \
	py$python_ver-numba \
	openjdk$java_ver \
	R
elif [ `uname` = FreeBSD ]; then
    pkg install -y \
	llvm$clang_ver \
	gcc$gcc_ver \
	flang \
	ldc \
	fpc \
	rust \
	go \
	perl$perl_ver \
	py$python_ver-numba \
	openjdk$java_ver \
	R \
	octave
else
    printf "Don't know how to install tools on `uname` without pkgsrc.\n"
    exit 1
fi
