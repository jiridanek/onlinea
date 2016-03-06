package duo

import (
	"time"
)

var (
	First  = time.Date(2016, time.February, 22, 23, 0, 0, 0, time.UTC) // first day of the semester
	Format = "2006-01-02"
)

func Score(event Event) int {
	switch event.Type {
	case "lesson":
		return 10
	case "test":
		return 10
	case "practice":
		if event.Skill_title == "" {
			return 10
		}
		return 0
	default:
		return 0
	}
}

type DuolingoPoints struct {
	Nlessons, Plessons     int
	Npractices, Ppractices int
	Ptotal                 int
}

func CalculatePoints(events []Event) DuolingoPoints {
	nlessons := 0
	plessons := 0
	npractices := 0
	ppractices := 0

	for _, event := range events {
		switch event.Type {
		case "lesson", "test":
			nlessons++
			plessons += Score(event)
		case "practice":
			if event.Skill_title != "" {
				// practicing a concrete skill
				continue
			}
			npractices++
			ppractices += Score(event)
		}
	}

	ptotal := plessons
	if ppractices < ptotal {
		ptotal = ppractices
	}

	if 70 < ptotal {
		ptotal = 70
	}

	return DuolingoPoints{
		Nlessons:   nlessons,
		Plessons:   plessons,
		Npractices: npractices,
		Ppractices: ppractices,
		Ptotal:     ptotal,
	}
}
