package mailing

import (
	"github.com/jirkadanek/onlinea/secrets"
	"log"
	"net/mail"
	"testing"
)

func TestInterfaces(t *testing.T) {
	var s Service = NewSendGridService("")
	var m Message = s.NewMessage()

	_ = s
	_ = m
}

func sendMail(t *testing.T, s Service, m Message) {
	m.SetFrom(mail.Address{Name: "Angličtina online", Address: "anglictina-online@googlegroups.com"})

	err := s.Send(m)
	if err != nil {
		log.Fatal(err)
	}
}

func TestSendMailTo(t *testing.T) {
	return //FIXME: find better way to enable only when needed
	var s Service = NewSendGridService(secrets.SendGridKey)
	m := s.NewMessage()
	a := mail.Address{Address: "j@dnk.cz"}
	m.AddTo(a)
	m.SetSubject("Testing SendGrid backend")
	m.SetText("Testing, 1, 2, 3.")
	m.SetHtml("Testing, <b>1</b>, 2, 3.")
	sendMail(t, s, m)
}

func TestSendProgressReportTo(t *testing.T) {
	return //FIXME: find better way to enable only when needed
	d := data()
	a := mail.Address{Name: d.FullName, Address: "374368@mail.muni.cz"}
	//a := mail.Address{Name: d.FullName, Address: "tamara.vanova@gmail.com"}
	//a := mail.Address{Name: d.FullName, Address: "janazerzovacz@gmail.com"}
	var s Service = NewSendGridService(secrets.SendGridKey)
	m := s.NewMessage()
	m.AddTo(a)
	m.SetSubject("Your weekly progress summary in Angličtina online")
	m.SetText(RenderTextProgressReport(d))
	m.SetHtml(RenderHtmlProgressReport(d))
	sendMail(t, s, m)
}
