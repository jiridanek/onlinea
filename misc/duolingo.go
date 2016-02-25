package misc

import (
	"strings"
)

// NickFromBlokText extracts students Duolingo nick from notebook text
// there is a line with link to Duolingo profile
func NickFromBlokText(text string) string {
	// first likely url
	lines := strings.Split(text, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "|http") && strings.Contains(line, "duolingo.com/") {
			//last part of URL
			urlparts := strings.Split(line, "/")
			return urlparts[len(urlparts)-1]
		}
	}
	// first line
	return lines[0]
}
