{
    Author:
    Title:
    Date:
    Description:
}

{ Const section }

{ Type section }

{ Procedures and functions }

{ Var section for main }

program sort(input,output);

type list_t = array[1..200000] of longint;

procedure read_list(var list : list_t; var list_size : longint);

var     c : longint;

begin
    readln(list_size);
    writeln(list_size);
    for c := 1 to list_size do
    begin
	readln(list[c]);
    end;
end;

procedure print_list(list : list_t; list_size : longint);

var     c : longint;

begin
    for c := 1 to list_size do
    begin
	writeln(list[c]);
    end;
end;

procedure sort_list(var list : list_t; list_size : longint);

var     start, low, c, temp : longint;

begin
    for start := 1 to list_size - 1 do
    begin
	low := start;
	for c := start + 1 to list_size do
	begin
	    if ( list[c] < list[low] ) then
		low := c;
	end;
	temp := list[low];
	list[low] := list[start];
	list[start] := temp;
    end;
end;

var list        : list_t;
var list_size   : longint;

begin
    read_list(list, list_size);
    sort_list(list, list_size);
    print_list(list, list_size);
end.
