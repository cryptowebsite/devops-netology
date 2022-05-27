package main

import "fmt"

func GetTheSmallestValue(values []int) int {
    min := values[0]

    for _, candidate := range values {
        if (candidate < min) {
            min = candidate
        }
    }

	fmt.Printf("The smallest value is %d\n", min)
	return min
}

func main() {
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
	GetTheSmallestValue(x)
}
