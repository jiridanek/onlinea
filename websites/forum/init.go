package init

import (
	"golang.org/x/net/context"
	"google.golang.org/appengine"
	"html/template"
	"net/http"
	"sort"
	//	"google.golang.org/appengine/datastore"
	"time"
)

import (
//	"fmt"
//	"github.com/gorilla/mux"
//	"github.com/gorilla/sessions"
//	"github.com/jirkadanek/onlinea/ismu/bloky"
//	"github.com/jirkadanek/onlinea/secrets"
//	"golang.org/x/net/context"
//	"golang.org/x/oauth2"
//	"golang.org/x/oauth2/google"
//	"google.golang.org/appengine/log"
//	"google.golang.org/appengine/user"
//	"io"
//	"io/ioutil"
//	"strings"
)

type Post struct {
	Parent     string
	Author     string
	Text       string
	Votes      int
	UpVotes    int
	DownVotes  int
	PeerPoints int
	Answers    int
	Created    time.Time
	Updated    time.Time
}

type Thread struct {
	Text  string
	Nodes []*Node
}

type Node struct {
	Post
	Nodes []*Node
}

type ByVotes []*Node

func (t ByVotes) Len() int {
	return len(t)
}
func (t ByVotes) Swap(i, j int) {
	t[i], t[j] = t[j], t[i]
}
func (t ByVotes) Less(i, j int) bool {
	return t[i].Post.Votes < t[j].Post.Votes
}

func init() {
	router := http.NewServeMux()
	router.HandleFunc("/", root)
	//	router.HandleFunc("/logout", logout)
	//	router.HandleFunc("/oauth2callback", oauthcallback)
	//	router.HandleFunc("/auth/body", authBody)
	//
	//	router.HandleFunc("/admin/upload/duolingo", adminUploadDuolingo)
	//
	//	router.HandleFunc("/test", func(w http.ResponseWriter, r *http.Request) {
	//		c := appengine.NewContext(r)
	//		if !user.IsAdmin(c) {
	//			return
	//		}
	//		panic(appengine.DefaultVersionHostname(c))
	//		s := make([]Student, 0)
	//		s = append(s, Student{"aa", "bb", "cc"})
	//		err := dbPutStudents(c, s)
	//		http.Error(w, fmt.Sprintf("%v", err), http.StatusUnauthorized)
	//	})
	//
	http.Handle("/", router)
}

func root(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		thread(w, r)
		return
	}
	index(w, r)
	return
}

func index(w http.ResponseWriter, r *http.Request) {
	c := appengine.NewContext(r)
	question := template.Must(template.New("question").Parse(`<hr><h6>{{.Author}}:</h6>{{.Text}}`))
	qs := getFeaturedQuestions(c)
	for _, q := range qs {
		question.Execute(w, q)
	}
}

func getFeaturedQuestions(c context.Context) []*Node {
	// cache in memcache
	// 20 recent & without answers, 20 recent & voted for, combine
	//	datastore.NewQuery("Question").
	return []*Node{}
}

func thread(w http.ResponseWriter, r *http.Request) {
	//c := appengine.NewContext(r)
	threadid := r.URL.Path
	thread := getThread(threadid)
	formatThread(w, thread)
}

func getThread(threadId string) Thread {
	q := Post{Author: "Jirka Daněk", Text: "Proč to nemůže být 'Elephants devour bread.'?"}
	a := Post{Author: "Pepa Novák", Text: "Protože Proto"}
	return Thread{
		Text: "Sloni jedí chleba",
		Nodes: []*Node{&Node{q,
			[]*Node{&Node{a,
				[]*Node{}}}}}}
}

func formatThread(w http.ResponseWriter, t Thread) {
	sortThreads(ByVotes(t.Nodes))

	question := template.Must(template.New("question").Parse(`<hr><h6>{{.Author}}:</h6>{{.Text}}`))

	for _, q := range t.Nodes {
		question.Execute(w, q)
		for _, a := range q.Nodes {
			question.Execute(w, a)
			for _, c := range a.Nodes {
				question.Execute(w, c)
			}
		}
	}
}

func sortThreads(ns []*Node) {
	for _, n := range ns {
		sortThreads(n.Nodes)
	}
	sort.Sort(ByVotes(ns))
}

//
//func readBlok(r io.Reader) ([]bloky.Record, error) {
//	reader := bloky.NewReader(r)
//	records, err := reader.ReadAll()
//	return records, err
//}
//
//func loginFailed(w http.ResponseWriter, r *http.Request) {
//	w.WriteHeader(http.StatusUnauthorized)
//	fmt.Fprint(w, "<!doctype html><html><body>Log in failed. Click <a href=\"/login.html\">here</a> to try again.</body></html>")
//}
//
//func ucoFromPerson(p Person) string {
//	if p.Domain != "mail.muni.cz" {
//		return ""
//	}
//	for _, email := range p.Emails {
//		vs := strings.Split(email.Value, "@")
//		muni := vs[1] == "mail.muni.cz"
//		numeric := vs[0] != ""
//		for _, c := range vs[0] {
//			switch {
//			case '0' <= c && c <= '9':
//				continue
//			default:
//				numeric = false
//				break
//			}
//		}
//		if muni && numeric {
//			return vs[0]
//		}
//	}
//	return ""
//
//func getSession(w http.ResponseWriter, r *http.Request) string {
//	c := appengine.NewContext(r)
//	session, _ := store.Get(r, sessionName)
//	// 	log.Println(session.IsNew)
//	//     fmt.Println(session.Values["uco"].(string))
//	if session.IsNew || session.Values["uco"] == "" {
//		return ""
//	} else {
//		uco := session.Values["uco"].(string)
//		log.Infof(c, "uco = %v", uco)
//		return uco
//	}
//}
