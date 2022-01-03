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
