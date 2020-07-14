#!/usr/bin/env perl
#
# Author: J Bacon
# Description: Selection sort

use List::Util qw(reduce);

&read_array($array);
&sort_array($array);
&print_array($array);
exit;

# Read array
sub read_array
{
    local (*array) = @_;
    local ($count);
    
    $count = <STDIN>;
    $c = 0;
    while ( $inputline = <STDIN> )
    {
	$array[$c] = $inputline;
	$c++;
    }
}

sub sort_array
{
    local (*array) = @_;
    
    for ($base = 0; $base < @array - 1; ++$base )
    {
	# Find smallest using vector operations
	# This is a popular solution on the forums
	$min = reduce { $array[$a] < $array[$b] ? $a : $b } $base..$#array;
	
	$temp = $array[$min];
	$array[$min] = $array[$base];
	$array[$base] = $temp;
    }
}


sub print_array
{
    local (*array) = @_;
    
    for ($c = 0; $c < @array; ++$c)
    {
	print $array[$c];
    }
}
