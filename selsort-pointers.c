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


void    selsort(array_t *array)

{
    data_t  *base,
	    *p,
	    *min,
	    *end = array->data + array->size;
    data_t  temp;
	    
    for (base = array->data; base < end; ++base)
    {
	min = base;
	for (p = base + 1; p < end; ++p)
	    if ( *p < *min )
		min = p;
	temp = *min;
	*min = *base;
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
