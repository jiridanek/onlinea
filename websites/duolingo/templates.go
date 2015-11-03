package hello

import (
	"html/template"
	//    "golang.org/x/net/context"
)

var tmpl = template.Must(template.ParseGlob("templates/amp.html"))

type Report struct {
	Err              string
	Uco, Jmeno, Nick string
	Tyden, Tabulka   string
}

//renderTemplate(name String) template.HTML

//func renderPage(c context.Context, main *template.HTML, options PageOptions) template.HTML {
//    if main == nil {
//        template.HTML(tmpl.Lookup("main.html").Execute(buf, nil))
//    }
//    return html
//}
