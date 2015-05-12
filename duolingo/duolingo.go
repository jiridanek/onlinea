package duo

import (
     "encoding/json"
//     "strings"
    "net/http"
    "net/http/cookiejar"
    "net/url"
    "fmt"
    "log"
    "io/ioutil"
    "github.com/jirkadanek/onlinea/secrets"
)

// cookieJar is a global, per-server store for Duolingo session cookie
//FIXME: timeout?
var cookieJar,_ = cookiejar.New(nil)
var client = &http.Client {
        Jar: cookieJar,
     }

func printResponse(res *http.Response) {
    t, err := ioutil.ReadAll(res.Body)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%s", t)
    fmt.Println(res.Status)
}

func DoLogin() LoginResult {
     auth := map[string]string{
         "came_from": "",
         "login": secrets.DuolingoLogin,
         "password": secrets.DuolingoPassword,
         "": "Sign in",
    }
         
    data := url.Values{}
    for k,v := range auth {
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

func DoEventsGet(student_id, week string) (EventsResult, error) {
    var result EventsResult
    
    addr := host + "/api/1/observers/detailed_events"
    params := map[string]string {
        "student_id": student_id,
        "ui_language": "en",
        "learning_language": "en",
        "from_language": "cs",
        "week": week,
    }
    data := url.Values{}
    for k, v := range params {
        data.Add(k, v)
    }
    res, err := client.Get(addr + "?" + data.Encode())
    if err != nil {
        log.Print(err)
        return result, err
    }

    //printResponse(res)
    dec := json.NewDecoder(res.Body)
    defer res.Body.Close()
    err = dec.Decode(&result)
    if err != nil {
        log.Panic(err)
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