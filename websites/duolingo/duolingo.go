package hello

import (
	"bytes"
	"fmt"
	"github.com/jirkadanek/onlinea/duolingo"
	"google.golang.org/appengine"
	"google.golang.org/appengine/log"
	"google.golang.org/appengine/urlfetch"
	"google.golang.org/appengine/user"
	"io"
	"net/http"
	"net/http/cookiejar"
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
	i := 1

	start_date := duo.First

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
		report.Err = "Vaše přezdívka na Duolingo není v seznamu. Pokud studujete ONLINE_A, napište mi vaši přezdívku do vlákna v diskusi a já vás do seznamu přidám."
		render(w, report)
		return
	}
	if student.Id == "" {
		report.Err = "Nepodařilo se načíst váš profil na Duolingu. Klikli jste na odkaz v Úvodních instrukcích?"
		render(w, report)
		return
	}

	student_id = student.Id

	cookieJar, _ := cookiejar.New(nil)
	client := urlfetch.Client(c)
	client.Jar = cookieJar
	duo.InjectClient(client)

	duo.DoLogin()
	events, err := duo.DoEventsGet(student_id, begin_date, end_date)
	if err != nil {
		log.Errorf(c, "Fetching Duolingo events (student_id: %s, week: %d)failed: %v", student_id, week, err)
		report.Err = fmt.Sprintf("Načtení aktivit za týden %s selhalo\nasi mate Duolingo prepnute do jineho nez anglickeho"+
			"kurzu\nv takovem pripade bohuzel nevidim vase ziskane body:\n\n%v", week, err)
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

func print_scores_student(w io.Writer, events []duo.Event) {
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
	fmt.Fprintf(w, "Practices: %3d ... %4d points\n", npractices, ppractices)
	fmt.Fprintf(w, "Total: *%d points (calculated as min( min(Lessons,Practices), 70))\n", ptotal)
	fmt.Fprintf(w, "\n")
	fmt.Fprintf(w, "      Lesson                  Activity type     Points\n")
	fmt.Fprintf(w, "----------------------------------------------------------\n")
	fmt.Fprintf(w, "\n")
	if len(events) == 0 {
		fmt.Fprintf(w, "no activities were completed\n")
		fmt.Fprintf(w, "\n")
	} else {
		for _, event := range events {
			fmt.Fprintf(w, "%30s %10s %5d\n", event.Skill_title, event.Type, score(event))
		}
	}
	fmt.Fprintf(w, "--------------------------------------------------\n")
}
