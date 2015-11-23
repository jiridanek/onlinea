"use strict";

let iframeOnLoad;
let iframe = <HTMLIFrameElement>document.querySelector('#iframe');
iframe.addEventListener('load', function() { iframeOnLoad(); });

function runPlan(constructor, url: string, plan: Array<any>) {
	return new Promise(function(resolve, reject) {
		plan.push(function(_) {
			resolve();
		});
		let stage = 0;
		iframeOnLoad = function() {
			if (stage < plan.length) {
				var page = new constructor(iframe.contentDocument);
				plan[stage](page);
				stage++;
			}
		};
		iframe.src = url;
	});
}

var get_seminar_groups = function() {
    return new Promise(function(resolve, reject) {
        var groups = [];
        let plan = [
            function(page) {
                var lis = page.querySelectorAll("#aplikace ul > li");

                for (var i = 0; i < lis.length; i++) {
                    var t = lis[i].firstChild.innerText;
                    if (!t) continue;
                    //var m = t.match(/PdF:ONLINE_A\/([ABC]C?g\d+)/);
					let m = t.match(/Discussion Forum for Points \(([ABC]C?g\d+)\)/)
                    if (m) {
						let oznaceni = m[1];
						let href = lis[i].firstChild.href;
						let guz = href.match(/guz=(\d+)/)[1];
                        groups.push(guz);
                    }
                }
                page.reload();
            }
        ]
		let config = new Config();
		let url = `https://is.muni.cz/auth/ucitel/ucitel_diskusni_fora?` +
			`fakulta=${config.fakulta};obdobi=${config.obdobi};predmet=${config.predmet}`;
        runPlan(Page, url, plan).then(function() { resolve(groups); });
    });
};

function create_seminar_groups() {
	let config = new Config();
	let url = `https://is.muni.cz/auth/seminare/seminare_plneni?fakulta=` +
		`{config.fakulta};obdobi=${config.obdobi};predmet=${config.predmet}`;

	let plan = createGroupsPlan(groups);
	let p = runPlan(Page, url, plan);
}

function create_discussion_forums() {
	let config = new Config();
	let url = `https://is.muni.cz/auth/diskuse/diskusni_forum_nastaveni.pl?fakulta=${config.fakulta};` +
		`obdobi=${config.obdobi};predmet=${config.predmet};akce=new;predmet_id=${config.predmet}`;

	let oznaceni = groups.map(function(g) { return g.oznaceni });
	function loop(i: number) {
		if (i < oznaceni.length) {
			let skupina = oznaceni[i];
			let plan = createForumPlan(
				`Discussion Forum for Points (${skupina})`,
				`${skupina}_${config.tobdobi}`,
				skupina,
				config.konecdiskuse
			);
			let p = runPlan(Forum, url, plan);
			p.then(function() {
				loop(i + 1);
			});
		}
	}
	loop(0);
}

function edit_discussion_forums(guzs: string[]) {
	let plan = [
		function(forum) {
			forum.field("input", "diskuse_PRAVO_w1_DAT").value = "xx";
            let autosave = false;
            if (autosave) {
                forum.uloz.click();
            }
		}
	]
	function loop(i) {
		if (i < guzs.length) {
			let guz = guzs[i];
			let p = edit_discussion_forum(guz, plan);
			p.then(function() {
				loop(i + 1);
			})
		}
	}
	loop(0);
}

function edit_discussion_forum(guz, plan) {
	let url = `https://is.muni.cz/auth/diskuse/diskusni_forum_nastaveni?guz=${guz};akce=edit`;
	return runPlan(Forum, url, plan);
}

// chromium --user-data-dir=/tmp/dart_test_pLppGJ --disable-web-security

//create_seminar_groups()
create_discussion_forums();

//get_seminar_groups().then(function(guzs: string[]) {
//	edit_discussion_forums(guzs);
//});