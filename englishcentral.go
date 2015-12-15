package main

import (
	"errors"
	"flag"
	"fmt"
	"github.com/jirkadanek/onlinea/ec"
	"io"
	"log"
	"os"
	"strconv"
	"strings"
	"text/tabwriter"
	"time"
)

var firstEndDate ec.Date

func init() {
	firstEnd, err := time.Parse(ec.DateFormat, "2015-10-13")
	if err != nil {
		panic(err)
	}
	firstEndDate = ec.Date{firstEnd}
}

func EnglishCentral(args []string) {
	flagset := flag.NewFlagSet("englishcentral", flag.PanicOnError)
	month := flagset.Int("month", 0, "month number of the semester, starting from 1")
	url := flagset.Bool("url", false, "print Progress Report URL")
	blok := flagset.String("blok", "", "filepath to csv exported blok")
	xls := flagset.String("xls", "", "filepath to xls Progress Report")
	flagset.Parse(args)

	if *url {
		if *month <= 0 {
			log.Fatal("month must be >= 1")
		}
		printUrl(*month)
	} else if *blok != "" && *xls != "" {
		//students := readBlok(*blok)

		r, err := os.Open(*xls)
		w, err := ec.ParseWorkbook(r)
		results, err := ec.ParseProgressReport(w)

		_ = err

		//log.Println(students)
		//log.Println(results)

		printBlok(os.Stdout, results)
	} else {
		log.Fatal("specify either url or blok and xls")
	}
}

func printUrl(month int) {
	startDate, endDate := ec.Month(firstEndDate, month)
	fmt.Println(ec.Url(startDate, endDate))
}

func printBlok(w io.Writer, results []ec.ProgressReport) {
	for _, result := range results {
		uco, err := ucoFor(result)
		if err != nil {
			log.Printf("Cannot extract uco from %v: %v", result, err)
			continue
		}
		points := pointsFor(result)
		printBlokRecordHeader(w, fmt.Sprintf("%d/ONLINE_A/420917", uco))
		printBlokRecordECBody(w, result, points)
	}
}

func ucoFor(result ec.ProgressReport) (int, error) {
	addr := result.StudentEmail
	i := strings.Index(addr, "@")
	if i == -1 {
		return 0, errors.New("invalid e-mail address")
	}
	uco, err := strconv.ParseInt(addr[:i], 10, 32)
	if err != nil {
		return 0, errors.New("unexpected e-mail format")
	}
	return int(uco), nil
}

func pointsFor(result ec.ProgressReport) float32 {
	completion := result.CombinedGoalCompletion
	last := len(completion) - 1
	points, err := strconv.ParseFloat(completion[:last], 32)
	if err != nil {
		panic("unexpected completion format")
	}
	return float32(points) / 2.0
}

func printBlokRecordECBody(w io.Writer, r ec.ProgressReport, points float32) {
	fmt.Fprintf(w, "\n")
	f := tabwriter.NewWriter(w, 0, 8, 2, ' ', 0) //tabwriter.Debug)
	fmt.Fprintf(f, "|Lines Recorded\t%d\n", r.LinesRecorded)
	fmt.Fprintf(f, "|Videos Spoken\t%d / %d\n", r.VideosSpoken, r.VideosSpokenGoal)
	fmt.Fprintf(f, "|Speak Points\t%d / %d\n", r.SpeakPoints, r.SpeakPointsGoal)
	fmt.Fprintf(f, "|Quizzed Words\t%d / %d\n", r.QuizzedWords, r.QuizzedWordsGoal)
	fmt.Fprintf(f, "|CombinedGoalCompletion\t%s\n", r.CombinedGoalCompletion)
	fmt.Fprintf(f, "|\n|\t*%.2f\n", points)
	f.Flush()
}
