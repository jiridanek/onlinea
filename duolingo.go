package main

import (
    "fmt"
    "flag"
    "time"
    "github.com/jirkadanek/onlinea/duolingo"
    "log"
    "os"
    "github.com/jirkadanek/onlinea/ismu/bloky"
    "bytes"
    "io"
    "github.com/jirkadanek/onlinea/misc"
)

var (
    first = time.Date(2015, time.February, 2, 23, 0, 0, 0, time.UTC)
)

func date(i int) string {
    d := first
    for ; i > 1; i-- {
        d = d.AddDate(0, 0, 7)
    }
    format := "2006-01-02"
    return d.Format(format)
}

func Duolingo(args []string) {
//     fmt.Println("Duolingo")
    
    flagset := flag.NewFlagSet("duolingo", flag.PanicOnError)
    week := flagset.Int("week", 0, "week number of the semester, starting from 1")
    blok := flagset.String("blok", "", "filepath to csv exported Duolingo blok")
    nick := flagset.String("nick", "", "week number of the semester, starting from 1")
    //format := flagset.Int("week", 0, "blok, text")
    flagset.Parse(args)
    
    if *week <= 0 {
        log.Fatal("week must be 1 or more")
    }
    
    i := 0
    modes := []bool{*blok != "", *nick != ""}
    for _, v := range modes {
        if v {
            i++
        }
    }
    if i != 1 {
        log.Fatal("specify exacttly one of blok, nick")
    }
    
    if *blok != "" {
        records := readBlok(*blok)
        
        students, events := duolingo(date(*week), "")
        print_scores(records, students, events)
    }
    if *nick != "" {
        students, events := duolingo(date(*week), *nick)
        _ = students
        record := bloky.Record{[]string{"","","","","","","",""}}
        var event EventsOrErr
        for _, e := range events {
            event = e
            break
        }
        print_scores_student(os.Stdout, record, event, false)
    }
}

type EventsOrErr struct {
    Events []duo.Event
    Err string
}

func duolingo(week string, nick string) ([]duo.Observee, map[string]EventsOrErr) {    
    students := make([]duo.Observee,0)
    events := make(map[string]EventsOrErr)
    
    duo.DoLogin()
    dashboard := duo.DoDashboardGet()
    for _, observee := range dashboard.Observees {
        if observee.Learning_language != "en" {
            user_id := fmt.Sprintf("%d", observee.User_id)
            msg := "You are learning language(s) "
            if _, found := events[user_id]; found {
                msg = events[user_id].Err + ", "
            }
            events[user_id] = EventsOrErr{Err: msg + observee.Learning_language}
            continue
        }
        students = append(students, observee)
    }
    
    if nick != "" {
        for _, student := range students {
//             fmt.Println(student.User_name)
            if nick != student.User_name {
                continue
            }
            user_id := fmt.Sprintf("%d", student.User_id)
            for i := 0; i < 10; i++ { 
                res, err := duo.DoEventsGet(user_id, week)
                if err != nil {
                    continue
                }
                events[user_id] = EventsOrErr{Events: res.Events}
            }
            return []duo.Observee{student}, events
        }
        log.Panic("nick not found, does not exist or not leaning en")
    }
    
    for _, student := range students {
        //fmt.Printf("%+v", student); panic("")
        user_id := fmt.Sprintf("%d", student.User_id)
        // retry multiple times
        var err error
        var res duo.EventsResult
        for i := 0; i < 10; i++ { 
            //fmt.Println("aaa", user_id, week); panic("")
            res, err = duo.DoEventsGet(user_id, week)
            if err == nil {
                break
            }
        }
        if err != nil {
            log.Fatal(err)
        }
        events[user_id] = EventsOrErr{Events: res.Events}
    }
    return dashboard.Observees, events
}

func readBlok(fname string) []bloky.Record {
    fp, err := os.Open(fname)
    if err != nil {
        log.Fatal("blok must be a valid filepath", err)
    }
    reader := bloky.NewReader(fp)
    records, err := reader.ReadAll()
    if err != nil {
        log.Fatal(err)
    }
    return records
}

func print_scores(records []bloky.Record, students []duo.Observee, events map[string]EventsOrErr) {
    for _, r := range records {
        found := false
        for _, s := range students {
            nick := misc.NickFromBlokText(r.Value())
            if nick == s.User_name {
                found = true
                user_id := fmt.Sprintf("%d", s.User_id)
                var b bytes.Buffer
                print_scores_student(&b, r, events[user_id], false)
                if b.Len() > 4000 {
                    b.Reset()
                    print_scores_student(&b, r, events[user_id], true)
                }
                fmt.Printf(b.String())
            }
        }
        if !found {
                // student is in block but is not in dashboard, studying en
                //TODO the other direction
                log.Printf("student %s je v bloku ale není na duolingu!!!", r.Uco()) //FIXME: write something better
        }
    }
}

func score(event duo.Event) int {
    switch event.Type {
        case "lesson": return 10
        case "test": return 10
        default: return 0
    }
}
    
func print_scores_student(w io.Writer, student bloky.Record, eventsOrErr EventsOrErr, brief bool) {
    fmt.Fprintf(w, "\t\t\t\t\t\t%s\t", student.Id())
    //fmt.Printf("a\ta\ta\ta\ta\ta\t%s\t", student.Id())
    fmt.Fprintf(w, "       Lesson                  Activity type     Points\n")
    fmt.Fprintf(w, "|----------------------------------------------------------\n")
    events := eventsOrErr.Events
    if eventsOrErr.Err != "" {
        fmt.Fprintf(w, "|\n")
        fmt.Fprintf(w, "|asi mate Duolingo prepnute do jineho nez anglickeho kurzu\n")
        fmt.Fprintf(w, "|v takovem pripade bohuzel nevidim vase ziskane body\n")
        fmt.Fprintf(w, "|\n")
        fmt.Fprintf(w, "|%s\n", eventsOrErr.Err)
        fmt.Fprintf(w, "|\n")
    } else {
        for _, event := range events {
            if !brief {
                fmt.Fprintf(w, "|%30s %10s %5d\n", event.Skill_title, event.Type, score(event))
            }
        }
        
        if len(events) == 0 || brief {
            fmt.Fprintf(w, "|\n")
            if len(events) == 0 {
                fmt.Fprintf(w, "|no activities were completed\n")
            } else if brief {
                fmt.Fprintf(w, "|a lot of activities were completed\n")
            }
            fmt.Fprintf(w, "|\n")
        }
    }
    fmt.Fprintf(w, "|--------------------------------------------------\n")
    if eventsOrErr.Err == "" {
        sum := 0
        for _, event := range events {
            sum += score(event)
        }
        fmt.Fprintf(w, "|\n")
        fmt.Fprintf(w, "|                                     TOTAL: *%d\n", sum)
    }
}