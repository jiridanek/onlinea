/**
 * Created by jirka on 8/28/15.
 */

"use strict";

/// <reference path="config.ts" />
/// <reference path="groups.ts" />
/// <reference path="page.ts" />

var Forum = function(document) {
    this.form = document.querySelector("#aplikace > form");
    
    this.NAZEV = this.field("input", "NAZEV");
    this.ZKRATKA_PRO_URL = this.field("input", "ZKRATKA_PRO_URL");
    this.hodnotit_body = this.field("input", "hodnotit_body");
    this.student_smi_nahlizet = this.field("input", "student_smi_nahlizet");

    this.zrusit_pravo_r_diskuse = this.field("input", "zrusit_pravo_r_diskuse");

    this.TYP_diskuse = this.field("select", "TYP_diskuse");
    this.SUBTYP_diskuse = this.field("select", "SUBTYP_diskuse");

    this.nahrad_pravem_rdiskuse = this.field("input", "nahrad_pravem_rdiskuse");
    this.zrusit_pravo_diskuse = this.field("input", "zrusit_pravo_diskuse");
    this.pridat_upr_diskuse = this.field("input", "pridat_upr_diskuse");

    this.upravene_nove = this.field("input", "upravene_nove");
    this.pocitat_slova_znaky = this.field("input", "pocitat_slova_znaky");

    this.uloz = this.field("input", "uloz");
};

Forum.prototype.field = function(type, name) {
    if (this.form === null) {
        return null;
    }
    return this.form.querySelector(`${type}[name="${name}"]`);
};

function createForumPlan(nazev, zkratka, skupina, closedate) {
    var config = new Config();
    var plan = [
        function(page) {
            if (nazev) page.NAZEV.value = nazev;
            if (zkratka) page.ZKRATKA_PRO_URL.value = zkratka;
            page.hodnotit_body.checked = true;
            
            page.upravene_nove.checked = true;
            page.pocitat_slova_znaky.checked = true;
            page.field('input', 'pouze_reagovat').checked = true;
            page.field('input', 'zakazat_mazani').checked = true;

            page.zrusit_pravo_r_diskuse.checked = true;
            page.zrusit_pravo_diskuse.click();
        },
        function(page) {
            page.student_smi_nahlizet.checked = true;
            planStartAddingModeratorClick(page);
        },
        function(page) {
            planSetAccessPersonClick(page.form, '79615'); // J. Zerzova
        },
        function(page) {
            planStartAddingModeratorClick(page);
        },
        function(page) {
            planSetAccessPersonClick(page.form, '2227'); // T. Vanová
        },

        function(page) {
            page.TYP_diskuse.value = 'r'; // právo číst
            page.SUBTYP_diskuse.value = 's'; // studenti semináře
            page.pridat_upr_diskuse.click();
        },
        function(page) {
            planSetAccessSeminarClick(page.form, config.fakulta, config.sobdobi, config.spredmet, skupina);
        },
        function(page) {
            page.nahrad_pravem_rdiskuse.click()
        },
        function(page) {
            page.form.querySelector("input[name=diskuse_PRAVO_w1_DAT]").value = closedate;
            let autosave = true;
            if (autosave) {
                page.uloz.click();
            }
        }
    ];
    return plan;
}

function planStartAddingModeratorClick(page) {
    page.TYP_diskuse.value = 'a'; // moderátoři
    page.SUBTYP_diskuse.value = 'i'; // osoba
    page.pridat_upr_diskuse.click();
}

var planSetAccessPersonClick = function(form, uco) {
    var UCO_diskuse = form.querySelector("input[name=UCO_diskuse]");
    var pridat_upr_pravo_diskuse = form.querySelector("input[name=pridat_upr_pravo_diskuse]");
    UCO_diskuse.value = uco;
    pridat_upr_pravo_diskuse.click();
};

var planSetAccessSeminarClick = function(form, fak, obd, kod, sem) {
    var FAK_diskuse = form.querySelector("select[name=FAK_diskuse]");
    var OBD_diskuse = form.querySelector("select[name=OBD_diskuse]");
    var KOD_diskuse = form.querySelector("input[name=KOD_diskuse]");
    var SEM_diskuse = form.querySelector("input[name=SEM_diskuse]");
    var pridat_upr_pravo_diskuse = form.querySelector("input[name=pridat_upr_pravo_diskuse]");
    FAK_diskuse.value = fak;
    OBD_diskuse.value = obd;
    KOD_diskuse.value = kod;
    SEM_diskuse.value = sem;
    pridat_upr_pravo_diskuse.click();
};