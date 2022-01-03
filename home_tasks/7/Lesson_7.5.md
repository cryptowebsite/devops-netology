# Lesson 7.5

# 1 Напишите программу для перевода метров в футы (1 фут = 0.3048 метр)

convert.go
```
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
```

convert_test.go
```
package main

import "testing"

func TestConvert(t *testing.T)  {
    testTable := []struct {
        number float64
        expected float64
    } {
        {
            number: 3,
            expected: 9.84,
        },
        {
            number: 21,
            expected: 68.9,
        },
        {
            number: 113.55,
            expected: 372.54,
        },
    }

    for _, testCase := range testTable {
        result := Convert(float64(testCase.number))

        t.Logf("Calling Convert(%f), result %f", testCase.number, result)
	
        if result != testCase.expected {
            t.Errorf("Incorrect result. Expect %.2f but got %.2f", testCase.expected, result)
        }
    }

}
```

# 2 Напишите программу, которая найдет наименьший элемент в любом заданном списке

smallest.go
```
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
```

smallest_test.go
```
package main

import "testing"

func TestGetTheSmallestValue(t *testing.T)  {
    testTable := []struct {
        numbers []int
        expected int
    } {
        {
            numbers: []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17},
            expected: 9,
        },
        {
            numbers: []int{43, 1, 23, 4, 543, 12, 23, 34, 65, 23, 23, 23, -32, 32, -2323, 213, -23},
            expected: -2323,
        },
        {
            numbers: []int{23, 22, 23, 12, 45, 11, 15, 72, 11, 76, 12, 66, 23000, 1232131, 111111},
            expected: 11,
        },
    }

    for _, testCase := range testTable {
        result := GetTheSmallestValue(testCase.numbers)

        t.Logf("Calling Get_the_smallest_value(%d), result %d", testCase.numbers, result)

        if result != testCase.expected {
            t.Errorf("Incorrect result. Expect %d but got %d", testCase.expected, result)
        }
    }
}
```

# 3 Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть (3, 6, 9, …)

numbers.go
```
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
```

numbers_test.go
```
package main

import "testing"

func TestNumbers(t *testing.T)  {
    testTable := []struct {
        number int
        expected []int
	} {
        {
            number: 3,
            expected: []int{3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99},
        },
        {
            number: 15,
            expected: []int{15, 30, 45, 60, 75, 90},
        },
        {
            number: -5,
            expected: []int{5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95},
        },
    }

    for _, testCase := range testTable {
        result := Numbers(testCase.number)

        t.Logf("Calling Numbers(%d), result %d", testCase.number, result)

        if !isEqual(result, testCase.expected) {
            t.Errorf("Incorrect result. Expect %d but got %d", testCase.expected, result)
        }
    }
}

func isEqual(a []int, b []int) bool {
    for i, v := range a {
        res := v == b[i]
        if !res {
            return false
        }
    }
    return true
}
```