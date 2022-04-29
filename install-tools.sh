#!/bin/sh -e

clang_ver=13
gcc_ver=11
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
    #pkg_admin set automatic $pkg
elif [ `uname` = FreeBSD ]; then
    pkg update
    for pkg in \
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
    do
	echo $pkg
	pkg install -Ay --no-repo-update $pkg || true
    done
else
    printf "Don't know how to install tools on `uname` without pkgsrc.\n"
    exit 1
fi
