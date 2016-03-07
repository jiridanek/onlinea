package api

import (
	"encoding/xml"
	"errors"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"strings"
)

type flag int

const (
	Default        = 0
	Zaregistrovani = flag(1) << iota
	Neaktivni
	UkonceneStudium
)

type client struct {
	Client *http.Client
	Klic   string // ApiKey
}

var ResponseError = errors.New("Server responded with code != 200")

func NewClient(apikey string, altclient *http.Client) *client {
	if altclient == nil {
		altclient = http.DefaultClient
	}
	return &client{Client: altclient, Klic: apikey}
}

func (c client) get(params url.Values) (response *http.Response, err error) {
	params.Add("klic", c.Klic)
	request, err := http.NewRequest("GET", "https://is.muni.cz/export/pb_blok_api", nil)
	if err != nil {
		return nil, err
	}
	request.URL.RawQuery = params.Encode()
	response, err = c.Client.Do(request)
	if err != nil {
		return
	}
	if response.StatusCode != http.StatusOK {
		err = ResponseError
	}
	return
}

// operace=predmet-seznam
func (c client) GetCourseStudents(p Parameters, f flag) (result []CourseStudent, err error) {
	operace := "predmet-seznam"
	params := p.Values()
	if f&Zaregistrovani != 0 {
		params.Add("zareg", "a")
	}
	if f&Neaktivni != 0 {
		params.Add("vcneaktiv", "a")
	}
	if f&UkonceneStudium != 0 {
		params.Add("vcukonc", "a")
	}
	params.Add("operace", operace)

	resp, err := c.get(params)
	if err != nil {
		return
	}

	var students struct {
		Error    string          `xml:",chardata"`
		Students []CourseStudent `xml:"STUDENT"`
	}

	defer resp.Body.Close()
	//debug(resp.Body)

	dec := xml.NewDecoder(resp.Body)
	err = dec.Decode(&students)
	if err != nil {
		return
	}
	msg := strings.TrimSpace(students.Error)
	if msg != "" {
		err = errors.New(msg)
	}
	result = students.Students
	return
}

// operace=blok-dej-obsah
func (c client) GetNotebook(p Parameters, nb string, us []string) (result []Notebook, err error) {
	operace := "blok-dej-obsah"
	params := p.Values()
	params.Add("zkratka", nb)
	params.Add("operace", operace)
	for _, u := range us {
		params.Add("uco", u)
	}

	resp, err := c.get(params)
	if err != nil {
		return
	}

	var notebooks struct {
		Error     string     `xml:",chardata"`
		Notebooks []Notebook `xml:"STUDENT"`
	}

	defer resp.Body.Close()
	dec := xml.NewDecoder(resp.Body)
	err = dec.Decode(&notebooks)
	if err != nil {
		return
	}
	msg := strings.TrimSpace(notebooks.Error)
	if msg != "" {
		err = errors.New(msg)
	}
	result = notebooks.Notebooks
	return
}

// operace=bloky-seznam
func (c client) GetNotebookList(p Parameters) (result []NotebookInfo, err error) {
	operace := "bloky-seznam"
	params := p.Values()
	params.Add("operace", operace)

	var bloky struct {
		Error     string         `xml:",chardata"`
		Notebooks []NotebookInfo `xml:"POZN_BLOK"`
	}

	response, err := c.get(params)
	if err != nil {
		return
	}

	defer response.Body.Close()
	dec := xml.NewDecoder(response.Body)
	err = dec.Decode(&bloky)
	if err != nil {
		return
	}

	msg := strings.TrimSpace(bloky.Error)
	if msg != "" {
		err = errors.New(msg)
	}
	result = bloky.Notebooks
	return
}

type Parameters struct {
	Fakulta string // Faculty
	Kod     string // Course
}

func (p Parameters) Values() url.Values {
	v := url.Values{}
	v.Add("fakulta", p.Fakulta)
	v.Add("kod", p.Kod)
	return v
}

func debug(r io.Reader) {
	text, err := ioutil.ReadAll(r)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("%s", text)
}
