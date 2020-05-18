#!/usr/bin/env perl
#
# Author:
# Title:
# Description:
# Command-line arguments:
# Return values:
#

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
	$min = $base;
	for ($c = $base + 1; $c < @array; ++$c)
	{
	    if ( $array[$c] < $array[$min] )
	    {
		$min = $c;
	    }
	}
	
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

