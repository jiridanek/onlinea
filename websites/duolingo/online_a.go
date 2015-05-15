package hello

import (
    "fmt"
    "golang.org/x/net/context"
    "google.golang.org/appengine/user"
    "google.golang.org/appengine"
    "google.golang.org/appengine/datastore"
     "google.golang.org/appengine/log"
     "google.golang.org/appengine/urlfetch"
// 	// 	"errors"
// 	"github.com/gorilla/context"
    "github.com/gorilla/sessions"
    "github.com/gorilla/mux"
    "golang.org/x/oauth2"
    "golang.org/x/oauth2/google"
    "net/http/cookiejar"
    "io/ioutil"
    "net/http"
    "github.com/jirkadanek/onlinea/secrets"
    "strings"
    "encoding/json"
    "github.com/jirkadanek/onlinea/duolingo"
    "github.com/jirkadanek/onlinea/ismu/bloky"
    "github.com/jirkadanek/onlinea/misc"
//     "runtime"
    "io"
)

var _ = ioutil.ReadAll

var store = sessions.NewCookieStore(secrets.CookieSigningSecret, secrets.CookieEncryptionSecret)
var sessionName = "session"

type Students struct {
    Students []Student
}

type Student struct{
    Uco string `datastore:",noindex"`
    Nick string `datastore:",noindex"`
    Id string `datastore:",noindex"`
}

// https://github.com/google/google-api-go-client/blob/master/plus/v1/plus-gen.go
type Person struct {
	// Domain: The hosted domain name for the user's Google Apps account.
	// For instance, example.com. The plus.profile.emails.read or email
	// scope is needed to get this domain name.
	Domain string `json:"domain,omitempty"`

	// Emails: A list of email addresses that this person has, including
	// their Google account email address, and the public verified email
	// addresses on their Google+ profile. The plus.profile.emails.read
	// scope is needed to retrieve these email addresses, or the email scope
	// can be used to retrieve just the Google account email address.
	Emails []*PersonEmails `json:"emails,omitempty"`

	// Etag: ETag of this response for caching purposes.
	Etag string `json:"etag,omitempty"`
}

type PersonEmails struct {
	// Type: The type of address. Possible values include, but are not
	// limited to, the following values:
	// - "account" - Google account email address.
	// - "home" - Home email address.
	// - "work" - Work email address.
	// - "other" - Other.
	Type string `json:"type,omitempty"`

	// Value: The email address.
	Value string `json:"value,omitempty"`
}

var oauthconf = &oauth2.Config{
		ClientID:     secrets.OAuthClientID,
		ClientSecret: secrets.OAuthClientSecret,
		RedirectURL:  "http://localhost:8080/oauth2callback",
		Scopes: []string{
                    "email",
		},
		Endpoint: google.Endpoint,
	}
	
func init() {
    // go gorilla!
    router := mux.NewRouter()
    
	router.HandleFunc("/googlelogin", func(w http.ResponseWriter, r *http.Request) {
		//FIXME: for now ignore CRSS token as the site is read-only
		url := oauthconf.AuthCodeURL("state", oauth2.SetAuthURLParam("hd", "mail.muni.cz"), oauth2.AccessTypeOnline)
		http.Redirect(w, r, url, http.StatusFound) // FIXME: Found?
	})
	router.HandleFunc("/logout", func(w http.ResponseWriter, r *http.Request) {
		session, _ := store.Get(r, sessionName)
		session.Values["uco"] = ""
		session.Save(r, w)
	})
	router.HandleFunc("/oauth2callback", func(w http.ResponseWriter, r *http.Request) {
		c := appengine.NewContext(r)
		authcode := r.FormValue("code")
		token, err := oauthconf.Exchange(c, authcode)
		if err != nil {
                    log.Errorf(c, "Exchanging toke failed: %v", err)
                    loginFailed(w, r)
                    return
		}
		
		// https://github.com/google/google-api-go-client/blob/master/examples/main.go
		gclient := oauthconf.Client(c, token)

// 		fmt.Fprintf(w, "token is %v", token)
		response, err := gclient.Get("https://www.googleapis.com/plus/v1/people/me?fields=emails%2Cdomain")
		if err != nil {
                    log.Errorf(c, "Fetching account deatils failed: %v", err)
                    loginFailed(w, r)
                    return
		}
		defer response.Body.Close()
                dec := json.NewDecoder(response.Body)
                var p Person
                err = dec.Decode(&p)
                if err != nil {
                    log.Errorf(c, "Decoding account details failed: %v", err)
                    loginFailed(w, r)
                    return
		}
		uco := ucoFromPerson(p)
                
//               fmt.Fprintf(w, "%s", uco)
// 		contents, err := ioutil.ReadAll(response.Body)
// 		fmt.Fprintf(w, "%s", string(contents))

		session, _ := store.Get(r, sessionName)
		session.Values["uco"] = uco
		session.Save(r, w)
                
                http.Redirect(w, r, "/", http.StatusFound)
	})
        router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
            uco := getSession(w, r)
            if uco == "" {
                http.Redirect(w, r, "/login", http.StatusFound)
                return
            }
            showDuolingoAcrivity(uco, w, r)
            return
        })
        
        router.HandleFunc("/admin/upload/duolingo", func(w http.ResponseWriter, r *http.Request) {
            c := appengine.NewContext(r)
            if !user.IsAdmin(c) {
                http.Error(w, "This page is Admin-only.", http.StatusUnauthorized)
                return
            }
            
            fmt.Fprintf(w, `<html><body><form method="post" enctype="multipart/form-data">
                <input type="file" name="file">
                <input type="submit">
            </form><pre>`)
            
            file, header, err := r.FormFile("file")
            _ = header
            if err == http.ErrMissingFile {
                fmt.Fprintf(w, "no new file submitted\n")
                students, err := dbGetStudents(c)
                if err != nil {
                    fmt.Fprintf(w, "getting students from db failed: %v\n", err)
                    return
                }
                 for _, s := range students {
                    fmt.Fprintf(w, "%+v\n", s)
                }
                return
            }
            if err != nil {
                fmt.Fprintf(w, "getting file failed: %v\n", err)
                return
            }
            
            records, err := readBlok(file)
            if err != nil {
                fmt.Fprintf(w, "reading file failed: %v\n", err)
                return
            }
            
            cookieJar,_ := cookiejar.New(nil)
            client := urlfetch.Client(c)
            client.Jar = cookieJar
            duo.InjectClient(client)
            duo.DoLogin()
            dashboard := duo.DoDashboardGet()
            observees := dashboard.Observees
            
            students := make([]Student, 0)
            
            for _, r := range records {
                nick := misc.NickFromBlokText(r.Value())
                if nick == "" {
                    students = append(students, Student{Uco: r.Uco()})
                    continue
                }
                found := false
                for _, s := range observees {
                    if strings.EqualFold(nick, s.User_name) {
                        found = true
                        id := s.User_id
                        students = append(students, Student{Uco: r.Uco(), Nick: nick, Id: fmt.Sprintf("%d", id)})
                    }
                }
                if !found {
                    fmt.Fprintf(w, "%v, %v was not found in Dashboard\n", r.Uco(), nick)
                }
            }
            
            err = dbPutStudents(c, students)
            if err != nil {
                http.Error(w, fmt.Sprintf("%v", err), 500)
                return
            }
            
           
            
            fmt.Fprintf(w, `<pre></body></html>`)
            
        })
        
        router.HandleFunc("/test", func(w http.ResponseWriter, r *http.Request) {
            c := appengine.NewContext(r)
            s := make([]Student, 0)
            s = append(s, Student{"aa", "bb", "cc"})
            err := dbPutStudents(c, s)
            http.Error(w, fmt.Sprintf("%v", err), http.StatusUnauthorized)
        })
        
        http.Handle("/", router)
}

func readBlok(r io.Reader) ([]bloky.Record, error) {
    reader := bloky.NewReader(r)
    records, err := reader.ReadAll()
    return records, err
}

func loginFailed(w http.ResponseWriter, r *http.Request) {
    http.Error(w, "Log in failed. Click <a href=\"/login\">here</a> to try again.", http.StatusUnauthorized)
}

func dbGetStudents(c context.Context) ([]Student, error) {
    k := datastore.NewKey(c, "DuolingoStudents1", "current", 0, nil)
    var s Students
    err := datastore.Get(c, k, &s)
    return s.Students, err
}

func dbPutStudents(c context.Context, s []Student) error {
    var students Students
    students.Students = s
    k := datastore.NewKey(c, "DuolingoStudents1", "current", 0, nil)
    _, err := datastore.Put(c, k, &students)
    return err
}

func showDuolingoAcrivity(uco string, w http.ResponseWriter, r *http.Request) {
    c := appengine.NewContext(r)
    
    students, err := dbGetStudents(c)
    if err != nil {
        http.Error(w, err.Error(), 500)
        return
    }
    
    var student Student
    for _, s := range students {
        if s.Uco == uco {
            student = s
        }
    }
    
    student = Student{Uco:"393906", Nick:"zufinka", Id:"74513839"}
    
    if student.Uco == "" {
        http.Error(w, "student není v seznamu", 500)
        return
    }
    if student.Nick == "" {
        http.Error(w, "student nemá zadanou přezdívku", 500)
        return
    }
    if student.Id == "" {
        http.Error(w, "nenašli jsme id", 500)
        return
    }
    
    student_id := student.Id
    week := "2015-02-16"
    
    cookieJar,_ := cookiejar.New(nil)
    client := urlfetch.Client(c)
    client.Jar = cookieJar
    duo.InjectClient(client)
    
    duo.DoLogin()
    events, err := duo.DoEventsGet(student_id, week)
    if err != nil {
        log.Errorf(c, "Fetching Duolingo events (student_id: %s, week: %d)failed: %v", student_id, week, err)
        http.Error(w, fmt.Sprintf("Fetching week %d activities for user with Duolingo ID %s failed: %v", week, student_id, err), http.StatusUnauthorized)
        return
    }
    
    fmt.Fprintf(w, "%s %s %s\n", student.Uco, student.Nick, student.Id)
    
    for _, event := range events.Events {
        fmt.Fprintf(w, "%v %v\n", event.Skill_title, event.Type)
    }
}

func ucoFromPerson(p Person) string {
    if p.Domain != "mail.muni.cz" {
        return ""
    }
    for _, email := range p.Emails {
        vs := strings.Split(email.Value, "@")
        muni := vs[1] == "mail.muni.cz"
        numeric := vs[0] != ""
        for _, c := range vs[0] {
            switch {
            case '0' <= c && c <= '9':
                continue
            default:
                numeric = false
                break
            }
        }
        if muni && numeric {
            return vs[0]
        }
    }
    return ""
}

func getSession(w http.ResponseWriter, r *http.Request) string {
	session, _ := store.Get(r, sessionName)
// 	log.Println(session.IsNew)
	//     fmt.Println(session.Values["uco"].(string))
	if session.IsNew || session.Values["uco"] == "" {
		return ""
	} else {
		uco := session.Values["uco"].(string)
		return uco
	}
}
