package main

import (
	"bytes"
	"flag"
	"fmt"
	"github.com/jirkadanek/onlinea/duolingo"
	"github.com/jirkadanek/onlinea/ismu/bloky"
	"github.com/jirkadanek/onlinea/mailing"
	"github.com/jirkadanek/onlinea/misc"
	"io"
	"log"
	"os"
	"strings"
)

func dateString(i int) (string, string) {
	begin_date := duo.First
	for ; i > 1; i-- {
		begin_date = begin_date.AddDate(0, 0, 7)
	}

	return begin_date.Format(duo.Format), begin_date.AddDate(0, 0, 6).Format(duo.Format)
}

func Duolingo(args []string) {
	flagset := flag.NewFlagSet("duolingo", flag.PanicOnError)
	week := flagset.Int("week", 0, "week number of the semester, starting from 1")
	blok := flagset.String("blok", "", "filepath to csv exported Duolingo blok")
	nick := flagset.String("nick", "", "week number of the semester, starting from 1")
	mail := flagset.String("mail", "", "dry, wet; send reminder e-mails, either dry or wet run")

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

		if *mail != "" {
			duo.DoLogin(duo.DefaultClient)
			dstudents, _ := fetch_student_list_and_errors("")

			mails := make([]mailing.DuolingoFailure, 0)

			// student is on Duolingo, but not in blok
			for _, dstudent := range dstudents {
				found := false
				email := dstudent.Email
				dusername := dstudent.User_name
				if dstudent.Section != "Jaro2016" {
					continue
				}
				if misc.UcoFromMuniMail(email) != "" {
					found = true
				}
				for _, rstudent := range records {
					rusername := misc.NickFromBlokText(rstudent.Value())
					if strings.EqualFold(dusername, rusername) {
						found = true
					}
				}
				if !found {
					mails = append(mails, mailing.DuolingoFailure{Email: email, Post: true})
				}
			}

			// student is in blok, but not on Duolingo
			for _, rstudent := range records {
				found := false
				email := fmt.Sprintf("%s@mail.muni.cz", rstudent.Uco())
				rusername := misc.NickFromBlokText(rstudent.Value())
				for _, dstudent := range dstudents {
					dusername := dstudent.User_name
					if strings.EqualFold(dusername, rusername) {
						found = true
					}
				}
				if !found {
					mails = append(mails, mailing.DuolingoFailure{Email: email, Click: true})
				}
			}

			msgs := mailing.DuolingoDokonceteRegistraci(mails)
			if *mail == "dry" {
				for _, mail := range mails {
					fmt.Printf("%+v\n", mail)
				}
			} else if *mail == "wet" {
				mailing.SendMessages(msgs...)
			}
		} else {
			students, events := fetch_activity_for_week(begin_date, end_date)
			print_scores(records, students, events)
		}
	}
	if *nick != "" {
		student, event := fetch_activity_for_week_for_nick(begin_date, end_date, *nick)
		_ = student
		record := bloky.Record{[]string{"", "", "", "", "", "", "", ""}}
		print_scores_student(os.Stdout, record, event, false)
	}
}

type EventsOrErr struct {
	Events []duo.Event
	Err    string
}

func fetch_activity_for_week(begin_date, end_date string) ([]duo.Observee, map[string]EventsOrErr) {
	duo.DoLogin(duo.DefaultClient)
	students, events := fetch_student_list_and_errors("")
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
	duo.DoLogin(duo.DefaultClient)
	students, events := fetch_student_list_and_errors("")

	for _, student := range students {
		if !strings.EqualFold(nick, student.User_name) {
			continue
		}
		user_id := fmt.Sprintf("%d", student.User_id)
		if events[user_id].Err != "" {
			return student, events[user_id]
		}
		res, err := fetch_activity_for_week_for_id(begin_date, end_date, user_id)
		if err != nil {
			return student, EventsOrErr{Events: res.Events}
		} else {
			return student, EventsOrErr{Err: fmt.Sprint(err)}
		}
	}
	panic("nick not found, does not exist or not leaning en")
}

func fetch_activity_for_week_for_id(begin_date, end_date, user_id string) (res duo.EventsResult, err error) {
	for i := 0; i < 10; i++ {
		res, err = duo.DoEventsGet(duo.DefaultClient, user_id, begin_date, end_date)
		if err != nil {
			continue
		}
		return
	}
	return
}

func fetch_student_list_and_errors(classroom string) ([]duo.Observee, map[string]EventsOrErr) {
	students := make([]duo.Observee, 0)
	events := make(map[string]EventsOrErr)

	dashboard := duo.DoDashboardGet(duo.DefaultClient, classroom)
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
	set := make(map[int]bool)
	for _, r := range records {
		found := false
		for _, s := range students {
			nick := misc.NickFromBlokText(r.Value())
			if strings.EqualFold(nick, s.User_name) {
				set[s.User_id] = true
				found = true
				print_score(r, s, events)
				break
			}
		}
		if !found {
			// student is in block but is not in dashboard, studying en
			log.Printf("student %s je v bloku ale není na duolingu!!!", r.Uco()) //FIXME: write something better
		}
	}
	for _, s := range students {
		if _, ok := set[s.User_id]; ok {
			continue
		}
		uco := misc.UcoFromMuniMail(s.Email)
		if s.Section == "Jaro2016" {
			if uco != "" {
				r := bloky.Record{R: make([]string, 9)}
				r.R[6] = fmt.Sprintf("%s/%s", uco, strings.SplitN(records[0].Id(), "/", 2)[1])
				//for _, r := range records {
				//	if r.Uco() == uco {
				set[s.User_id] = true
				print_score(r, s, events)
				//		break
				//	}
				//}
			} else {
				log.Printf("student %s je na duolingu ale není v bloku!!!", s.User_name) //FIXME: write something better
			}
		}
	}
}

func print_score(r bloky.Record, s duo.Observee, events map[string]EventsOrErr) {
	user_id := fmt.Sprintf("%d", s.User_id)
	var b bytes.Buffer
	print_scores_student(&b, r, events[user_id], false)
	if b.Len() > 4000 {
		b.Reset()
		print_scores_student(&b, r, events[user_id], true)
	}
	fmt.Printf(b.String())
}

type blokWriter struct {
	w io.Writer
}

func (w *blokWriter) Write(buf []byte) (n int, err error) {
	nbuf := bytes.Replace(buf, []byte("\n"), []byte("\n|"), -1)
	return w.w.Write(nbuf)
}

func print_scores_student(w io.Writer, student bloky.Record, eventsOrErr EventsOrErr, brief bool) {
	bw := &blokWriter{w: w}
	printBlokRecordHeader(bw, student.Id())
	printBlokRecordContent(bw, eventsOrErr, brief)
	fmt.Fprintf(w, "\n")
}

func printBlokRecordHeader(w io.Writer, id string) {
	fmt.Fprintf(w, "\t\t\t\t\t\t%s\t", id)
}

func printBlokRecordContent(w io.Writer, eventsOrErr EventsOrErr, brief bool) {
	if eventsOrErr.Err == "" {
		events := eventsOrErr.Events

		s := duo.CalculatePoints(events)

		fmt.Fprintf(w, "Lessons:   %3d ... %4d points\n", s.Nlessons, s.Plessons)
		fmt.Fprintf(w, "Practices: %3d ... %4d points\n", s.Npractices, s.Ppractices)
		fmt.Fprintf(w, "Total: *%d points (calculated as min( min(Lessons,Practices), 70))\n", s.Ptotal)
		fmt.Fprintf(w, "\n")
		fmt.Fprintf(w, "      Lesson                  Activity type     Points\n")
		fmt.Fprintf(w, "----------------------------------------------------------\n")
		if len(events) == 0 || brief {
			fmt.Fprintf(w, "\n")
			if len(events) == 0 {
				fmt.Fprintf(w, "no activities were completed\n")
			} else if brief {
				fmt.Fprintf(w, "a lot of activities were completed\n")
			}
			fmt.Fprintf(w, "\n")
		} else {
			for _, event := range events {
				if !brief {
					fmt.Fprintf(w, "%30s %10s %5d\n", event.Skill_title, event.Type, duo.Score(event))
				}
			}
		}
	} else {
		fmt.Fprintf(w, "\n")
		fmt.Fprintf(w, "asi mate Duolingo prepnute do jineho nez anglickeho kurzu\n")
		fmt.Fprintf(w, "v takovem pripade bohuzel nevidim vase ziskane body\n")
		fmt.Fprintf(w, "\n")
		fmt.Fprintf(w, "%s\n", eventsOrErr.Err)
		fmt.Fprintf(w, "\n")
	}
	fmt.Fprintf(w, "--------------------------------------------------")
}
