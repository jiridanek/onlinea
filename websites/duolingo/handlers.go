package hello

import (
	"encoding/json"
	"fmt"
	"github.com/jirkadanek/onlinea/duolingo"
	"github.com/jirkadanek/onlinea/misc"
	"golang.org/x/oauth2"
	"google.golang.org/appengine"
	"google.golang.org/appengine/log"
	"google.golang.org/appengine/urlfetch"
	"google.golang.org/appengine/user"
	"net/http"
	"net/http/cookiejar"
	"strings"
)

func authBody(w http.ResponseWriter, r *http.Request) {
	uco := getSession(w, r)
	if uco == "" {
		http.Redirect(w, r, "/login.html", http.StatusFound)
		return
	}
	showDuolingoActivity(uco, w, r)
	return
}

func oauth(w http.ResponseWriter, r *http.Request) {
	//FIXME: for now ignore CRSS token as the site is read-only
	url := oauthconf.AuthCodeURL("state", oauth2.SetAuthURLParam("hd", "mail.muni.cz"), oauth2.AccessTypeOnline)
	http.Redirect(w, r, url, http.StatusFound) // FIXME: Found?
}
func oauthcallback(w http.ResponseWriter, r *http.Request) {
	c := appengine.NewContext(r)
	authcode := r.FormValue("code")
	token, err := oauthconf.Exchange(c, authcode)
	if err != nil {
		log.Errorf(c, "Exchanging token failed: %v", err)
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

	http.Redirect(w, r, "/auth/body", http.StatusFound)
}
func logout(w http.ResponseWriter, r *http.Request) {
	session, _ := store.Get(r, sessionName)
	session.Values["uco"] = ""
	session.Save(r, w)
	http.Redirect(w, r, "/", http.StatusFound)
}

func adminUploadDuolingo(w http.ResponseWriter, r *http.Request) {
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

	cookieJar, _ := cookiejar.New(nil)
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
				break
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

}
