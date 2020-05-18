#include <iostream>
#include <sysexits.h>
#include "long.h"

using std::cout;
using std::cin;

class Array
{
    private:
	data_t  *array;
	size_t  size;
    public:
	Array();
	~Array();
	void    read(void);
	void    sort(void);
	void    print(void);
};

Array::Array()

{
    array = 0;
    size = 0;
}

Array::~Array()

{
    if ( array != 0 )
	delete array;
}

void Array::sort()

{
    size_t  base,
	    c,
	    min;
    data_t    temp;
	    
    for (base=0; base < size-1; ++base)
    {
	min = base+1;
	for (c=base; c < size; ++c)
	    if ( array[c] < array[min] )
		min = c;
	temp = array[min];
	array[min] = array[base];
	array[base] = temp;
    }
}

void Array::read()

{
    size_t  c;
    
    cin >> size;
    array = new data_t[size];
    
    for (c=0; c<size; ++c)
	cin >> array[c];
}

void Array::print()

{
    size_t  c;

    for (c=0; c<size; ++c)
	cout << array[c] << "\n";
}

int     main(int argc,char *argv[])

{
    Array   array;
    
    array.read();
    array.sort();
    array.print();
    return EX_OK;
}

