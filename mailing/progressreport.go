package mailing

type ReminderData struct {
	Email             string
	FullName          string
	Total             float64
	Discussion        float64
	DeadlineName      string
	DeadlineNumber    int
	DeadlineCompleted bool
	DeadlinePrintout  string
	DeadlinesMissed   int
}

func ProgressReport(s Service) {
	//m := s.NewMessage()

}
