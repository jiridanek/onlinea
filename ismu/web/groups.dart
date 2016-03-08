class Group {
	String oznaceni;
	num poradi;
	num max_studentu;
	String poznamka;
}

newGroup(String level, num n) {
	var g = new Group()
    ..oznaceni = '${level}g${n}'
	  ..max_studentu = 30;
	var p = "Discussion Group for Points. Recommended for students at levels ";
	switch (level) {
		case "A":
			g.poradi = 400 + n;
			g.poznamka = p + "&lt;A1, A1 and A2 in the Placement Test.";
			break;
		case "B":
			g.poradi = 300 + n;
			g.poznamka = p + "B1 and B2 in the Placement Test.";
			break;
		case "BC":
			g.poradi = 200 + n;
			g.poznamka = p + "B2, C1 and C1+ in the Placement Test.";
			break;
		case "C":
			g.poradi = 100 + n;
			g.poznamka = p + "C1 and C1+ in the Placement Test.";
			break;
		default:
			throw "invalid level: " + level;
	}
	return g;
}

get groups {
  List<Group> groups = [];
  for (var i = 1; i <= 10; i++) {
    groups.add(newGroup("A", i));
  }
  for (var i = 1; i <= 30; i++) {
    groups.add(newGroup("B", i));
  }
  for (var i = 1; i <= 10; i++) {
    groups.add(newGroup("BC", i));
  }
  groups.add(newGroup("C", 1));
  return groups;
}