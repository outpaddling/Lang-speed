#!/bin/sh -e

. versions.sh

if [ `uname` = FreeBSD ]; then
    for pkg in \
	llvm$clang_ver \
	gcc$gcc_ver \
	ldc \
	fpc \
	rust \
	go \
	perl$perl_ver \
	py$python_suffix-numba \
	openjdk$java_ver \
	R \
	octave
    do
	echo $pkg
	pkg remove $pkg || true
    done
else
    printf "Don't know how to install tools on `uname` without pkgsrc.\n"
    exit 1
fi
