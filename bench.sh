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
    print_time
}

if [ $# != 1 ]; then
    printf  "Utage: $0 <count>\n"
    exit 1
fi
count=$1

. versions.sh

# Linux: time_cmd="/usr/bin/time -f '%R real %U user %S sys'"
time_cmd=/usr/bin/time

line
date

line
uname -a

line
if [ -e /var/run/dmesg.boot ]; then 
    fgrep CPU: /var/run/dmesg.boot
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
		< ${count}nums > sorted-list 2> time
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
for compiler in $flang $gfortran; do
    for type in integer real 'real(8)'; do
	printf  "\nSorting $type array with $compiler and subscripts...\n"
	$time_cmd ./selsort-$compiler-$type \
	    < ${count}nums > sorted-list 2> time
	sync
	report_time
	rm -f selsort-$compiler-$type
    done
done

# Pascal
printf  "\nSorting int array Pascal...\n"
$time_cmd ./selsort-pas < ${count}nums > sorted-list 2> time
sync
report_time

# D
printf  "\nSorting int array D...\n"
$time_cmd ./selsort-d < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting i32 vector with Rust...\n"
$time_cmd ./selsort-rust < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with Go...\n"
$time_cmd ./selsort-go < ${count}nums out > sorted-list 2> time
sync
report_time

printf  "\nSorting with $java int array, Just-In-Time compiler enabled...\n"
$time_cmd $java SelectSortInt < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with $java long array, Just-In-Time compiler enabled...\n"
$time_cmd $java SelectSort < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with $java long array, Just-In-Time compiler disabled...\n"
$time_cmd $java -Xint SelectSort < ${count5}nums > sorted-list 2> time
sync
report_time 5

printf  "\nSorting longint array with Pascal...\n"
$time_cmd ./selsort-pas < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with Python+numba...\n"
$time_cmd $python ./selsort-numba.py ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with vectorized Python extrapolated...\n"
$time_cmd $python selsort-vectorized.py ${count5}nums > sorted-list 2> time
sync
report_time 5

printf "\nSorting with Python explicit loops extrapolated...\n"
$time_cmd $python selsort.py ${count5}nums > sorted-list 2> time
sync
report_time 5

printf  "\nSorting with vectorized Perl extrapolated...\n"
$time_cmd perl ./selsort-vectorized.pl < ${count5}nums > sorted-list 2> time
sync
report_time 5

printf  "\nSorting with Perl explicit loops extrapolated...\n"
$time_cmd perl ./selsort.pl < ${count5}nums > sorted-list 2> time
sync
report_time 5

printf  "\nSorting with vectorized R...\n"
$time_cmd Rscript ./selsort-vectorized.R ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with R explicit loops extrapolated...\n"
$time_cmd Rscript ./selsort.R ${count5}nums > sorted-list 2> time
sync
report_time 5

printf  "\nSorting with vectorized Octave...\n"
$time_cmd octave selsortvectorized.m ${count}nums > sorted-list 2> time
sync
report_time

# Julia
#export PATH=${PATH}:$HOME/julia-1.7.1/bin
#printf "\nSorting integer array with Julia...\n"
#$time_cmd julia selsort.julia < ${count20}nums > sorted-list 2> time
#sync
#report_time 20

printf  "\nSorting with Octave explicit loops extrapolated...\n"
$time_cmd octave selsort.m ${count20}nums > sorted-list 2> time
sync
report_time 20
