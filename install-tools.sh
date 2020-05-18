#!/bin/sh -e

. versions.sh

if which pkgin; then
    pkgin install -y \
	llvm$clang_ver \
	gcc$gcc_ver \
	flang \
	go \
	perl$perl_ver \
	python$python_major_ver \
	py$python_ver-numba \
	openjdk$java_ver \
	R
elif [ `uname` = FreeBSD ]; then
    pkg install -y \
	llvm$clang_ver \
	gcc$gcc_ver \
	flang \
	go \
	perl$perl_ver \
	python$python_major_ver \
	py$python_ver-numba \
	openjdk$java_ver \
	R
else
    printf "Don't know how to install tools on `uname` without pkgsrc.\n"
    exit 1
fi
