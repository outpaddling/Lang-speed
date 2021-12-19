
use std::io;

fn main()
{
    let list: Vec<i32> = Vec::new();
    
    // Statements here are executed when the compiled binary is called
    read_list(list);
    //print_list(list);
}


fn read_list(mut list: Vec<i32>)

{
    let mut str = String::new();
    io::stdin().read_line(&mut str).expect("failed to read input.");
    let list_size: usize = str.trim().parse::<usize>().expect("invalid input");
    println!("list_size = {:?}", list_size);
    
    for c in 0..list_size
    {
	println!("c = {:?}", c);
	io::stdin().read_line(&mut str).unwrap();
	list.push(str.trim().parse().unwrap());
	//println!("Type 1 : User entered value is {:?}", list[c]);
    }
}


fn selection_sort(mut list: Vec<i32>)
{
    for i in 0..list.len()
    {
	let mut small = i;
	for j in (i + 1)..list.len()
	{
	    if list[j] < list[small]
	    {
		small = j;
	    }
	}
	list.swap(small, i);
    }
}

/*
fn print_list(mut list: Vec<i32>)

{
    for n in list
    {
	println!("{}", n);
    }
}
*/
