package api

import (
	"github.com/jirkadanek/onlinea/secrets"
	"log"
	"testing"
)

var PARAMS = Parameters{Fakulta: "1441", Kod: "ONLINE_A"}

func must(err error) {
	if err != nil {
		panic(err)
	}
}

//func TestGoSwagger (t *testing.T) {
//	c := client.NewHTTPClient(nil)
//	p := operations.GetPbBlokAPIOperacePredmetInfoParams{Fakulta: FAKULTA, Kod: KOD, Klic: secrets.APIKEY}
//	i, err := c.Operations.GetPbBlokAPIOperacePredmetInfo(&p)
//	must(err)
//	if *i.Payload.KODPREDMETU != "ONLINE_A" {
//		t.Error("KODPREDMETU", i.Payload.KODPREDMETU)
//	}
//}

func TestGetStudents(t *testing.T) {
	c := NewClient(secrets.APIKEY, nil)
	ss, err := c.GetCourseStudents(PARAMS, Default)
	if err != nil {
		panic(err)
	}
	if len(ss) < 100 {
		log.Printf("%+v", ss)
		t.Errorf("Too few active students in result")
	}
}

func TestGetNotebook(t *testing.T) {
	c := NewClient(secrets.APIKEY, nil)
	ss, err := c.GetNotebook(PARAMS, "asumatotal", []string{})
	if err != nil {
		panic(err)
	}
	if len(ss) < 100 {
		log.Printf("%+v", ss)
		t.Errorf("Too few records in result")
	}
}

func TestGetNotebookList(t *testing.T) {
	c := NewClient(secrets.APIKEY, nil)
	ss, err := c.GetNotebookList(PARAMS)
	if err != nil {
		panic(err)
	}
	if len(ss) < 100 {
		log.Printf("%+v", ss)
		t.Errorf("Too few records in result")
	}
}
