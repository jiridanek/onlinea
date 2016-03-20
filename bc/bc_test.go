package bc

import (
	"fmt"
	"io/ioutil"
	"testing"
)

// Eval

func testExpression(t *testing.T, expression string, expected string) {
	actual, err := Eval(expression)
	if err != nil {
		t.Fatalf("Error while evaluating %v, %v", expression, err)
	}
	if actual != expected {
		t.Errorf("Expected %v evaluating %v, got %v", expected, expression, actual)
	}
}

func TestExpressions(t *testing.T) {
	for _, c := range [][]string{{"0", "0"}, {"3+4", "7"}} {
		testExpression(t, c[0], c[1])
	}
}

// Run

func testProgram(t *testing.T, program string, variables map[string]string, expected string) {
	actual, err := Run(program, variables)
	if err != nil {
		t.Fatalf("Error %v while running \"%v\" with %+v", err, program, variables)
	}
	if actual != expected {
		t.Errorf("Expected %v running %v with %+v, got %v", expected, program, variables, actual)
	}
}

func TestProgram(t *testing.T) {
	testProgram(t, "print p", map[string]string{"p": "5"}, "5")
}

// Variables

func compareStringSlices(t *testing.T, expected, actual []string) {
	if len(expected) != len(actual) {
		t.Errorf("len(expected) is %v, len(actual is %v, expected is %v, actual is %v",
			len(expected), len(actual), expected, actual)
		return
	}
	for i, v := range expected {
		if v != actual[i] {
			t.Errorf("At %v, expected is %v, actual is %v", i, v, actual[i])
		}
	}
}

func testVariables(t *testing.T, program string, expected []string) {
	actual := Variables(program)
	compareStringSlices(t, expected, actual)
}

func TestVariables(t *testing.T) {
	first, err := ioutil.ReadFile("first.bc")
	must(err)
	for _, c := range [][]string{
		{""},
		{"43a"},
		{"pes", "pes"},
		{"pes53", "pes53"},
		{string(first), "asumadisk", "b_447469", "ma_body_b_420950", "odpovednik", "skupina", "test"},
	} {
		program := c[0]
		variables := make([]string, 0)
		if len(c) > 0 {
			variables = c[1:len(c)]
		}
		testVariables(t, program, variables)
	}
}

func TestNoLineBreaksEval(t *testing.T) {
	longstring := "A very long string A very long string A very long string A very long string A very long string"
	result, err := Eval(fmt.Sprintf(`print "%v"`, longstring))
	must(err)
	if result != longstring {
		t.Errorf("Long string result is %v", result)
	}
}

func TestNoLineBreaksRun(t *testing.T) {
	longstring := "A very long string A very long string A very long string A very long string A very long string"
	result, err := Run(fmt.Sprintf(`print "%v"`, longstring), make(map[string]string))
	must(err)
	if result != longstring {
		t.Errorf("Long string result is %v", result)
	}
}

func must(err error) {
	if err != nil {
		panic(err)
	}
}
