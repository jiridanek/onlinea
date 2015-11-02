package hello

import (
	"golang.org/x/net/context"
	"google.golang.org/appengine/datastore"
)

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
