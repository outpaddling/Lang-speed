#include <stdio.h>
#include <stdlib.h>
#include "long.h"

typedef struct
{
    data_t  *data;
    size_t  size;
}   array_t;

void    print_array(FILE *stream,array_t *array);
void    read_array(FILE *stream,array_t *array);
void    selsort(array_t *array);

int     main(int argc,char *argv[])

{
    array_t array;
    
    read_array(stdin,&array);
    selsort(&array);
    print_array(stdout,&array);
    return 0;
}


void    read_array(FILE *stream,array_t *array)

{
    data_t  *p,
	    *end;
    
    fscanf(stream,"%zu",&array->size);
    array->data = malloc(array->size * sizeof(data_t));
    for (p=array->data, end=array->data+array->size; p < end; ++p)
	fscanf(stream,INPUT_FORMAT_STRING,p);
}


data_t  *find_low(data_t *array, data_t * restrict p, data_t *end)

{
    data_t  min = *p,
	    *minp = p;
    while (p < end)
    {
	if ( *p < min )
	{
	    // p is a restricted pointer, so only p can be used to
	    // reference array elements.  min is only used for
	    // address comparison.
	    min = *p;
	    minp = p;
	}
	++p;
    }
    return minp;
}


void    selsort(array_t *array)

{
    data_t  *base,
	    *minp,
	    *end = array->data + array->size;
    data_t  temp;
	    
    for (base = array->data; base < end; ++base)
    {
	minp = find_low(array->data, base + 1, end);
	temp = *minp;
	*minp = *base;
	*base = temp;
    }
}


void    print_array(FILE *stream,array_t *array)

{
    data_t  *p,
	    *end;
    
    for (p=array->data, end = array->data + array->size; p < end; ++p)
	fprintf(stream,OUTPUT_FORMAT_STRING,*p);
}
