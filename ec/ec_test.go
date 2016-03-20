package ec

import (
	"fmt"
	"os"
	"testing"
	"time"
)

var _ = fmt.Print

var termStart Date

func init() {
	termStartTime, err := time.Parse(DateFormat, "2015-10-13")
	if err != nil {
		panic(err)
	}
	termStart = Date{termStartTime}
}

func assertDates(t *testing.T, expected string, actual Date) {
	expectedTime, err := time.Parse(DateFormat, expected)
	if err != nil {
		t.Fatal(err)
	}
	if !actual.Equal(expectedTime) {
		t.Error("expected ", expected, " actual ", actual)
	}
}

func TestGetUrl(t *testing.T) {
	startDate, endDate := Month(termStart, 2)
	Url(startDate, endDate)
}

func TestMonth(t *testing.T) {
	startDate, endDate := Month(termStart, 2)
	assertDates(t, "2015-10-14", startDate)
	assertDates(t, "2015-11-13", endDate)
}

func TestParseWorkbook(t *testing.T) {
	w := parseWorkbook(t, "ClassReport.xls")
	_ = w
	//fmt.Println(w)
}

func TestParseProgressReport(t *testing.T) {
	w := parseWorkbook(t, "ClassReport.xls")
	r, err := ParseProgressReport(w)
	if err != nil {
		t.Fatal(err)
	}
	_ = r
	fmt.Print(r)
}

func TestFieldLabels(t *testing.T) {
	labels := fieldLabels(struct {
		AA, B, FirstSecond string
	}{})
	assertEqualStringSlices(t, []string{"A A", "B", "First Second"}, labels)
}

func assertEqualStringSlices(t *testing.T, expected, actual []string) {
	if len(expected) != len(actual) {
		t.Fatal("different length")
	}
	for i := range expected {
		if expected[i] != actual[i] {
			t.Fatal("element", expected[i], " is not equal to ", actual[i])
		}
	}
}

func parseWorkbook(t *testing.T, filename string) Workbook {
	r, err := os.Open("ClassReport.xls")
	if err != nil {
		t.Fatal(err)
	}
	w, err := ParseWorkbook(r)
	if err != nil {
		t.Fatal(err)
	}
	return w
}
