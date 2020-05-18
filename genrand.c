#include <stdio.h>
#include <stdlib.h>

int     main(int argc,char *argv[])

{
    int     c,
	    count;
    
    count = atoi(argv[1]);
    printf("%d\n",count);
    for (c=0; c<count; ++c)
	printf("%d\n",rand());
    return 0;
}

