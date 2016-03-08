package mailing

import (
	"bytes"
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
	DeadlineCompleted bool
	DeadlinePrintout  string
	DeadlinesMissed   int
}

func SendProgressReport(s Service, r ReminderData) {
	m := s.NewMessage()
	m.AddTo(mail.Address{Name: r.FullName, Address: r.Email})
	m.SetFrom(mail.Address{Name: "Angličtina online", Address: "anglictina-online@googlegroups.com"})
	m.SetSubject("Your weekly progress summary in Angličtina online")

	text := renderTextProgressReport(r)
	m.SetText(text)

	s.Send(m)
}

func renderTextProgressReport(r ReminderData) string {
	t := template.Must(template.ParseFiles("progresssummary.txt"))
	var buf bytes.Buffer
	t.Execute(&buf, r)
	return buf.String()
}
