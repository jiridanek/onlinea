package main

import (
	"flag"
	"fmt"
	"github.com/jirkadanek/onlinea/mailing"
	"github.com/jirkadanek/onlinea/reminders"
	"github.com/jirkadanek/onlinea/secrets"
	"log"
	"net/http"
	"net/mail"
	"time"
)

var live = flag.Bool("live", false, "If set, it will actually send the mail")

func send(s mailing.Service, d mailing.ReminderData) {
	sundayBeforeDeadline := true // FIXME: parameterize this
	prefix := ""
	if !d.DeadlineCompleted && sundayBeforeDeadline {
		prefix = "[ACTION REQUIRED] "
	}
	m := s.NewMessage()
	m.SetSubject(prefix + "Your weekly progress update in Angličtina online")
	m.AddTo(mail.Address{Name: d.FullName, Address: d.Email})
	m.SetFrom(mail.Address{Name: "Angličtina online", Address: "anglictina-online@googlegroups.com"})
	m.SetText(mailing.RenderTextProgressReport(d))
	m.SetHtml(mailing.RenderHtmlProgressReport(d))

	// retry three times
	var err error
	for i := 0; i < 3; i++ {
		err = s.Send(m)
		if err != nil {
			log.Println(err)
			continue
		}
		break
	}
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	flag.Parse()

	http.DefaultTransport.(*http.Transport).ResponseHeaderTimeout = time.Second * 45

	service := mailing.NewSendGridService(secrets.SendGridKey)
	data := reminders.FetchNotebookDataFromIS()
	for i, datum := range data {
		//datum.Email = "j@dnk.cz"

		// list of students that should not get this mail
		mark := struct{}{}
		skipMap := map[string]struct{}{
			"@mail.muni.cz": mark,
		}
		if _, found := skipMap[datum.Email]; found {
			log.Println("skipping", datum.Email)
			continue
		}

		if *live {
			send(service, datum)
			fmt.Println("datum.Email:", datum.Email) // so that I can manually recover if the thing somehow fails
		}
		log.Println(i, mailing.RenderTextProgressReport(datum))
		log.Println(i, mailing.RenderHtmlProgressReport(datum))
		//break;
	}
}
