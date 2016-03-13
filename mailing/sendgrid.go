package mailing

import (
	"errors"
	"github.com/sendgrid/sendgrid-go"
	"net/mail"
)

type sendGridService struct {
	*sendgrid.SGClient
}

func NewSendGridService(apikey string) Service {
	sg := sendgrid.NewSendGridClientWithApiKey(apikey)
	return &sendGridService{sg}
}

func (s sendGridService) NewMessage() Message {
	return NewSendGridMessage()
}

func (s sendGridService) Send(m Message) error {
	switch m := m.(type) {
	case *sendGridMessage:
		return s.SGClient.Send(m.SGMail)
	default:
		return errors.New("Message must be a sendGridMessage")

	}
	return nil
}

type sendGridMessage struct {
	*sendgrid.SGMail
}

func NewSendGridMessage() Message {
	m := sendgrid.NewMail()
	m.SetASMGroupID(521) //TODO(jirka): make a parameter when n > 1
	return &sendGridMessage{m}
}

func (m *sendGridMessage) SetFrom(a mail.Address) {
	m.SGMail.SetFromEmail(&a)
}

func (m *sendGridMessage) AddTo(a mail.Address) {
	m.SGMail.AddRecipient(&a)
}

func (m *sendGridMessage) AddBcc(a mail.Address) {
	m.SGMail.AddBccRecipient(&a)
}

func (m *sendGridMessage) SetSubject(s string) {
	m.SGMail.SetSubject(s)
}

func (m *sendGridMessage) SetText(text string) {
	m.SGMail.SetText(text)
}

func (m *sendGridMessage) SetHtml(html string) {
	m.SGMail.SetHTML(html)
}
