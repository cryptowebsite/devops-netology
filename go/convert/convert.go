package main

import (
	"fmt"
	"math"
)

func Convert(m ...float64) float64 {
	var input float64

	if len(m) > 0 {
		input = m[0]
	} else {
		fmt.Print("Enter the number of meters: ")
		fmt.Scanf("%f", &input)
	}

	output := input * 3.28084
	fmt.Printf("%.2fm = %.2fft\n", input, output)
	return math.Round(output*100)/100
}

func main() {
	Convert()
}
