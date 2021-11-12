#include <stdio.h>
#include <stdlib.h>

/*
 *  Generate N pseudo-random numbers that fit in a C int for benchmarking
 *  selection sort.  Randomness is not important since selection sort is
 *  unaffected by initial sequence, unlike quicksort.
 */

int     main(int argc,char *argv[])

{
    int     c,
	    count;
    
    count = atol(argv[1]);
    printf("%d\n",count);
    for (c=0; c<count; ++c)
	printf("%d\n",(int)random());
    return 0;
}

