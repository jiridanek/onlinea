package mailing

import (
	"bytes"
	"crypto/tls"
	"crypto/x509"
	"github.com/jaytaylor/html2text"
	"github.com/jirkadanek/onlinea/secrets"
	"gopkg.in/gomail.v2"
	"html/template"
	"io/ioutil"
	"log"
	"time"
)

// https://is.muni.cz/help/komunikace/mail
// https://pki.cesnet.cz/en/ch-tcs-ssl-ca-3-crt-crl.html
// openssl s_client -connect mail.muni.cz:465 -CAfile TERENA_SSL_CA_3.pem

type DuolingoFailure struct {
	Email       string
	Click, Post bool
}

func DuolingoDokonceteRegistraci(descs []DuolingoFailure) []*gomail.Message {
	ms := make([]*gomail.Message, len(descs))
	for i, desc := range descs {
		m := NewMessage(desc.Email)
		DuolingoMessageBody(m, desc)
		ms[i] = m
	}
	return ms
}

func NewMessage(to string) *gomail.Message {
	m := gomail.NewMessage()

	m.SetHeader("To", to)
	m.SetHeader("Bcc", "j@dnk.cz")
	m.SetAddressHeader("From", "dnk@mail.muni.cz", "Angličtina online")
	m.SetAddressHeader("Sender", "dnk@mail.muni.cz", "Jiří Daněk")
	m.SetAddressHeader("Reply-To", "anglictina-online@googlegroups.com", "Angličtina online")

	return m
}

var duolingoTemplate = template.Must(template.ParseFiles("/home/jirka/onlinea/src/github.com/jirkadanek/onlinea/mailing/duolingoregistrace.html"))

func DuolingoMessageBody(m *gomail.Message, d DuolingoFailure) {
	m.SetHeader("Subject", "[ACTION REQUIRED] Dokončete svoji registraci do aktivity Duolingo.com")

	var buffer bytes.Buffer
	duolingoTemplate.Execute(&buffer, d)
	html := buffer.String()
	text, err := html2text.FromString(html)
	if err != nil {
		panic(err)
	}

	m.SetBody("text/plain", text)
	m.AddAlternative("text/html", html)
}

// func WeeklyProgress(m gomail.Message, d) {
//     m.SetHeader("Subject", "Your weekly progress summary in Angličtina online")
//     m.SetBody("text/plain", "Hello Bob and Cora!")
//     m.AddAlternative("text/html", "Hello <b>Bob</b> and <i>Cora</i>!")
//     //m.Attach("/home/Alex/lolcat.jpg")
// }

func SendMessages(m ...*gomail.Message) {
	pem, err := ioutil.ReadFile("TERENA_SSL_CA_3.pem")
	if err != nil {
		log.Fatal(err)
	}
	pool := x509.NewCertPool()
	if ok := pool.AppendCertsFromPEM(pem); !ok {
		log.Fatal("appending cert failed")
	}

	d := gomail.NewPlainDialer("mail.muni.cz", 465, secrets.NICKNAME, secrets.SECONDARYPASSWORD)
	d.TLSConfig = &tls.Config{RootCAs: pool, ServerName: "mail.muni.cz"}

	// retry until success
	i := 0
	t := 3 * time.Second
	for i < len(m) {
		c, err := d.Dial()
		if err != nil {
			log.Println("muni.go SendMessages A", err)
			goto sleep
		}
		for i < len(m) {
			err = gomail.Send(c, m[i])
			if err != nil {
				log.Println("muni.go SendMessages B", err)
				goto sleep
			}
			log.Println("muni.go SeendMessages C", "sent mail no.", i)
			i++
			t = 3 * time.Second
		}
	sleep:
		time.Sleep(t)
		t *= 3
	}

}
