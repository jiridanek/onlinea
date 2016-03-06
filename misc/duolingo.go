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

//UcoFromMuniMail returns uco or "" if not muni mail
func UcoFromMuniMail(email string) string {
	parts := strings.Split(email, "@")
	if len(parts) == 2 && parts[0] != "" && parts[1] == "mail.muni.cz" {
		numeric := true
		for _, c := range parts[0] {
			if c < '0' || c > '9' {
				numeric = false
			}
		}
		if numeric {
			return parts[0]
		}
	}
	return ""
}
