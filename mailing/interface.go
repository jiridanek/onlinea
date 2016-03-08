package mailing

import (
	"net/mail"
)

type Service interface {
	NewMessage() Message
	Send(m Message) error
}

type Message interface {
	SetFrom(mail.Address)
	AddTo(mail.Address)
	AddBcc(mail.Address)
	SetSubject(string)
	SetText(string)
	SetHtml(string)
}
