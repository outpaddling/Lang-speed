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
    size_t  c;
    
    fscanf(stream,"%zu",&array->size);
    array->data = malloc(array->size * sizeof(data_t));
    if ( array->data == NULL )
    {
	fputs("malloc error\n",stderr);
	exit(1);
    }
    for (c=0; c < array->size; ++c)
    {
	fscanf(stream,INPUT_FORMAT_STRING,array->data+c);
    }
}


void    selsort(array_t *array)

{
    size_t  base,
	    c,
	    min;
    data_t    temp;
	    
    for (base=0; base < array->size; ++base)
    {
	min = base;
	for (c=base; c < array->size; ++c)
	    if ( array->data[c] < array->data[min] )
		min = c;
	temp = array->data[min];
	array->data[min] = array->data[base];
	array->data[base] = temp;
    }
}


void    print_array(FILE *stream,array_t *array)

{
    size_t  c;
    
    for (c=0; c < array->size; ++c)
	fprintf(stream,OUTPUT_FORMAT_STRING,array->data[c]);
}

