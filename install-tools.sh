#!/bin/sh -e

. versions.sh

if which pkgin; then
    pkgin install -y \
	llvm$clang_ver \
	gcc$gcc_ver \
	rust \
	go \
	perl$perl_ver \
	python$python_ver \
	py$python_suffix-numba \
	openjdk$java_ver \
	R
    #pkg_admin set automatic $pkg
elif [ `uname` = FreeBSD ]; then
    pkg update
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
	pkg install -y --no-repo-update $pkg || true
    done
else
    printf "Don't know how to install tools on `uname` without pkgsrc.\n"
    exit 1
fi
