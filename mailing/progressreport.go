package mailing

import (
	"bytes"
	"log"
	"net/mail"
	"text/template"
)

type ReminderData struct {
	Email             string
	FullName          string
	Total             float64
	Discussion        float64
	DeadlineName      string
	DeadlineNumber    int
	DeadlineDate      string
	DeadlineCompleted bool
	DeadlinePrintout  string
	DeadlinesMissed   int
}

func SendProgressReport(s Service, r ReminderData) {
	m := s.NewMessage()
	m.AddTo(mail.Address{Name: r.FullName, Address: r.Email})
	m.SetFrom(mail.Address{Name: "Angličtina online", Address: "anglictina-online@googlegroups.com"})
	m.SetSubject("Your wieekly progress summary in Angličtina online")

	text := RenderTextProgressReport(r)
	m.SetText(text)

	s.Send(m)
}

func RenderTextProgressReport(r ReminderData) string {
	t := template.Must(template.ParseFiles("progresssummary.txt"))
	return renderProgressReport(t, r)
}

func RenderHtmlProgressReport(r ReminderData) string {
	t := template.Must(template.ParseFiles("progresssummary.html"))
	return renderProgressReport(t, r)
}

func renderProgressReport(t *template.Template, r ReminderData) string {
	var buf bytes.Buffer
	err := t.Execute(&buf, r)
	if err != nil {
		log.Fatal(err)
	}
	return buf.String()
}
