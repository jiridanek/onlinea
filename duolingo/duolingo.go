package duo

import (
	"encoding/json"
	"fmt"
	"github.com/jirkadanek/onlinea/secrets"
	"io/ioutil"
	"log"
	"net/http"
	"net/http/cookiejar"
	"net/url"
	"sync"
	"time"
)

var (
	First  = time.Date(2016, time.February, 22, 23, 0, 0, 0, time.UTC) // first day of the semester
	Format = "2006-01-02"
)

type session struct {
	mu       sync.Mutex
	deadline time.Time
	isSet    bool
	Jar      http.CookieJar // has own mutex and can be accessed regardless of mu
}

var jar, _ = cookiejar.New(nil)
var DefaultClient = &http.Client{Jar: jar}

// Session is a per-server store for Duolingo session data
var Session = session{isSet: false, Jar: jar}

func printResponse(res *http.Response) {
	t, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal(err)
	}
	panic(fmt.Sprintf("%s", t))
	fmt.Printf("%s", t)
	fmt.Println(res.Status)
}

// Do not ever use DoLogin when using this function
func DoLoginIfNecessary(client *http.Client) *LoginResult {
	Session.mu.Lock()
	defer Session.mu.Unlock()
	if !Session.isSet || time.Now().After(Session.deadline) {
		Session.isSet = false
		loginResult := DoLogin(client)
		return &loginResult
	}
	return nil
}

func DoLogin(client *http.Client) LoginResult {
	auth := map[string]string{
		"came_from": "",
		"login":     secrets.DuolingoLogin,
		"password":  secrets.DuolingoPassword,
		"":          "Sign in",
	}

	data := url.Values{}
	for k, v := range auth {
		data.Set(k, v)
	}
	res, err := client.PostForm("https://www.duolingo.com/login", data)
	if err != nil {
		log.Fatal(err)
	}

	dec := json.NewDecoder(res.Body)
	defer res.Body.Close()
	var result LoginResult
	err = dec.Decode(&result)
	if err != nil {
		log.Fatal(err)
	}

	updateDeadline(res.Cookies())

	return result
}

func updateDeadline(cookies []*http.Cookie) {
	var deadline time.Time
	for _, cookie := range cookies {
		if cookie.Name == "auth_tkt" {
			deadline = cookie.Expires
			break
		}
	}
	if !deadline.IsZero() {
		deadline = deadline.AddDate(0, 0, -1)
	}
	Session.isSet = true
	Session.deadline = deadline
}

var host = "https://dashboard.duolingo.com"

func DoEventsGet(client *http.Client, student_id, begin_date, end_date string) (EventsResult, error) {
	var result EventsResult

	addr := host + "/api/1/observers/detailed_events"
	params := map[string]string{
		"student_id":        student_id,
		"ui_language":       "en",
		"learning_language": "en",
		"from_language":     "cs",
		"begin_date":        begin_date,
		"end_date":          end_date,
	}
	data := url.Values{}
	for k, v := range params {
		data.Add(k, v)
	}
	res, err := client.Get(addr + "?" + data.Encode())
	if err != nil {
		//log.Print(err)
		return result, err
	}

	//printResponse(res)
	dec := json.NewDecoder(res.Body)
	defer res.Body.Close()
	err = dec.Decode(&result)
	if err != nil {
		return result, err
	}
	return result, nil
}

func DoDashboardGet(client *http.Client) DashboardResult {
	addr := host + "/api/1/observers/progress_dashboard"
	res, err := client.Get(addr)
	if err != nil {
		log.Panic(err)
	}

	//    printResponse(res)

	dec := json.NewDecoder(res.Body)
	defer res.Body.Close()
	var students DashboardResult
	err = dec.Decode(&students)
	if err != nil {
		log.Panic(err)
	}
	return students
}

func Score(event Event) int {
	switch event.Type {
	case "lesson":
		return 10
	case "test":
		return 10
	case "practice":
		if event.Skill_title == "" {
			return 10
		}
		return 0
	default:
		return 0
	}
}
