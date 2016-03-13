package mailing

import (
	"log"
	"testing"
)

func data() ReminderData {
	d := ReminderData{Email: "454870@mail.muni.cz",
		FullName:          "Bc. Jana Berendová",
		Total:             96.5,
		Discussion:        0,
		DeadlineName:      "Deadline Assignment 1",
		DeadlineNumber:    1,
		DeadlineDate:      "March 15, 2016",
		DeadlineCompleted: true,
		DeadlinesMissed:   0,
		DeadlinePrintout: `Completed Placement test:	YES
Completed How-to-work ROPOT:	YES
Enrolled in a seminar group:	assuming YES
`,
	}
	return d
}

func TestRenderText(t *testing.T) {
	log.Println(RenderTextProgressReport(data()))
}

func TestRenderHtml(t *testing.T) {
	log.Println(RenderHtmlProgressReport(data()))
}
