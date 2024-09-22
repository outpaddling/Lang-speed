#!/bin/sh -e

# FIXME: Make sure all programs use the same size integer

line()
{
    printf '==========================================================\n'
}

print_time () {
    minutes=`printf "scale=5; ${seconds} / 60\n" | bc -l`
    hours=`printf "scale=5; ${minutes} / 60\n" | bc -l`
    printf "$format_4_6" "$seconds" "$minutes" "$hours"
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
    printf "$format_7" \
	"$(fgrep 'maximum resident set' time | awk '{ print $1 }')"
}

if [ $# != 1 ]; then
    printf  "Usage: $0 <count>\n"
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
$gfortran --version
line
rustc --version
line
fpc -version 2>&1 | fgrep version || true
line
ldc2 --version | head -1
line
go version
line
$java -version
line
$python --version
line
perl --version
line
R --version
line
octave --version
line

# Always compile, so that compiler output is included in results
./compile-progs.sh

sync

line

format_1_3="%-20s %-10s %-10s "
format_4_6="%10s %8s %6s "
format_7="%5s\n"
format="$format_1_3$format_4_6$format_7"
printf "$format" "Language" "Type" "Access" "Seconds" "Minutes" "Hours" "RSS"

format_4_6="%10.2f %8.1f %6.1f "
format="$format_1_3$format_4_6$format_7"

compiler="unix-sort"
type="int"
access="-"
printf "$format_1_3" "$compiler" "$type" "$access"
$time_cmd sort -n < ${count}nums > sorted-list 2> time
sync
report_time

# C
for compiler in $clang $gcc; do
    for access in subscripts pointers; do
	for type in int long float double; do
	    printf "$format_1_3" "$compiler" "$type" "$access"
	    $time_cmd ./selsort-$compiler-$access-$type \
		< ${count}nums > sorted-list-$access-$type 2> time
	    sync
	    report_time
	done
    done
done

# C++
for compiler in $clangxx $gxx; do
    for access in subscripts pointers vectors; do
	for type in int long float double; do
	    printf "$format_1_3" "$compiler" "$type" "$access"
	    $time_cmd ./selsort-$compiler-$access-$type \
		< ${count}nums > sorted-list 2> time
	    sync
	    report_time
	done
    done
done

# Fortran
# flang is still not finished as of llvm15
for compiler in $gfortran; do
    for type in integer real 'real(8)'; do
	printf "$format_1_3" "$compiler" "$type" "$access"
	if [ -e selsort-$compiler-$type ]; then
	    $time_cmd ./selsort-$compiler-$type \
		< ${count}nums > sorted-list 2> time
	    sync
	    report_time
	fi
    done
done

for type in i32 i64; do
    if [ -e selsort-rust-$type ]; then
	compiler="rust"
	access="subscripts"
	printf "$format_1_3" "$compiler" "$type" "$access"
	$time_cmd ./selsort-rust-i32 < ${count}nums > sorted-list 2> time
	sync
	report_time
    fi
done

# Pascal
if [ -e selsort-pas ]; then
    compiler="fpc"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd ./selsort-pas < ${count}nums > sorted-list 2> time
    sync
    report_time
fi

# D
if [ -e selsort-d ]; then
    compiler="ldc"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd ./selsort-d < ${count}nums > sorted-list 2> time
    sync
    report_time
fi

if [ -e selsort-go ]; then
    compiler="go"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd ./selsort-go < ${count}nums out > sorted-list 2> time
    sync
    report_time
fi

if [ -e SelectSortInt.class ]; then
    compiler="java-jit"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd $java SelectSortInt < ${count}nums > sorted-list 2> time
    sync
    report_time
fi

if [ -e SelectSort.class ]; then
    compiler="java-jit"
    type="long"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd $java SelectSort < ${count}nums > sorted-list 2> time
    sync
    report_time

    compiler="java-no-jit"
    type="long"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd $java -Xint SelectSort < ${count5}nums > sorted-list 2> time
    sync
    report_time 5
fi

if [ -n "$python" ]; then
    compiler="py numba"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    # FIXME: Find out how to test for presence of numba
    if $time_cmd $python ./selsort-numba.py ${count}nums > sorted-list 2> time; then
	sync
	report_time
    fi
    
    compiler="py vectorized"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd $python selsort-vectorized.py ${count5}nums > sorted-list 2> time
    sync
    report_time 5
    
    compiler="py explicit"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd $python selsort.py ${count5}nums > sorted-list 2> time
    sync
    report_time 5
fi

if which perl > /dev/null; then
    compiler="perl vectorized"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd perl ./selsort-vectorized.pl < ${count5}nums > sorted-list 2> time
    sync
    report_time 5
    
    compiler="perl explicit"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd perl ./selsort.pl < ${count5}nums > sorted-list 2> time
    sync
    report_time 5
fi

if which R > /dev/null; then
    compiler="R vectorized"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd Rscript ./selsort-vectorized.R ${count}nums > sorted-list 2> time
    sync
    report_time
    
    compiler="R explicit"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd Rscript ./selsort.R ${count5}nums > sorted-list 2> time
    sync
    report_time 5
fi

if which octave > /dev/null; then
    compiler="Octave vectorized"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd octave selsortvectorized.m ${count}nums > sorted-list 2> time
    sync
    report_time
    
    compiler="Octave explicit"
    type="integer"
    access="subscripts"
    printf "$format_1_3" "$compiler" "$type" "$access"
    $time_cmd octave selsort.m ${count20}nums > sorted-list 2> time
    sync
    report_time 20
fi
