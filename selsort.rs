
use std::io;

fn main()

{
    let mut list: Vec<i32> = Vec::new();
    
    read_list(&mut list);
    selection_sort(&mut list);
    print_list(list);
}


fn read_list(list: &mut Vec<i32>)

{
    let mut str = String::new();
    io::stdin().read_line(&mut str).expect("failed to read input.");
    let list_size: usize = str.trim().parse().expect("invalid input");
    println!("list_size = {:?}", list_size);

    list.reserve(list_size);
    for _c in 0..list_size
    {
	let mut str = String::new();
	io::stdin().read_line(&mut str).expect("failed to read input.");
	list.push(str.trim().parse().expect("invalid input"));
    }
}


fn selection_sort(list: &mut Vec<i32>)

{
    for start in 0..list.len()
    {
	let mut low = start;
	for c in (start + 1)..list.len()
	{
	    if list[c] < list[low]
	    {
		low = c;
	    }
	}
	list.swap(low, start);
    }
}


fn print_list(list: Vec<i32>)

{
    for n in list
    {
	println!("{}", n);
    }
}
