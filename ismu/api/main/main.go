package main

import (
	"github.com/jirkadanek/onlinea/ismu/api/client"
	"github.com/jirkadanek/onlinea/ismu/api/client/operations"
	"github.com/jirkadanek/onlinea/secrets"
	"log"
	"os"
)

func must(err error) {
	if err != nil {
		panic(err)
	}
}

const FAKULTA = "1441"
const KOD = "ONLINE_A"

func main() {
	os.Setenv("DEBUG", "1")

	c := client.NewHTTPClient(nil)
	p := operations.NewGetExportPbBlokAPIOperacePredmetInfoParams()
	p.Fakulta = FAKULTA
	p.Kod = KOD
	p.Klic = secrets.APIKEY
	i, err := c.Operations.GetExportPbBlokAPIOperacePredmetInfo(p)
	must(err)
	if *i.Payload.KODPREDMETU != "ONLINE_A" {
		log.Fatal("KODPREDMETU", i.Payload.KODPREDMETU)
	}
}
