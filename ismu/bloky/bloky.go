package bloky

import (
	"encoding/csv"
	"io"
)

type Reader struct {
	*csv.Reader
}

type Record struct {
	R []string
}

func (r Record) Uco() string { // UČO studenta.
	return r.R[0]
}
func (r Record) Jmeno() string { // Příjmení a jméno studenta.
	return r.R[1]
}

//     Zkratky_oboru string // Zkratka oboru nebo aktivně studovaných oborů.
//     Kod_predmetu string // Kód předmětu.
//     Priznaky string // Příznaky: 'opak' a 'znovu' pro opakování předmětu, 'isp' pro individuální studijní plán.
//     Ukonceni string // Zapsané ukončení předmětu.
func (r Record) Id() string { // Identifikátor pro informační systém - neměnit!
	return r.R[6]
}
func (r Record) Value() string { // Aktuální obsah řádku poznámkového bloku.
	return r.R[7]
}

func NewReader(fp io.Reader) Reader {
	reader := csv.NewReader(fp)
	reader.Comma = ';'
	reader.FieldsPerRecord = 8
	return Reader{reader}
}

func (reader *Reader) Read() (record Record, err error) {
	r, err := reader.Reader.Read()
	record = Record{r}
	return
}

func (reader *Reader) ReadAll() (rs []Record, err error) {
	rs = make([]Record, 0)
	for {
		r, err := reader.Read()
		if err != nil {
			break
		}
		rs = append(rs, r)
	}
	return
}
