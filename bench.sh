#!/bin/sh -e

# FIXME: Make sure all programs use the same size integer

line()
{
    printf '==========================================================\n'
}

print_time () {
    minutes=`printf "scale=5; ${seconds} / 60\n" | bc -l`
    hours=`printf "scale=5; ${minutes} / 60\n" | bc -l`
    printf "User time = ${seconds} seconds (${minutes} minutes) (${hours} hours).\n"
}

report_time () {
    seconds=`grep 'real.*user.*sys' time | awk ' { print $3 }'`
    if [ $# = 1 ]; then
	# t1 = k * n^2
	# t2 = k * (n/d)^2
	# k = t2 / (n/d)^2
	# t1 = t2 / (n/d)^2 * n^2 = t2 * n^2 / (n/d)^2
	div=$1
	seconds=`printf "scale=5; $seconds * $count^2 / ($count / $div)^2\n" | bc -l`
    fi
    
    # User time
    print_time

    # Max resident memory
    # FIXME: Find a way to report virtual memory use as well
    # Monitor using top for now
    printf "RSS = %s KB\n" \
	$(fgrep 'maximum resident set' time | awk '{ print $1 }')
}

if [ $# != 1 ]; then
    printf  "Utage: $0 <count>\n"
    exit 1
fi
count=$1

. versions.sh

# Linux: time_cmd="/usr/bin/time -f '%R real %U user %S sys'"
time_cmd='/usr/bin/time -l'

line
date

line
uname -a

line
if [ -e /var/run/dmesg.boot ]; then 
    fgrep CPU /var/run/dmesg.boot
fi

line
printf  "Generating input file of $count numbers...\n"
cc $FLAGS genrand.c -o genrand
./genrand $count > ${count}nums

# Also generate smaller lists for slow languages and extrapolate times.
# Comparisons with full runs showed extrapolated times to be with a few
# percent of time for full runs.
count20=$((count / 20))
./genrand $count20 > ${count20}nums
count5=$((count / 5))
./genrand $count5 > ${count5}nums

line
$clang --version
line
if [ -n "$gcc" ]; then
    $gcc --version
    line
fi
java -version
line

./compile-progs.sh

sync

line

printf  "\nSorting with Unix sort command...\n"
$time_cmd sort -n < ${count}nums > sorted-list 2> time
sync
report_time

# C
for compiler in $clang $gcc; do
    for access in subscripts pointers; do
	for type in int long float double; do
	    printf  "\nSorting $type array with $compiler and $access...\n"
	    $time_cmd ./selsort-$compiler-$access-$type \
		< ${count}nums > sorted-list-$access-$type 2> time
	    sync
	    report_time
	    rm -f selsort-$compiler-$access-$type
	done
    done
done

# C++
for compiler in $clangxx $gxx; do
    for access in subscripts pointers vectors; do
	for type in int long float double; do
	    printf  "\nSorting $type array with $compiler and $access...\n"
	    $time_cmd ./selsort-$compiler-$access-$type \
		< ${count}nums > sorted-list 2> time
	    sync
	    report_time
	    rm -f selsort-$compiler-$access-$type
	done
    done
done

# Fortran
# flang is still not finished as of llvm15
for compiler in $gfortran; do
    for type in integer real 'real(8)'; do
	printf  "\nSorting $type array with $compiler and subscripts...\n"
	if [ -e selsort-$compiler-$type ]; then
	    $time_cmd ./selsort-$compiler-$type \
		< ${count}nums > sorted-list 2> time
	    sync
	    report_time
	    rm -f selsort-$compiler-$type
	fi
    done
done

# Pascal
if [ -e selsort-pas ]; then
    printf  "\nSorting int array Pascal...\n"
    $time_cmd ./selsort-pas < ${count}nums > sorted-list 2> time
    sync
    report_time

    printf  "\nSorting longint array with Pascal...\n"
    $time_cmd ./selsort-pas < ${count}nums > sorted-list 2> time
    sync
    report_time
fi

# D
if [ -e selsort-d ]; then
    printf  "\nSorting int array D...\n"
    $time_cmd ./selsort-d < ${count}nums > sorted-list 2> time
    sync
    report_time
fi

if [ -e selsort-rust ]; then
    printf  "\nSorting i32 vector with Rust...\n"
    $time_cmd ./selsort-rust < ${count}nums > sorted-list 2> time
    sync
    report_time
fi

if [ -e selsort-go ]; then
    printf  "\nSorting with Go...\n"
    $time_cmd ./selsort-go < ${count}nums out > sorted-list 2> time
    sync
    report_time
fi

if [ -e SelectSortInt ]; then
    printf  "\nSorting with $java int array, Just-In-Time compiler enabled...\n"
    $time_cmd $java SelectSortInt < ${count}nums > sorted-list 2> time
    sync
    report_time
fi

if [ -e SelectSort ]; then
    printf  "\nSorting with $java long array, Just-In-Time compiler enabled...\n"
    $time_cmd $java SelectSort < ${count}nums > sorted-list 2> time
    sync
    report_time

    printf  "\nSorting with $java long array, Just-In-Time compiler disabled...\n"
    $time_cmd $java -Xint SelectSort < ${count5}nums > sorted-list 2> time
    sync
    report_time 5
fi

if [ -n "$python" ]; then
    printf  "\nSorting with Python+numba...\n"
    # FIXME: Find out how to test for presence of numba
    if $time_cmd $python ./selsort-numba.py ${count}nums > sorted-list 2> time; then
	sync
	report_time
    fi
    
    printf  "\nSorting with vectorized Python extrapolated...\n"
    $time_cmd $python selsort-vectorized.py ${count5}nums > sorted-list 2> time
    sync
    report_time 5
    
    printf "\nSorting with Python explicit loops extrapolated...\n"
    $time_cmd $python selsort.py ${count5}nums > sorted-list 2> time
    sync
    report_time 5
fi

if which perl; then
    printf  "\nSorting with vectorized Perl extrapolated...\n"
    $time_cmd perl ./selsort-vectorized.pl < ${count5}nums > sorted-list 2> time
    sync
    report_time 5
    
    printf  "\nSorting with Perl explicit loops extrapolated...\n"
    $time_cmd perl ./selsort.pl < ${count5}nums > sorted-list 2> time
    sync
    report_time 5
fi

if which R; then
    printf  "\nSorting with vectorized R...\n"
    $time_cmd Rscript ./selsort-vectorized.R ${count}nums > sorted-list 2> time
    sync
    report_time
    
    printf  "\nSorting with R explicit loops extrapolated...\n"
    $time_cmd Rscript ./selsort.R ${count5}nums > sorted-list 2> time
    sync
    report_time 5
fi

if which octave; then
    printf  "\nSorting with vectorized Octave...\n"
    $time_cmd octave selsortvectorized.m ${count}nums > sorted-list 2> time
    sync
    report_time
    
    printf  "\nSorting with Octave explicit loops extrapolated...\n"
    $time_cmd octave selsort.m ${count20}nums > sorted-list 2> time
    sync
    report_time 20
fi
