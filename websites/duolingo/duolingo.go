package hello

import (
	"bytes"
	"fmt"
	"github.com/jirkadanek/onlinea/duolingo"
	"google.golang.org/appengine"
	"google.golang.org/appengine/log"
	"google.golang.org/appengine/urlfetch"
	"google.golang.org/appengine/user"
	"html/template"
	"io"
	"net/http"
	"time"
)

func duoTime() time.Time {
	location, err := time.LoadLocation("America/New_York")
	if err != nil {
		panic(err)
	}
	return time.Now().In(location)
}

func weekDateString(t time.Time) (int, string, string) {
	start_date := duo.First

	i := 0
	next := start_date
	for next.Before(t) {
		i++
		start_date = next
		next = next.AddDate(0, 0, 7)
	}

	end_date := start_date.AddDate(0, 0, 6)

	return i, start_date.Format(duo.Format), end_date.Format(duo.Format)
}

func showDuolingoActivity(uco string, w http.ResponseWriter, r *http.Request) {
	c := appengine.NewContext(r)

	students, err := dbGetStudents(c)
	if err != nil {
		http.Error(w, fmt.Sprintf("Cannot load list of students: %v", err.Error()), 500)
		return
	}

	if user.IsAdmin(c) {
		//fake uco, for testing
		uco = r.URL.Query().Get("uco")
	}

	var student Student
	for _, s := range students {
		if s.Uco == uco {
			student = s
		}
	}

	var buf bytes.Buffer
	var report Report
	var student_id string

	now := duoTime()
	week, begin_date, end_date := weekDateString(now)

	report.Tyden = fmt.Sprintf("%d (od %s do %s včetně), v New Yorku je nyní %v", week, begin_date, end_date, now)

	if student.Uco == "" || student.Nick == "" {
		report.Err = "Vaše přezdívka na Duolingo není v seznamu.<br>Pokud studujete ONLINE_A, napište mi vaši přezdívku do vlákna v diskusi a já vás do seznamu přidám."
		render(w, report)
		return
	}
	if student.Id == "" {
		report.Err = "Nepodařilo se načíst váš profil na Duolingu.<br>Klikli jste na odkaz v Úvodních instrukcích?"
		render(w, report)
		return
	}

	student_id = student.Id

	client := urlfetch.Client(c)
	client.Jar = duo.Session.Jar
	if duo.DoLoginIfNecessary(client) != nil {
		log.Infof(c, "Logging into Duolingo")
	}
	events, err := duo.DoEventsGet(client, student_id, begin_date, end_date)
	if err != nil {
		log.Errorf(c, "Fetching Duolingo events (student_id: %s, week: %d)failed: %v", student_id, week, err)
		report.Err = template.HTML(fmt.Sprintf("Načtení aktivit za týden %d selhalo.<br>Asi mate Duolingo prepnute do jineho nez anglickeho"+
			" kurzu.<br>V takovem pripade bohuzel nevidim vase ziskane body:<br><br>%s", week, template.HTMLEscaper(err)))
		render(w, report)
		return
	}

	report.Uco = student.Uco
	report.Nick = student.Nick

	print_scores_student(&buf, events.Events)
	report.Tabulka = buf.String()

	render(w, report)
}

func render(w io.Writer, report Report) {
	tmpl.Execute(w, report)
}

func print_scores_student(w io.Writer, events []duo.Event) {
	s := duo.CalculatePoints(events)

	fmt.Fprintf(w, "Lessons:   %3d ... %4d points\n", s.Nlessons, s.Plessons)
	fmt.Fprintf(w, "Practices: %3d ... %4d points\n", s.Npractices, s.Ppractices)
	fmt.Fprintf(w, "Total: *%d points (calculated as min( min(Lessons,Practices), 70))\n", s.Ptotal)
	fmt.Fprintf(w, "\n")
	fmt.Fprintf(w, "      Lesson                  Activity type     Points\n")
	fmt.Fprintf(w, "----------------------------------------------------------\n")
	fmt.Fprintf(w, "\n")
	if len(events) == 0 {
		fmt.Fprintf(w, "no activities were completed\n")
		fmt.Fprintf(w, "\n")
	} else {
		for _, event := range events {
			fmt.Fprintf(w, "%30s %10s %5d\n", event.Skill_title, event.Type, duo.Score(event))
		}
	}
	fmt.Fprintf(w, "--------------------------------------------------\n")
}
