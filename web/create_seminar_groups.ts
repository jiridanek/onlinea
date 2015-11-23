"use strict";

/// <reference path="config.ts" />
/// <reference path="groups.ts" />
/// <reference path="page.ts" />

function createGroupsPlan(groups: Group[]) {
	let plan = [
		function(page) {
			page.querySelector('input[name="celkpol"]').value = groups.length;
			page.querySelector('input[name="uprav"]').click();
		},
		function(page) {
			for (let i = 0; i < groups.length; i++) {
				let g = groups[i];
				let p = `s:n${i + 1}:`
				page.querySelector('input[name="' + p + 'OZNACENI"]').value = g.oznaceni;
				page.querySelector('input[name="' + p + 'PORADI"]').value = g.poradi.toString();
				page.querySelector('input[name="' + p + 'MAX_STUDENTU"]').value = g.max_studentu.toString();
				page.querySelector('input[name="' + p + 'POZNAMKA"]').value = g.poznamka;
			}
			let autosave = false;
			if (autosave) {
				page.querySelector('input[name="uloz_tl"]').click();
			}
		}
	];

	return plan;
}