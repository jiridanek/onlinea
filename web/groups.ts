"use strict";

class Group {
	oznaceni: string;
	poradi: number;
	max_studentu: number;
	poznamka: string;
}

function newGroup(level: string, n: number) {
	let g = new Group();
	g.oznaceni = `${level}g${n}`;
	g.max_studentu = 30;
	let p = "Discussion Group for Points. Recommended for students at levels ";
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

let groups: Group[] = [];
for (let i = 1; i <= 10; i++) {
	groups.push(newGroup("A", i));
}
for (let i = 1; i <= 30; i++) {
	groups.push(newGroup("B", i));
}
for (let i = 1; i <= 10; i++) {
	groups.push(newGroup("BC", i));
}
groups.push(newGroup("C", 1));