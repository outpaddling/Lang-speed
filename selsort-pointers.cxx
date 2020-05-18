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
    data_t  *base,
	    *p,
	    *min,
	    *end=array+size;
    data_t  temp;
	    
    for (base=array; base < end; ++base)
    {
	min = base;
	for (p=base; p < end; ++p)
	    if ( *p < *min )
		min = p;
	temp = *min;
	*min = *base;
	*base  = temp;
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

