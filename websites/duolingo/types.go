package hello

type Students struct {
	Students []Student
}

type Student struct {
	Uco  string `datastore:",noindex"`
	Nick string `datastore:",noindex"`
	Id   string `datastore:",noindex"`
}

// from https://github.com/google/google-api-go-client/blob/master/plus/v1/plus-gen.go
type Person struct {
	// Domain: The hosted domain name for the user's Google Apps account.
	// For instance, example.com. The plus.profile.emails.read or email
	// scope is needed to get this domain name.
	Domain string `json:"domain,omitempty"`

	// Emails: A list of email addresses that this person has, including
	// their Google account email address, and the public verified email
	// addresses on their Google+ profile. The plus.profile.emails.read
	// scope is needed to retrieve these email addresses, or the email scope
	// can be used to retrieve just the Google account email address.
	Emails []*PersonEmails `json:"emails,omitempty"`

	// Etag: ETag of this response for caching purposes.
	Etag string `json:"etag,omitempty"`
}

type PersonEmails struct {
	// Type: The type of address. Possible values include, but are not
	// limited to, the following values:
	// - "account" - Google account email address.
	// - "home" - Home email address.
	// - "work" - Work email address.
	// - "other" - Other.
	Type string `json:"type,omitempty"`

	// Value: The email address.
	Value string `json:"value,omitempty"`
}
