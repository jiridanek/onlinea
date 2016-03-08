package mailing

import (
	"testing"
)

func TestInterfaces(t *testing.T) {
	var s Service = NewSendGridService("")
	var m Message = s.NewMessage()

	_ = s
	_ = m
}
