package duo

type LoginResult struct {
	Response, Username, User_id string
}

type Event struct {
	Localized_dt_string, Timestamp string
	User_tz_datetime               int
	//     Skill_lessons int //FIXME: int or string? it is all null....
	Num_skills_learned, Xp  int
	Skill_title, Type       string
	Lesson_number, Datetime int
}

type EventsResult struct {
	Events []Event
}

type Week struct {
	Week_id               string
	Week_end              string
	Localized_week_string string
}

type Observee struct {
	User_id            int
	Tree_depth         int
	From_language_name string
	Skills             []struct {
		Completed       bool
		Completion_date string
		Locked          bool
	}
	User_name              string
	Learning_language      string
	Learning_language_name string
	Summary                struct {
		Total_lessons      int
		Attendance         int
		Total_xps          int
		Num_skills_learned int
	}
	Email         string
	Avatar_url    string
	Section       string
	Display_name  string
	From_language string
	Id            string
}

// Keys I do not need are commented out. This makes this code
// less fragile if the datatypes that Duolingo returns change
type DashboardResult struct {
	//Week string
	//All_weeks []Week
	//Needs_notification bool
	Learning_languages_dict map[string]string
	//Tag, Most_common string
	//All_sections []string // this is now something elese, []map[??]?? IMO
	//Enable_discussions bool
	//Enable_immersion bool
	//     Tree_representations []struct {
	//         From_language_name string
	//         Skills []struct {
	//             Skill_color string
	//             Total_lessons int
	//             Skill_name string
	//             Skill_index int
	//         }
	//         Learning_language, Learning_language_name string
	//         Students []string
	//         From_language string
	//         Observee_limit bool
	//         //Enable_stream bool
	//         //Tree_view bool
	//         //Enable_mature_words bool
	//     }
	Observees []Observee
	//Has_old_students bool
	//Email string
	//Has_students bool
}
