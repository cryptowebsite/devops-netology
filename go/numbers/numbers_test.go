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
