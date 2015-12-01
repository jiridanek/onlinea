package duo

import (
	"encoding/json"
	//     "strings"
	"fmt"
	"github.com/jirkadanek/onlinea/secrets"
	"io/ioutil"
	"log"
	"net/http"
	"net/http/cookiejar"
	"net/url"
	"time"
)

var (
	First  = time.Date(2015, time.September, 21, 23, 0, 0, 0, time.UTC) // first day of the semester
	Format = "2006-01-02"
)

// cookieJar is a global, per-server store for Duolingo session cookie
//FIXME: timeout?
var cookieJar, _ = cookiejar.New(nil)
var client = &http.Client{
	Jar: cookieJar,
}

func InjectClient(c *http.Client) {
	client = c
}

func printResponse(res *http.Response) {
	t, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal(err)
	}
	panic(fmt.Sprintf("%s", t))
	fmt.Printf("%s", t)
	fmt.Println(res.Status)
}

func DoLogin() LoginResult {
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

	return result

	// robots, err := ioutil.ReadAll(res.Body)
	// 	res.Body.Close()
	// 	if err != nil {
	// 		log.Fatal(err)
	// 	}
	// 	fmt.Printf("%s", robots)

	//     d := json.NewDecoder(res.Body)
	//     var result LoginResult
	//     err = d.Decode(&result)
	//     if err != nil {
	//         log.Fatal(err)
	//     }
	//     log.Println(res.Status)
	//     log.Printf("%v %v %v", result.response, result.username, result.user_id)
	// }
}

var host = "https://dashboard.duolingo.com"

func DoEventsGet(student_id, begin_date, end_date string) (EventsResult, error) {
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

func DoDashboardGet() DashboardResult {
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
			return 15
		}
		return 0
	default:
		return 0
	}
}
