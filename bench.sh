#!/bin/sh -e

line()
{
    printf '==========================================================\n'
}

print_time () {
    minutes=`printf "scale=5; ${seconds} / 60\n" | bc`
    hours=`printf "scale=5; ${minutes} / 60\n" | bc`
    printf "User time = ${seconds} seconds (${minutes} minutes) (${hours} hours).\n"
}

report_time () {
    seconds=`grep 'real.*user.*sys' time | awk ' { print $3 }'`
    print_time
}

if [ $# != 1 ]; then
    printf  "Usage: $0 <count>\n"
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

line
$clang --version
line
$gcc --version
line
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

printf  "\nSorting with Go...\n"
$time_cmd go run selsort.go < ${count}nums out > sorted-list 2> time
sync
report_time

# FIXME: Add julia

printf  "\nSorting with Java int array, Just-In-Time compiler enabled...\n"
$time_cmd java SelectSortInt < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with Java long array, Just-In-Time compiler enabled...\n"
$time_cmd java SelectSort < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with Java long array, Just-In-Time compiler disabled...\n"
$time_cmd java -Xint SelectSort < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with Python+numba...\n"
$time_cmd ./selsort-numba.py ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with Python...\n"
$time_cmd $python selsort.py ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with Perl...\n"
$time_cmd perl ./selsort.pl < ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with R...\n"
$time_cmd Rscript ./selsort.R ${count}nums > sorted-list 2> time
sync
report_time

printf  "\nSorting with vectorized R...\n"
$time_cmd Rscript ./selsort-vectorized.R ${count}nums > sorted-list 2> time
sync
report_time

# printf  "\nSorting with Octave...\n"
# $time_cmd octave --jit-compiler selsort.m ${count}nums > sorted-list 2> time
# sync
# report_time

exit

pcount=5000
if [ $count -gt $pcount ]; then
    printf  "\nThe Perl version of selection sort would take too long for\n"
    printf  "a large data set.  The time below is for $pcount elements.  To estimate\n"
    printf  "how long the script would take for $count, we multiply by ($count^2 / $pcount^2).\n"
    ./genrand $pcount > ${pcount}nums
    $time_cmd ./selsort.pl < ${pcount}nums > sorted-list 2> time
    report_time
    s=`cat time | awk ' { print $3 }'`
    seconds=`printf  "scale=5\n${s} * $count^2 / $pcount^2\n" | bc`
    printf "Estimated user time for $count:\n"
    print_time
else
    $time_cmd ./selsort.pl < ${count}nums > sorted-list 2> time
    report_time
fi
sync
