
// Enable use of Random number generator class
//import java.util.Random;

// Formatted I/O class
//import java.util.Scanner;     Requires Java 1.5

// Basic I/O classes
import java.io.*;

class ArrayD
{
    private double[]  array;
    private int     array_size;
    
    // Constructor
    public ArrayD()
    {
	array_size = 0;
    }
    
    // Read an array from standard input.  The first number read is the
    // size of the array.
    public void read()
    {
	String      line;
	int         c;
	
	BufferedReader stdin = 
	    new BufferedReader(new InputStreamReader(System.in));
	
	try
	{
	    line = stdin.readLine();
	    array_size = Integer.parseInt(line);
	    array = new double[array_size];
	}
	catch(IOException ioex)
	{
	    System.out.println("Input error.");
	    System.exit(1);
	}

	for (c=0; c<array_size; ++c)
	{
	    try
	    {
		line = stdin.readLine();
		array[c] = Integer.parseInt(line);
	    }
	    catch(IOException ioex)
	    {
		System.out.println("Input error.");
		System.exit(1);
	    }
	}
    }
    
    // Print contents of array, one element per line
    public void print()
    {
	for(int c=0; c < array_size; c++)
	    System.out.println(array[c]);
    }

    // Perform a selection sort on the array
    public void sort()
    {
	int     base,
		c,
		min;
	double    temp;

	for(base=0; base < array_size-1; base++)
	{
	    // Find smallest element remaining from base to the end
	    min = base;
	    for(c=base+1; c < array_size; c++)
		if(array[c] < array[min] )
		    min = c;
	    
	    // Swap min element to base
	    temp = array[base];
	    array[base] = array[min];
	    array[min] = temp;
	}
    }
}


class SelectSortD
{
    public static void main(String[] args)
    {
	ArrayD       array = new ArrayD();

	array.read();
	array.sort();
	array.print();
    }
}

