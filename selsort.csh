#!/bin/csh

set array = (`cat $1`)

@ count = $array[1]
@ base = 2
while ( $base < $#array )
    @ min = $base
    @ c = $base + 1
    while ( $c <= $#array )
	if ( $array[$c] < $array[$min] ) @ min = $c
	@ c++
    end
    @ temp = $array[$min]
    @ array[$min] = $array[$base]
    @ array[$base] = $temp
    @ base++
end

foreach num ($array[2-$#array])
    echo $num
end
