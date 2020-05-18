package main

import (
    "fmt"
)

/* */
func selectionSort(list []int) {

    for start := 0; start < len(list) - 1; start++ {
	fmt.Println(list[start])
	min := start
	for j := start + 1; j < len(list); j++ {
	    if list[j] < list[min] {
		min = j
	    }
	}
	list[start], list[min] = list[min], list[start]
	//list[start] = list[min]
	//list[min] = temp
    }
}

func main() {
    
    var list_size int
    
    fmt.Scanf("%d", &list_size)
    fmt.Println(list_size)
    list := make([]int, list_size)
    for c := 0; c < len(list); c++ {
	fmt.Scanf("%d", &list[c])
    }
    fmt.Println("Unsorted list: ", list)
    selectionSort(list)
    fmt.Println("Sorted list: ", list)
}
