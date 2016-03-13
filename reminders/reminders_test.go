package reminders

import (
	"github.com/jirkadanek/onlinea/ismu/api"
	"github.com/stretchr/testify/assert"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"strings"
	"testing"
)

type requestResponse struct {
	Request  *http.Request
	Response *http.Response
}

type requestResponses []requestResponse

func (rr *requestResponses) addRequestResponse(query string, body string) {
	request, err := http.NewRequest("GET", "https://is.muni.cz/export/pb_blok_api?"+query, nil)
	must(err)
	response := &http.Response{StatusCode: http.StatusOK, Body: ioutil.NopCloser(strings.NewReader(body))}
	*rr = append(*rr, requestResponse{request, response})
}

type mockRoundtripper struct {
	t                *testing.T
	stage            *int
	RequestResponses requestResponses
}

func (r mockRoundtripper) RoundTrip(req *http.Request) (*http.Response, error) {
	stage := *r.stage
	*r.stage++
	if stage >= len(r.RequestResponses) {
		r.t.Fatalf("Too many requests, expected %v", len(r.RequestResponses))
	}
	requestResponse := r.RequestResponses[stage]

	checkRequest(r.t, req, requestResponse.Request)
	response := requestResponse.Response
	return response, nil
}

func checkRequest(t *testing.T, expected, actual *http.Request) {
	assert.Equal(t, expected.URL.String(), actual.URL.String())
}

func TestGetNotebooks(t *testing.T) {
	r := mockRoundtripper{t: t, stage: new(int)}
	for _, v := range [][]string{
		{"fakulta=myfakulta&klic=mykey&kod=mykod&operace=predmet-seznam&zareg=a",
			`<PREDMET_STUDENTI_INFO><STUDENT><CELE_JMENO>Mgr. Ondrej Šebela</CELE_JMENO><UCO>172888</UCO></STUDENT></PREDMET_STUDENTI_INFO>`},
		{"fakulta=myfakulta&klic=mykey&kod=mykod&operace=bloky-seznam", `<POZN_BLOKY_INFO><POZN_BLOK><ZKRATKA>notebook</ZKRATKA></POZN_BLOK></POZN_BLOKY_INFO>`},
		{"fakulta=myfakulta&klic=mykey&kod=mykod&operace=blok-dej-obsah&zkratka=notebook", `<BLOKY_OBSAH> <STUDENT> <OBSAH>*25 bodů</OBSAH> <UCO>172888</UCO> </STUDENT> </BLOKY_OBSAH>`},
	} {
		r.RequestResponses.addRequestResponse(v[0], v[1])
	}
	httpclient := &http.Client{Transport: r}
	apiclient := api.NewClient("mykey", httpclient)
	p := api.Parameters{Fakulta: "myfakulta", Kod: "mykod"}

	wpr := NewWeeklyProgressReminders(apiclient, p)
	reminders := wpr.Perform("Deadline Assignment 1", 1, "March 15, 2016", "test.bc")
	if wpr.Failed() {
		panic(wpr.Err)
	}
	assert.Equal(t, 1, len(reminders))
	log.Printf("%+v", reminders)
}

func TestPoints(t *testing.T) {
	for _, v := range [][]string{
		{"", "0"},
		{"42", "0"},
		{"*1", "1"},
		{"*1 *1", "2"},
		{"*1, *-2", "-1"},
		{"*1.1", "1.1"},
		{"*1,1", "1.1"},
		{"*1,1 *1.1 *-1,1 *-1.1 42", "0"},
	} {
		e, _ := strconv.ParseFloat(v[1], 64)
		if e != points(v[0]) {
			t.Errorf("Blok: %v, expected: %v, actual: %v\n", v[0], v[1], e)
		}
	}
}

func TestHasPoints(t *testing.T) {
	for _, v := range [][]string{
		{"", "false"},
		{"*", "false"},
		{"*a", "false"},
		{"*3", "true"},
		{"*3.3", "true"},
		{"*3,3", "true"},
		{"*0", "true"},
	} {
		var e bool
		switch v[1] {
		case "true":
			e = true
		case "false":
			e = false
		default:
			t.Fatalf("Wrong expected value: %v", v[1])
		}

		actual := hasPoints(v[0])
		if e != actual {
			t.Errorf("String %v, expected %v, actual %v", v[0], v[1], actual)
		}
	}
}

func TestFetchData(t *testing.T) {
	d := FetchNotebookDataFromIS()
	log.Printf("%+v", d)
}

func must(err error) {
	if err != nil {
		panic(err)
	}
}
