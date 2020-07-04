#!/usr/bin/env python

import sys,os

#####################################################################
# Author:       J Bacon
# Description:  Read a list of integers from a file into an array.
#               The first line in the file is the size of the list
#               and the list elements follow, one per line.
# Returns:      Size of the list and the array containing the list
#####################################################################

def read_file(file):
    size = 0
    f = open(file, 'r')
    
    # Read size
    size = int(f.readline())
    
    # Allocate array
    list = [0] * size
    
    # Read list
    try:
        for i in range(0, size):
            list[i] = int(f.readline())
    finally:
        f.close()
    return size, list


#####################################################################
# Author:       J Bacon
# Description:  Sort a list of integers contained in an array
# Returns:      Nothing: The array is passed by reference and
#               modified in-place.
#####################################################################

def sort_list(list, size):
    for start in range(0, size):
        
        # Find smallest using vector operations
        low_val=min(list[start:size])
        low=list.index(low_val,start,size)

        # Swap
        temp = list[start]
        list[start] = list[low]
        list[low] = temp
    return
    

#####################################################################
# Author:       J Bacon
# Description:  Print the contents of an array
# Returns:      Nothing
#####################################################################

def print_list(list, size):
    for i in range(0, size):
        print(list[i])
    return


#####################################################################
# Main
# Author:       J Bacon
# Description:  Read a list of integers from a file
#               and print the list in sorted order.
#####################################################################

if len(sys.argv) != 2:
    print("Usage: sys.argv[0] input-file\n")
else:
    input_file = sys.argv[1]
    
    size, list = read_file(input_file)
    sort_list(list, size)
    print_list(list, size)

