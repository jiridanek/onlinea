package ec

import (
	"encoding/xml"
	"fmt"
	"golang.org/x/net/html/charset"
	"io"
	"reflect"
	"regexp"
	"strconv"
	"strings"
	"time"
	//"github.com/tealeg/xlsx"
)

var _ = fmt.Println

var DateFormat string = "2006-01-02"

type Date struct{ time.Time }

func Url(startDate, endDate Date) string {
	reportUrl := "http://www.englishcentral.com/teach/reports/index/73339/41680/0/0/50/export/1/"
	reportUrl += "start/" + startDate.Format(DateFormat) + "/"
	reportUrl += "end/" + endDate.Format(DateFormat) + "/"
	reportUrl += "report/speak/"
	reportUrl += "filter/all/"
	reportUrl += "sort/alphabetical"
	return reportUrl
}

func Month(firstEnd Date, month int) (startDate, endDate Date) {
	return Date{firstEnd.AddDate(0, month-2, 1)}, Date{firstEnd.AddDate(0, month-1, 0)}
}

type Workbook struct {
	XMLName xml.Name `xml:"urn:schemas-microsoft-com:office:spreadsheet Workbook"`
	Rows    []Row    `xml:"Worksheet>Table>Row"`
}

type Row struct {
	Cells []string `xml:"Cell>Data"`
}

func ParseWorkbook(r io.Reader) (Workbook, error) {
	var w Workbook
	d := xml.NewDecoder(r)
	d.CharsetReader = func(s string, r io.Reader) (io.Reader, error) { return charset.NewReader(r, s) } //  with charset.NewReaderLabe returns err == io.EOF
	d.Entity = xml.HTMLEntity                                                                           // otherwise errs with "invalid character entity &iacute;"
	err := d.Decode(&w)
	return w, err
}

func ParseProgressReport(workbook Workbook) ([]ProgressReport, error) {
	result := make([]ProgressReport, 0)
	var progressReport ProgressReport
	labels := fieldLabels(progressReport)
	header, index := findHeader(workbook, labels)
	if index == -1 {
		return result, nil
	}
	for i := index + 1; i < len(workbook.Rows); i++ {
		cells := workbook.Rows[i].Cells
		if len(header) == len(cells) {
			report := makeReport(cells, header)
			result = append(result, report)
		}
	}
	return result, nil
}

func makeReport(row, labels []string) ProgressReport {
	s := ProgressReport{}
	st := reflect.ValueOf(&s)
	for i, label := range labels {
		fieldName := strings.Replace(label, " ", "", -1)
		field := st.Elem().FieldByName(fieldName)
		if !field.IsValid() {
			continue
		}
		switch field.Type().Kind() {
		case reflect.String:
			field.SetString(row[i])
		case reflect.Int:
			v, err := strconv.ParseInt(row[i], 10, 32)
			if err != nil {
				panic(err)
			}
			field.SetInt(v)
		default:
			panic("unsupported type")
		}
	}

	return s
}

func fieldLabels(s interface{}) []string {
	labels := make([]string, 0)
	st := reflect.TypeOf(s)
	for i := 0; i < st.NumField(); i++ {
		field := st.Field(i)
		name := field.Name
		label := regexp.MustCompile("[A-Z]").ReplaceAllStringFunc(name, func(s string) string { return " " + s })
		labels = append(labels, strings.TrimSpace(label))
	}
	return labels
}

func findHeader(workbook Workbook, labels []string) ([]string, int) {
	for r, row := range workbook.Rows {
		cells := make(map[string]bool)
		for _, cell := range row.Cells {
			cells[cell] = true
		}
		if isHeader(cells, labels) {
			return row.Cells, r
		}
	}
	header := make([]string, 0)
	return header, -1
}

func isHeader(cells map[string]bool, labels []string) bool {
	for _, label := range labels {
		if !cells[label] {
			return false
		}
	}
	return true
}

type ProgressReport struct {
	StudentName            string
	StudentEmail           string
	AccountStatus          string
	VideosSpoken           int
	VideosSpokenGoal       int
	SpeakPoints            int
	SpeakPointsGoal        int
	VideosWatched          int
	VideosWatchedGoal      int
	QuizzedWords           int
	QuizzedWordsGoal       int
	LinesRecorded          int
	CombinedGoalCompletion string
}
