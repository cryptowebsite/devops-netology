package main

import "fmt"

func Numbers(number int) []int {
    numbers := []int{}

    for i := 1; i < 100; i++ {
        if i % number == 0 {
            numbers = append(numbers, i)
        }
    }

	fmt.Printf("Numbers divisible by %d: %d\n", number, numbers)
	return numbers
}

func main() {
	Numbers(3)
}
