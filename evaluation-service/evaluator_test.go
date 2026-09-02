package main

import "testing"

func TestGetDeterministicBucket_Range(t *testing.T) {
	inputs := []string{"user-1flag-a", "user-2flag-a", "", "outro-usuario-outra-flag"}
	for _, input := range inputs {
		bucket := getDeterministicBucket(input)
		if bucket < 0 || bucket > 99 {
			t.Errorf("getDeterministicBucket(%q) = %d, esperado entre 0 e 99", input, bucket)
		}
	}
}

func TestGetDeterministicBucket_Deterministic(t *testing.T) {
	input := "user-123enable-new-dashboard"
	first := getDeterministicBucket(input)
	second := getDeterministicBucket(input)
	if first != second {
		t.Errorf("getDeterministicBucket(%q) não é determinístico: %d != %d", input, first, second)
	}
}

