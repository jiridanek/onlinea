package mailing

import (
	"log"
	"testing"
)

func TestRender(t *testing.T) {
	d := ReminderData{Email: "454870@mail.muni.cz",
		FullName:          "Bc. Jana Berendová",
		Total:             96.5,
		Discussion:        0,
		DeadlineName:      "Deadline Assignment 1",
		DeadlineNumber:    1,
		DeadlineCompleted: true,
		DeadlinesMissed:   0,
		DeadlinePrintout: `Completed Placement test:	YES
Completed How-to-work ROPOT:	YES
Enrolled in a seminar group:	assuming YES
`,
	}
	log.Println(renderTextProgressReport(d))
}
