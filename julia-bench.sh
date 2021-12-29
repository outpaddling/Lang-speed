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

# Julia
if ! which julia; then
    mm=1.7
    p=1
    julia_version=$mm.$p
    # Naming of the URLs on the Julia site is inconsistent
    # ("x64" for the directory name, "mac64" or "freebsd-x86-64"
    # in the filename, so we can't easily construct the URL using
    # $(uname) here.  We'd need a messy nested case that might get broken
    # by the next release anyway.  Edit below for OS and CPU.
    dist=julia-$julia_version-freebsd-x86_64.tar.gz
    if [ ! -e julia-$julia_version/bin/julia ]; then
	if [ ! -e $dist ]; then
	    fetch https://julialang-s3.julialang.org/bin/freebsd/x64/$mm/$dist
	    tar zxvf $dist
	fi
    fi
    export PATH=${PATH}:$(pwd)/julia-$julia_version/bin
fi

printf "\nSorting integer array with Julia optimized (selsort-le.julia)...\n"
$time_cmd julia selsort-le.julia < ${count}nums > sorted-list 2> time
report_time

printf "\nSorting integer array with Julia simple (selsort.julia)...\n"
$time_cmd julia selsort.julia < ${count20}nums > sorted-list 2> time
report_time 20

