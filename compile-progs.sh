#!/bin/sh -e

. versions.sh

printf  "\nCompiling programs...\n"

for compiler in $clang $gcc; do
    for access in subscripts pointers; do
	for type in int long float double; do
	    sed -e "s|long.h|${type}.h|g" selsort-$access.c \
		> selsort-$access-$type.c
	    printf "Compiling with $compiler $FLAGS, $access, $type...\n"
	    $compiler $FLAGS selsort-$access-$type.c \
		-o selsort-$compiler-$access-$type
	    rm -f selsort-$access-$type.c
	done
    done
done

for compiler in $clangxx $gxx; do
    for access in subscripts pointers vectors; do
	for type in int long float double; do
	    sed -e "s|long.h|${type}.h|g" selsort-$access.cxx \
		> selsort-$access-$type.cxx
	    if [ $compiler = $gxx ]; then
		compiler_flags="-Wl,-rpath=/usr/local/lib/gcc$gcc_ver"
	    fi
	    printf "Compiling with $compiler $FLAGS, $access, $type...\n"
	    $compiler $FLAGS $compiler_flags selsort-$access-$type.cxx \
		-o selsort-$compiler-$access-$type
	    rm -f selsort-$access-$type.cxx
	done
    done
done

for type in integer real 'real(8)'; do
    sed -e "s|data_t|$type|g" selsort.f90 > selsort-$type.f90
    printf "Compiling with $flang, $type...\n"
    $flang $flang_flags $FLAGS selsort-$type.f90 -o selsort-$flang-$type
    printf "Compiling with $gfortran $FLAGS, $type...\n"
    $gfortran $FLAGS selsort-$type.f90 -o selsort-$gfortran-$type \
	-Wl,-rpath=/usr/local/lib/gcc$gcc_ver
    rm -f selsort-$type.f90
done

printf "Compiling with go...\n"
go version
go build -o selsort-go selsort.go

printf "Compiling with $javac...\n"
$javac SelectSortInt.java
$javac SelectSort.java
$javac SelectSortD.java
