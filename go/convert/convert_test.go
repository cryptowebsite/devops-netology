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
