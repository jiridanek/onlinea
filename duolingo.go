package main

import (
	"bytes"
	"flag"
	"fmt"
	"github.com/jirkadanek/onlinea/duolingo"
	"github.com/jirkadanek/onlinea/ismu/bloky"
	"github.com/jirkadanek/onlinea/misc"
	"io"
	"log"
	"os"
	"strings"
	"time"
)

var (
	first = time.Date(2015, time.September, 21, 23, 0, 0, 0, time.UTC) // first day of the semester
)

func dateString(i int) (string, string) {
	begin_date := first
	for ; i > 1; i-- {
		begin_date = begin_date.AddDate(0, 0, 7)
	}

	format := "2006-01-02"
	return begin_date.Format(format), begin_date.AddDate(0, 0, 6).Format(format)
}

func Duolingo(args []string) {
	//     fmt.Println("Duolingo")

	flagset := flag.NewFlagSet("duolingo", flag.PanicOnError)
	week := flagset.Int("week", 0, "week number of the semester, starting from 1")
	blok := flagset.String("blok", "", "filepath to csv exported Duolingo blok")
	nick := flagset.String("nick", "", "week number of the semester, starting from 1")
	//format := flagset.Int("week", 0, "blok, text")
	flagset.Parse(args)

	if *week <= 0 {
		log.Fatal("week must be 1 or more")
	}

	i := 0
	modes := []bool{*blok != "", *nick != ""}
	for _, v := range modes {
		if v {
			i++
		}
	}
	if i != 1 {
		log.Fatal("specify exactly one of blok, nick")
	}

	begin_date, end_date := dateString(*week)

	if *blok != "" {
		records := readBlok(*blok)

		students, events := duolingo(begin_date, end_date, "")
		print_scores(records, students, events)
	}
	if *nick != "" {
		students, events := duolingo(begin_date, end_date, *nick)
		_ = students
		record := bloky.Record{[]string{"", "", "", "", "", "", "", ""}}
		if len(events) != 1 {
			panic("len events is not 1")
		}
		var event EventsOrErr = events[0]
		print_scores_student(os.Stdout, record, event, false)
	}
}

type EventsOrErr struct {
	Events []duo.Event
	Err    string
}

func fetch_activity_for_week(begin_date, end_date string) ([]duo.Observee, map[string]EventsOrErr) {
	duo.DoLogin()
	students, events := fetch_student_list_and_errors()
	for _, student := range students {
		user_id := fmt.Sprintf("%d", student.User_id)
		res, err := fetch_activity_for_week_for_id(begin_date, end_date, user_id)
		if err != nil {
			log.Fatal(err)
		}
		events[user_id] = EventsOrErr{Events: res.Events}
	}
	return students, events
}

func fetch_activity_for_week_for_nick(begin_date, end_date, nick string) (duo.Observee, EventsOrErr) {
	duo.DoLogin()
	students, events := fetch_student_list_and_errors()

	for _, student := range students {
		if !strings.EqualFold(nick, student.User_name) {
			continue
		}
		user_id := fmt.Sprintf("%d", student.User_id)
		if events[user_id].Err != nil {
			return student, events[user_id]
		}
		res, err := fetch_activity_for_week_for_id(begin_date, end_date, user_id)
		if err != nil {
			return student, EventsOrErr{Events: res.Events}
		} else {
			return student, EventsOrErr{Err: err}
		}
	}
	log.Panic("nick not found, does not exist or not leaning en")
	return nil, nil
}

func fetch_activity_for_week_for_id(begin_date, end_date, user_id string) (res duo.EventsResult, err error) {
	for i := 0; i < 10; i++ {
		res, err = duo.DoEventsGet(user_id, begin_date, end_date)
		if err != nil {
			continue
		}
		return
	}
}

func fetch_student_list_and_errors() ([]duo.Observee, map[string]EventsOrErr) {
	students := make([]duo.Observee, 0)
	events := make(map[string]EventsOrErr)

	dashboard := duo.DoDashboardGet()
	for _, observee := range dashboard.Observees {
		if observee.Learning_language != "en" {
			user_id := fmt.Sprintf("%d", observee.User_id)
			msg := "You are learning language(s) "
			if _, found := events[user_id]; found {
				msg = events[user_id].Err + ", "
			}
			events[user_id] = EventsOrErr{Err: msg + observee.Learning_language}
			continue
		}
		students = append(students, observee)
	}
	return students, events
}

func duolingo(begin_date, end_date, nick string) ([]duo.Observee, map[string]EventsOrErr) {
	if nick != "" {
		return fetch_activity_for_week(begin_date, end_date)
	} else {
		return fetch_activity_for_week_for_nick(begin_date, end_date, nick)
	}
}

func readBlok(fname string) []bloky.Record {
	fp, err := os.Open(fname)
	if err != nil {
		log.Fatal("blok must be a valid filepath", err)
	}
	reader := bloky.NewReader(fp)
	records, err := reader.ReadAll()
	if err != nil {
		log.Fatal(err)
	}
	return records
}

func print_scores(records []bloky.Record, students []duo.Observee, events map[string]EventsOrErr) {
	for _, r := range records {
		found := false
		for _, s := range students {
			nick := misc.NickFromBlokText(r.Value())
			if strings.EqualFold(nick, s.User_name) {
				found = true
				user_id := fmt.Sprintf("%d", s.User_id)
				var b bytes.Buffer
				print_scores_student(&b, r, events[user_id], false)
				if b.Len() > 4000 {
					b.Reset()
					print_scores_student(&b, r, events[user_id], true)
				}
				fmt.Printf(b.String())
			}
		}
		if !found {
			// student is in block but is not in dashboard, studying en
			//TODO the other direction
			log.Printf("student %s je v bloku ale není na duolingu!!!", r.Uco()) //FIXME: write something better
		}
	}
}

func score(event duo.Event) int {
	switch event.Type {
	case "lesson":
		return 10
	case "test":
		return 10
	case "practice":
		if event.Skill_title == "" {
			return 15
		}
		return 0
	default:
		return 0
	}
}

func printBlokRecordHeader(w io.Writer, id string) {
	fmt.Fprintf(w, "\t\t\t\t\t\t%s\t", id)
}

func print_scores_student(w io.Writer, student bloky.Record, eventsOrErr EventsOrErr, brief bool) {
	printBlokRecordHeader(w, student.Id())

	if eventsOrErr.Err == "" {
		events := eventsOrErr.Events

		nlessons := 0
		plessons := 0
		npractices := 0
		ppractices := 0

		for _, event := range events {
			switch event.Type {
			case "lesson", "test":
				nlessons++
				plessons += score(event)
			case "practice":
				if event.Skill_title != "" { // practicing a concrete skill
					continue
				}
				npractices++
				ppractices += score(event)
			}
		}

		ptotal := plessons
		if ppractices < ptotal {
			ptotal = ppractices
		}
		if 70 < ptotal {
			ptotal = 70
		}

		fmt.Fprintf(w, "Lessons:   %3d ... %4d points\n", nlessons, plessons)
		fmt.Fprintf(w, "|Practices: %3d ... %4d points\n", npractices, ppractices)
		fmt.Fprintf(w, "|Total: *%d points (calculated as min( min(Lessons,Practices), 70))\n", ptotal)
		fmt.Fprintf(w, "|\n")
		fmt.Fprintf(w, "|      Lesson                  Activity type     Points\n")
		fmt.Fprintf(w, "|----------------------------------------------------------\n")
		if len(events) == 0 || brief {
			fmt.Fprintf(w, "|\n")
			if len(events) == 0 {
				fmt.Fprintf(w, "|no activities were completed\n")
			} else if brief {
				fmt.Fprintf(w, "|a lot of activities were completed\n")
			}
			fmt.Fprintf(w, "|\n")
		} else {
			for _, event := range events {
				if !brief {
					fmt.Fprintf(w, "|%30s %10s %5d\n", event.Skill_title, event.Type, score(event))
				}
			}
		}
	} else {
		fmt.Fprintf(w, "|\n")
		fmt.Fprintf(w, "|asi mate Duolingo prepnute do jineho nez anglickeho kurzu\n")
		fmt.Fprintf(w, "|v takovem pripade bohuzel nevidim vase ziskane body\n")
		fmt.Fprintf(w, "|\n")
		fmt.Fprintf(w, "|%s\n", eventsOrErr.Err)
		fmt.Fprintf(w, "|\n")
	}
	fmt.Fprintf(w, "|--------------------------------------------------\n")
}
