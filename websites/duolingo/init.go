package hello

import (
	"fmt"
	"github.com/gorilla/mux"
	"github.com/gorilla/sessions"
	"github.com/jirkadanek/onlinea/ismu/bloky"
	"github.com/jirkadanek/onlinea/misc"
	"github.com/jirkadanek/onlinea/secrets"
	"golang.org/x/net/context"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"google.golang.org/appengine"
	"google.golang.org/appengine/log"
	"google.golang.org/appengine/user"
	"io"
	"io/ioutil"
	"net/http"
)

var _ = ioutil.ReadAll

var store = sessions.NewCookieStore(secrets.CookieSigningSecret, secrets.CookieEncryptionSecret)
var sessionName = "session"

func newoauthconf(c context.Context) *oauth2.Config {
	scheme := "https"
	if appengine.IsDevAppServer() {
		scheme = "http"
	}
	return &oauth2.Config{
		ClientID:     secrets.OAuthClientID,
		ClientSecret: secrets.OAuthClientSecret,
		RedirectURL:  scheme + "://" + appengine.DefaultVersionHostname(c) + "/oauth2callback",
		Scopes: []string{
			"email",
		},
		Endpoint: google.Endpoint,
	}
}

func init() {

	// go gorilla!
	router := mux.NewRouter()

	router.HandleFunc("/oauth", oauth)
	router.HandleFunc("/logout", logout)
	router.HandleFunc("/oauth2callback", oauthcallback)
	router.HandleFunc("/auth/body", authBody)

	router.HandleFunc("/admin/upload/duolingo", adminUploadDuolingo)

	router.HandleFunc("/test", func(w http.ResponseWriter, r *http.Request) {
		c := appengine.NewContext(r)
		if !user.IsAdmin(c) {
			return
		}
		panic(appengine.DefaultVersionHostname(c))
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
	w.WriteHeader(http.StatusUnauthorized)
	fmt.Fprint(w, "<!doctype html><html><body>Log in failed. Click <a href=\"/login.html\">here</a> to try again.</body></html>")
}

func ucoFromPerson(p Person) string {
	if p.Domain != "mail.muni.cz" {
		return ""
	}
	for _, email := range p.Emails {
		uco := misc.UcoFromMuniMail(email.Value)
		if uco != "" {
			return uco
		}
	}
	return ""
}

func getSession(w http.ResponseWriter, r *http.Request) string {
	c := appengine.NewContext(r)
	session, _ := store.Get(r, sessionName)
	// 	log.Println(session.IsNew)
	//     fmt.Println(session.Values["uco"].(string))
	if session.IsNew || session.Values["uco"] == "" {
		return ""
	} else {
		uco := session.Values["uco"].(string)
		log.Infof(c, "uco = %v", uco)
		return uco
	}
}
