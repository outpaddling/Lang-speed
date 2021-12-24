import std.stdio;
import std.algorithm;
import std.range;
import std.conv;
import std.string;

void main()
{
    int[200000] list;
    uint    list_size;

    list_size = read_list(list);
    selsort(list, list_size);
    print_list(list, list_size);
}


uint    read_list(int[] list)

{
    uint    list_size, c;
    string  line;
    
    line = strip(readln);
    list_size = std.conv.to!uint(line,10);
    for (c = 0; c < list_size; ++c)
    {
	line = strip(readln);
	list[c] = std.conv.to!int(line,10);
    }
    return list_size;
}


void    print_list(int[] list, uint list_size)

{
    uint    c;
    
    for (c = 0; c < list_size; ++c)
	writeln(list[c]);
}


void    selsort(int[] list, uint list_size)

{
    uint    start, c, low;
    int     temp;
    
    for (start = 0; start < list_size - 1; ++start)
    {
	low = start;
	for (c = start + 1; c < list_size; ++c)
	    if ( list[c] < list[low] )
		low = c;
	temp = list[low];
	list[low] = list[start];
	list[start] = temp;
    }
}
