import "dart:html" as dom;

import "package:is/is.dart" as ismu;

import "password.dart";

main() {
  print("running");
  ismu.LogInPage.logIn(USERNAME, PASSWORD).then((_) {
    print("logged in");
    dom.querySelector("button").onClick.listen((_) {
      //send();
      zrus_rwall().then((dom.HttpRequest r) {
        print("request sent");
//        print(r.responseType);
//        print(r.response);
//        print(r.responseText);
        var div = dom.querySelector("div"); 
        div.innerHtml = r.responseText; 
      });
    });
  });
}

  var predmet = "771131";
  var obdobi = "6084";
  var guz = "50462422";
  var group = "A6";
  var abbr = "A_6";
  
  var url = "https://is.muni.cz/auth/diskuse/diskusni_forum_nastaveni.pl?fakulta=1441;obdobi=${obdobi};predmet=${predmet};akce=edit;guz=${guz}";

send() {
  print("sending");
  
  var data = {
    "exppar": "1",
    "akce": "edit",
    "guz": guz,
    "predmet_id": predmet,
    "blog": "",
    "fakulta": "1441",
    "obdobi": "6084",
    "predmet": predmet,
//    "_": "5241721499",
    "NAZEV": "PdF:ONLINE_A/${group} Discussion For Points",
    "ZKRATKA_PRO_URL": abbr,
    "ZAHLAVI": "<p>This is the forum where you can get points for discussions in English. Don't forget that you need to earn at least 100 points from posting/reacting to other posts to be eligible for credit.</p>",
    "hodnotit_body": "ano",
    "student_mohl_nahlizet": "a",
    "student_smi_nahlizet": "a",
    "pocitat_slova_znaky": "ano",
//    "diskuse_posl_zmena": "20140906103446",
    "diskuse_PRAVO_a1": "i",
    "diskuse_PRAVO_a1_UPR": "374368",
    "diskuse_PRAVO_a1_DAT": "",
    "diskuse_PRAVO_a2": "i",
    "diskuse_PRAVO_a2_UPR": "79615",
    "diskuse_PRAVO_a2_DAT": "",
    "diskuse_PRAVO_r2_DAT": "",
    "diskuse_PRAVO_r2": "s",
    "diskuse_PRAVO_r2_UPR": "336459",
//    "diskuse_PRAVO_r2_DAT": "",
//    "diskuse_PRAVO_w2_DAT": "14 12 2014 23 36",
    "diskuse_PRAVO_w2": "s",
    "diskuse_PRAVO_w2_UPR": "336459",
    "diskuse_PRAVO_w2_DAT": "14 12 2014 23 36",
    "TYP_diskuse": "a",
    "SUBTYP_diskuse": "i",
    "uloz": "Uložit"
  };
  return dom.HttpRequest.postFormData(url, data);
}

zrus_rwall() {
  var data = {
    "exppar": "1",
    "akce": "edit",
    "guz": guz,
    "predmet_id": predmet,
    "blog": "",
    "fakulta": "1441",
    "obdobi": "6084",
    "predmet": predmet,
    "NAZEV": "PdF:ONLINE_A/${group} Discussion For Points",
    "ZKRATKA_PRO_URL": abbr,
    "ZAHLAVI": "<p>This is the forum where you can get points for discussions in English. Don't forget that you need to earn at least 100 points from posting/reacting to other posts to be eligible for credit.</p>",
    "hodnotit_body": "ano",
    "student_mohl_nahlizet": "a",
    "student_smi_nahlizet": "a",
    "pocitat_slova_znaky": "ano",
//    "diskuse_posl_zmena": "20140906121426",
    
    
    "diskuse_PRAVO_a1": "i",
    "diskuse_PRAVO_a1_UPR": "374368",
    "diskuse_PRAVO_a1_DAT": "",
    
    "zrusit_pravo_r_diskuse": "r:w:",
    "diskuse_PRAVO_r1":"w",
    "diskuse_PRAVO_r1_UPR":"",
    "diskuse_PRAVO_r1_DAT":"",
    "zrusit_pravo_w_diskuse": "w:w:",
    "diskuse_PRAVO_w1":"w",
    "diskuse_PRAVO_w1_UPR":"",
    "diskuse_PRAVO_w1_DAT":"",
//        "diskuse_PRAVO_a2": "i",
//        "diskuse_PRAVO_a2_UPR": "79615",
//        "diskuse_PRAVO_a2_DAT": "",
//        "diskuse_PRAVO_r2_DAT": "",
//        "diskuse_PRAVO_r2": "s",
//        "diskuse_PRAVO_r2_UPR": "336459",
////    "diskuse_PRAVO_r2_DAT": "",
////    "diskuse_PRAVO_w2_DAT": "14 12 2014 23 36",
//        "diskuse_PRAVO_w2": "s",
//        "diskuse_PRAVO_w2_UPR": "336459",
//        "diskuse_PRAVO_w2_DAT": "14 12 2014 23 36",
//        "TYP_diskuse": "a",
//        "SUBTYP_diskuse": "i",
    
    
    
    "zrusit_pravo_diskuse": "Zrušit zaškrtnutá práva",
    "TYP_diskuse": "r",
    "SUBTYP_diskuse": "W"
  };
  return dom.HttpRequest.postFormData(url, data);
}


///*
//
//<input type="hidden" name="TYP_diskuse" value="r">
//
//<input type="hidden" name="SUBTYP_diskuse" value="s">
//
//<select name="FAK_diskuse"><option value="1411">LF</option><option value="1421">FF</option><option value="1422">PrF</option><option value="1423">FSS</option><option value="1431">PřF</option><option value="1433">FI</option><option value="1441" selected="">PdF</option><option value="1451">FSpS</option><option value="1456">ESF</option><option value="1490">CST</option></select>
//
//<select name="OBD_diskuse"><option value="jaro 2015">jaro 2015</option><option value="podzim 2014" selected="">podzim 2014</option><option value="jaro 2014">jaro 2014</option><option value="podzim 2013">podzim 2013</option><option value="jaro 2013">jaro 2013</option><option value="podzim 2012">podzim 2012</option><option value="jaro 2012">jaro 2012</option><option value="podzim 2011">podzim 2011</option><option value="jaro 2011">jaro 2011</option><option value="podzim 2010">podzim 2010</option><option value="jaro 2010">jaro 2010</option><option value="podzim 2009">podzim 2009</option><option value="jaro 2009">jaro 2009</option><option value="podzim 2008">podzim 2008</option><option value="jaro 2008">jaro 2008</option><option value="podzim 2007">podzim 2007</option><option value="jaro 2007">jaro 2007</option><option value="podzim 2006">podzim 2006</option><option value="jaro 2006">jaro 2006</option><option value="podzim 2005">podzim 2005</option><option value="jaro 2005">jaro 2005</option><option value="podzim 2004">podzim 2004</option><option value="jaro 2004">jaro 2004</option><option value="podzim 2003">podzim 2003</option><option value="jaro 2003">jaro 2003</option><option value="podzim 2002">podzim 2002</option><option value="jaro 2002">jaro 2002</option><option value="podzim 2001">podzim 2001</option><option value="jaro 2001">jaro 2001</option><option value="podzim 2000">podzim 2000</option><option value="jaro 2000">jaro 2000</option><option value="podzim 1999">podzim 1999</option><option value="jaro 1999">jaro 1999</option><option value="podzim 1998">podzim 1998</option><option value="léto 1998">léto 1998</option><option value="zima 1997">zima 1997</option><option value="léto 1997">léto 1997</option><option value="zima 1996">zima 1996</option><option value="léto 1996">léto 1996</option><option value="zima 1995">zima 1995</option><option value="léto 1995">léto 1995</option><option value="zima 1994">zima 1994</option><option value="léto 1994">léto 1994</option><option value="zima 1993">zima 1993</option><option value="léto 1993">léto 1993</option><option value="zima 1992">zima 1992</option><option value="léto 1992">léto 1992</option><option value="zima 1991">zima 1991</option><option value="léto 1991">léto 1991</option><option value="zima 1990">zima 1990</option><option value="léto 1990">léto 1990</option><option value="zima 1989">zima 1989</option><option value="léto 1989">léto 1989</option><option value="zima 1988">zima 1988</option><option value="léto 1988">léto 1988</option><option value="zima 1987">zima 1987</option><option value="léto 1987">léto 1987</option><option value="zima 1986">zima 1986</option><option value="léto 1986">léto 1986</option><option value="zima 1985">zima 1985</option><option value="léto 1985">léto 1985</option><option value="zima 1984">zima 1984</option><option value="léto 1984">léto 1984</option><option value="zima 1983">zima 1983</option><option value="léto 1983">léto 1983</option><option value="zima 1982">zima 1982</option><option value="léto 1982">léto 1982</option><option value="zima 1981">zima 1981</option><option value="léto 1981">léto 1981</option><option value="zima 1980">zima 1980</option><option value="léto 1980">léto 1980</option></select>
//
//<input type="text" name="KOD_diskuse" value="" size="10" maxlength="10">
//
//ONLINE_A
//
//<input type="text" name="SEM_diskuse" value="" size="16" maxlength="16">
//
//A4
//
//
//
//<input type="submit" name="pridat_upr_pravo_diskuse" value="Přidat upřesněné právo">
//
//
//<input type="submit" name="nahrad_pravem_rdiskuse" value="Stejná práva jako pro čtení">
//
//
//exppar:1
//akce:edit
//guz:50462417
//predmet_id:771131
//blog:
//fakulta:1441
//obdobi:6084
//predmet:771131
//_:5241708954
//NAZEV:PdF:ONLINE_A/A4 Discussion For Points
//ZKRATKA_PRO_URL:A_4
//ZAHLAVI:<p><span>This is the forum where you can get points for discussions in English. Don't forget that you need to earn at least 100 points from posting/reacting to other posts to be eligible for credit.</span></p>
//hodnotit_body:ano
//student_mohl_nahlizet:a
//student_smi_nahlizet:a
//pocitat_slova_znaky:ano
//diskuse_posl_zmena:20140906000158
//diskuse_PRAVO_a1:i
//diskuse_PRAVO_a1_UPR:374368
//diskuse_PRAVO_a1_DAT:
//diskuse_PRAVO_r1_DAT:
//diskuse_PRAVO_r1:w
//diskuse_PRAVO_r1_UPR:
//diskuse_PRAVO_r1_DAT:
//diskuse_PRAVO_w1_DAT:
//diskuse_PRAVO_w1:w
//diskuse_PRAVO_w1_UPR:
//diskuse_PRAVO_w1_DAT:
//TYP_diskuse:r
//SUBTYP_diskuse:s
//FAK_diskuse:1441
//OBD_diskuse:podzim 2014
//KOD_diskuse:ONLINE_A
//SEM_diskuse:A4
//DATUM_diskuse:
//DATUMHM_diskuse:
//pridat_upr_pravo_diskuse:Přidat upřesněné právo
//
//
//exppar:1
//akce:edit
//guz:50462417
//predmet_id:771131
//blog:
//fakulta:1441
//obdobi:6084
//predmet:771131
//_:5241714302
//NAZEV:PdF:ONLINE_A/A4 Discussion For Points
//ZKRATKA_PRO_URL:A_4
//ZAHLAVI:<p><span>This is the forum where you can get points for discussions in English. Don't forget that you need to earn at least 100 points from posting/reacting to other posts to be eligible for credit.</span></p>
//hodnotit_body:ano
//student_mohl_nahlizet:a
//student_smi_nahlizet:a
//pocitat_slova_znaky:ano
//diskuse_posl_zmena:20140906102826
//diskuse_PRAVO_a1:i
//diskuse_PRAVO_a1_UPR:374368
//diskuse_PRAVO_a1_DAT:
//zrusit_pravo_r_diskuse:r:w:
//diskuse_PRAVO_r1_DAT:
//diskuse_PRAVO_r1:w
//diskuse_PRAVO_r1_UPR:
//diskuse_PRAVO_r1_DAT:
//diskuse_PRAVO_r2_DAT:
//diskuse_PRAVO_r2:s
//diskuse_PRAVO_r2_UPR:336459
//diskuse_PRAVO_r2_DAT:
//diskuse_PRAVO_w1_DAT:
//diskuse_PRAVO_w1:w
//diskuse_PRAVO_w1_UPR:
//diskuse_PRAVO_w1_DAT:
//zrusit_pravo_diskuse:Zrušit zaškrtnutá práva
//TYP_diskuse:r
//SUBTYP_diskuse:s
//
//
//
//
//
//
//exppar:1
//akce:edit
//guz:50462417
//predmet_id:771131
//blog:
//fakulta:1441
//obdobi:6084
//predmet:771131
//_:5241721210
//NAZEV:PdF:ONLINE_A/A4 Discussion For Points
//ZKRATKA_PRO_URL:A_4
//ZAHLAVI:<p><span>This is the forum where you can get points for discussions in English. Don't forget that you need to earn at least 100 points from posting/reacting to other posts to be eligible for credit.</span></p>
//hodnotit_body:ano
//student_mohl_nahlizet:a
//student_smi_nahlizet:a
//pocitat_slova_znaky:ano
//diskuse_posl_zmena:20140906102826
//diskuse_PRAVO_a1:i
//diskuse_PRAVO_a1_UPR:374368
//diskuse_PRAVO_a1_DAT:
//diskuse_PRAVO_r2_DAT:
//diskuse_PRAVO_r2:s
//diskuse_PRAVO_r2_UPR:336459
//diskuse_PRAVO_r2_DAT:
//diskuse_PRAVO_w2_DAT:14 12 2014 23 36
//diskuse_PRAVO_w2:s
//diskuse_PRAVO_w2_UPR:336459
//diskuse_PRAVO_w2_DAT:14 12 2014 23 36
//TYP_diskuse:a
//SUBTYP_diskuse:i
//UCO_diskuse:79615
//pridat_upr_pravo_diskuse:Přidat upřesněné právo
//
//
//
//
//
//
//
//<form method="post" action="/auth/diskuse/diskusni_forum_nastaveni.pl?fakulta=1441;obdobi=6084;predmet=771131;akce=edit;guz=50462417" enctype="application/x-www-form-urlencoded" name="diskuse_nastaveni">
//<input type="hidden" name="exppar" value="1"><input type="hidden" name="akce" value="edit"><input type="hidden" name="guz" value="50462417"><input type="hidden" name="predmet_id" value="771131"><input type="hidden" name="blog" value=""><input type="hidden" name="fakulta" value="1441"><input type="hidden" name="obdobi" value="6084"><input type="hidden" name="predmet" value="771131"><input type="hidden" name="_" value="5241693174"><h2>Editace tematického diskusního fóra uvnitř předmětu</h2><b>Název diskusního fóra</b> (povinný)<br>
//<input type="text" name="NAZEV" value="PdF:ONLINE_A/A4 Discussion For Points" size="64" maxlength="64"><p></p>
//<b>Zkratka pro url</b> (povinná)
//<span id="zobynjav" style=""><a href="#" onclick="
//switchDiv('skdynjav');
//switchSpan('zobynjav');
//switchSpan('skrynjav');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrynjav" style="display:none;"><a href="#" onclick="
//switchDiv('skdynjav');
//switchSpan('zobynjav');
//switchSpan('skrynjav');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdynjav" style="display:none;">Diskusní fórum, které má zadanou zkratku pro webovou adresu, lze najít na adrese např. https://is.muni.cz/auth/df/<b>nazev_diskuse</b>. Pokud je diskusní fórum přístupné i lidem mimo IS, je adresa http://is.muni.cz/df/<b>nazev_diskuse</b>.<br>Zkratka smí obsahovat pouze písmena bez diakritiky, číslice, znak podtržení '_' a spojovník '-', maximální délka je 14 znaků, minimální 3. V případě použití možnosti 'zapnout bodování učitelem' nelze ve zkratce použít spojovník.</div><input type="text" name="ZKRATKA_PRO_URL" value="A_4" size="14" maxlength="14"><p></p>
//<b>Záhlaví diskusního fóra</b>
//<span id="zobrhoia" style=""><a href="#" onclick="
//switchDiv('skdrhoia');
//switchSpan('zobrhoia');
//switchSpan('skrrhoia');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrrhoia" style="display:none;"><a href="#" onclick="
//switchDiv('skdrhoia');
//switchSpan('zobrhoia');
//switchSpan('skrrhoia');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdrhoia" style="display:none;">V záhlaví čtenáře fóra informujte: <ul> <li> K čemu fórum je, jaké je téma. </li> <li> Pravidla chování – míra držení se tématu ap. </li> </ul> Záhlaví se hodí pro zodpovězení často pokládaných otázek nebo pro informování o čemkoliv pro fórum důležitém. <p>Záhlaví se chová tak, že poté, co jej čtenář již viděl, se sbalí do řádečku "Informace moderátora: čtěte, než přispějete do diskuse!". Pokud se záhlaví změní, opět jej čtenář při vstupu do fóra vidí.</p></div>
//    <!-- ISMU Editor CKeditor start -->
//    <noscript>
//      &lt;P&gt;
//      &lt;FONT COLOR=red&gt;&lt;B&gt;UPOZORNĚNÍ:&lt;/B&gt; HTML editor se spustí, jen když máte v prohlížeči povolený JavaScript. &lt;BR&gt; Zapněte si nejdříve JavaScript.&lt;/FONT&gt;
//      &lt;BR&gt;
//    </noscript><script type="text/javascript" src="/htmleditor/ckeditor_4.3.1/ckeditor.js"></script><textarea id="ZAHLAVI" name="ZAHLAVI" style="visibility: hidden; display: none;">&lt;p&gt;&lt;span&gt;This is the forum where you can get points for discussions in English. Don't forget that you need to earn at least 100 points from posting/reacting to other posts to be eligible for credit.&lt;/span&gt; &lt;/p&gt;</textarea><div id="cke_ZAHLAVI" class="cke_1 cke cke_reset cke_chrome cke_editor_ZAHLAVI cke_ltr cke_browser_webkit cke_browser_quirks" dir="ltr" lang="cs" role="application" aria-labelledby="cke_ZAHLAVI_arialbl"><span id="cke_ZAHLAVI_arialbl" class="cke_voice_label">Textový editor, ZAHLAVI</span><div class="cke_inner cke_reset" role="presentation"><span id="cke_1_top" class="cke_top cke_reset_all" role="presentation" style="height: auto; -webkit-user-select: none;"><span id="cke_9" class="cke_voice_label">Panely nástrojů editoru</span><span id="cke_1_toolbox" class="cke_toolbox" role="group" aria-labelledby="cke_9" onmousedown="return false;"><span id="cke_10" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_11" class="cke_button cke_button__source  cke_button_off" href="javascript:void('Zdroj')" title="Zdroj" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_11_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(2,event);" onfocus="return CKEDITOR.tools.callFunction(3,event);" onmousedown="return CKEDITOR.tools.callFunction(4,event);" onclick="CKEDITOR.tools.callFunction(5,this);return false;"><span class="cke_button_icon cke_button__source_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1824px;background-size:auto;">&nbsp;</span><span id="cke_11_label" class="cke_button_label cke_button__source_label" aria-hidden="false">Zdroj</span></a><span class="cke_toolbar_separator" role="separator"></span><a id="cke_12" class="cke_button cke_button__preview  cke_button_off" href="javascript:void('Náhled')" title="Náhled" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_12_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(6,event);" onfocus="return CKEDITOR.tools.callFunction(7,event);" onmousedown="return CKEDITOR.tools.callFunction(8,event);" onclick="CKEDITOR.tools.callFunction(9,this);return false;"><span class="cke_button_icon cke_button__preview_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1632px;background-size:auto;">&nbsp;</span><span id="cke_12_label" class="cke_button_label cke_button__preview_label" aria-hidden="false">Náhled</span></a></span><span class="cke_toolbar_end"></span></span><span id="cke_13" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_14" class="cke_button cke_button__cut cke_button_disabled " href="javascript:void('Vyjmout')" title="Vyjmout" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_14_label" aria-haspopup="false" aria-disabled="true" onkeydown="return CKEDITOR.tools.callFunction(10,event);" onfocus="return CKEDITOR.tools.callFunction(11,event);" onmousedown="return CKEDITOR.tools.callFunction(12,event);" onclick="CKEDITOR.tools.callFunction(13,this);return false;"><span class="cke_button_icon cke_button__cut_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -312px;background-size:auto;">&nbsp;</span><span id="cke_14_label" class="cke_button_label cke_button__cut_label" aria-hidden="false">Vyjmout</span></a><a id="cke_15" class="cke_button cke_button__copy cke_button_disabled " href="javascript:void('Kopírovat')" title="Kopírovat" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_15_label" aria-haspopup="false" aria-disabled="true" onkeydown="return CKEDITOR.tools.callFunction(14,event);" onfocus="return CKEDITOR.tools.callFunction(15,event);" onmousedown="return CKEDITOR.tools.callFunction(16,event);" onclick="CKEDITOR.tools.callFunction(17,this);return false;"><span class="cke_button_icon cke_button__copy_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -264px;background-size:auto;">&nbsp;</span><span id="cke_15_label" class="cke_button_label cke_button__copy_label" aria-hidden="false">Kopírovat</span></a><a id="cke_16" class="cke_button cke_button__paste  cke_button_off" href="javascript:void('Vložit')" title="Vložit" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_16_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(18,event);" onfocus="return CKEDITOR.tools.callFunction(19,event);" onmousedown="return CKEDITOR.tools.callFunction(20,event);" onclick="CKEDITOR.tools.callFunction(21,this);return false;"><span class="cke_button_icon cke_button__paste_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -360px;background-size:auto;">&nbsp;</span><span id="cke_16_label" class="cke_button_label cke_button__paste_label" aria-hidden="false">Vložit</span></a><a id="cke_17" class="cke_button cke_button__pastetext  cke_button_off" href="javascript:void('Vložit jako čistý text')" title="Vložit jako čistý text" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_17_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(22,event);" onfocus="return CKEDITOR.tools.callFunction(23,event);" onmousedown="return CKEDITOR.tools.callFunction(24,event);" onclick="CKEDITOR.tools.callFunction(25,this);return false;"><span class="cke_button_icon cke_button__pastetext_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1536px;background-size:auto;">&nbsp;</span><span id="cke_17_label" class="cke_button_label cke_button__pastetext_label" aria-hidden="false">Vložit jako čistý text</span></a><a id="cke_18" class="cke_button cke_button__pastefromword  cke_button_off" href="javascript:void('Vložit z Wordu')" title="Vložit z Wordu" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_18_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(26,event);" onfocus="return CKEDITOR.tools.callFunction(27,event);" onmousedown="return CKEDITOR.tools.callFunction(28,event);" onclick="CKEDITOR.tools.callFunction(29,this);return false;"><span class="cke_button_icon cke_button__pastefromword_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1584px;background-size:auto;">&nbsp;</span><span id="cke_18_label" class="cke_button_label cke_button__pastefromword_label" aria-hidden="false">Vložit z Wordu</span></a></span><span class="cke_toolbar_end"></span></span><span id="cke_19" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_20" class="cke_button cke_button__undo cke_button_disabled " href="javascript:void('Zpět')" title="Zpět" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_20_label" aria-haspopup="false" aria-disabled="true" onkeydown="return CKEDITOR.tools.callFunction(30,event);" onfocus="return CKEDITOR.tools.callFunction(31,event);" onmousedown="return CKEDITOR.tools.callFunction(32,event);" onclick="CKEDITOR.tools.callFunction(33,this);return false;"><span class="cke_button_icon cke_button__undo_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1992px;background-size:auto;">&nbsp;</span><span id="cke_20_label" class="cke_button_label cke_button__undo_label" aria-hidden="false">Zpět</span></a><a id="cke_21" class="cke_button cke_button__redo cke_button_disabled " href="javascript:void('Znovu')" title="Znovu" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_21_label" aria-haspopup="false" aria-disabled="true" onkeydown="return CKEDITOR.tools.callFunction(34,event);" onfocus="return CKEDITOR.tools.callFunction(35,event);" onmousedown="return CKEDITOR.tools.callFunction(36,event);" onclick="CKEDITOR.tools.callFunction(37,this);return false;"><span class="cke_button_icon cke_button__redo_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1944px;background-size:auto;">&nbsp;</span><span id="cke_21_label" class="cke_button_label cke_button__redo_label" aria-hidden="false">Znovu</span></a><span class="cke_toolbar_separator" role="separator"></span><a id="cke_22" class="cke_button cke_button__find  cke_button_off" href="javascript:void('Hledat')" title="Hledat" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_22_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(38,event);" onfocus="return CKEDITOR.tools.callFunction(39,event);" onmousedown="return CKEDITOR.tools.callFunction(40,event);" onclick="CKEDITOR.tools.callFunction(41,this);return false;"><span class="cke_button_icon cke_button__find_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -528px;background-size:auto;">&nbsp;</span><span id="cke_22_label" class="cke_button_label cke_button__find_label" aria-hidden="false">Hledat</span></a><a id="cke_23" class="cke_button cke_button__replace  cke_button_off" href="javascript:void('Nahradit')" title="Nahradit" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_23_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(42,event);" onfocus="return CKEDITOR.tools.callFunction(43,event);" onmousedown="return CKEDITOR.tools.callFunction(44,event);" onclick="CKEDITOR.tools.callFunction(45,this);return false;"><span class="cke_button_icon cke_button__replace_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -552px;background-size:auto;">&nbsp;</span><span id="cke_23_label" class="cke_button_label cke_button__replace_label" aria-hidden="false">Nahradit</span></a><span class="cke_toolbar_separator" role="separator"></span><a id="cke_24" class="cke_button cke_button__selectall  cke_button_off" href="javascript:void('Vybrat vše')" title="Vybrat vše" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_24_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(46,event);" onfocus="return CKEDITOR.tools.callFunction(47,event);" onmousedown="return CKEDITOR.tools.callFunction(48,event);" onclick="CKEDITOR.tools.callFunction(49,this);return false;"><span class="cke_button_icon cke_button__selectall_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1728px;background-size:auto;">&nbsp;</span><span id="cke_24_label" class="cke_button_label cke_button__selectall_label" aria-hidden="false">Vybrat vše</span></a><a id="cke_25" class="cke_button cke_button__removeformat  cke_button_off" href="javascript:void('Odstranit formátování')" title="Odstranit formátování" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_25_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(50,event);" onfocus="return CKEDITOR.tools.callFunction(51,event);" onmousedown="return CKEDITOR.tools.callFunction(52,event);" onclick="CKEDITOR.tools.callFunction(53,this);return false;"><span class="cke_button_icon cke_button__removeformat_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1680px;background-size:auto;">&nbsp;</span><span id="cke_25_label" class="cke_button_label cke_button__removeformat_label" aria-hidden="false">Odstranit formátování</span></a><a id="cke_26" class="cke_button cke_button__showblocks  cke_button_off" href="javascript:void('Ukázat bloky')" title="Ukázat bloky" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_26_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(54,event);" onfocus="return CKEDITOR.tools.callFunction(55,event);" onmousedown="return CKEDITOR.tools.callFunction(56,event);" onclick="CKEDITOR.tools.callFunction(57,this);return false;"><span class="cke_button_icon cke_button__showblocks_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1776px;background-size:auto;">&nbsp;</span><span id="cke_26_label" class="cke_button_label cke_button__showblocks_label" aria-hidden="false">Ukázat bloky</span></a></span><span class="cke_toolbar_end"></span></span><span id="cke_27" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_28" class="cke_button cke_button__image  cke_button_off" href="javascript:void('Obrázek')" title="Obrázek" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_28_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(58,event);" onfocus="return CKEDITOR.tools.callFunction(59,event);" onmousedown="return CKEDITOR.tools.callFunction(60,event);" onclick="CKEDITOR.tools.callFunction(61,this);return false;"><span class="cke_button_icon cke_button__image_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -936px;background-size:auto;">&nbsp;</span><span id="cke_28_label" class="cke_button_label cke_button__image_label" aria-hidden="false">Obrázek</span></a><a id="cke_29" class="cke_button cke_button__table  cke_button_off" href="javascript:void('Tabulka')" title="Tabulka" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_29_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(62,event);" onfocus="return CKEDITOR.tools.callFunction(63,event);" onmousedown="return CKEDITOR.tools.callFunction(64,event);" onclick="CKEDITOR.tools.callFunction(65,this);return false;"><span class="cke_button_icon cke_button__table_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1896px;background-size:auto;">&nbsp;</span><span id="cke_29_label" class="cke_button_label cke_button__table_label" aria-hidden="false">Tabulka</span></a><a id="cke_30" class="cke_button cke_button__horizontalrule  cke_button_off" href="javascript:void('Vložit vodorovnou linku')" title="Vložit vodorovnou linku" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_30_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(66,event);" onfocus="return CKEDITOR.tools.callFunction(67,event);" onmousedown="return CKEDITOR.tools.callFunction(68,event);" onclick="CKEDITOR.tools.callFunction(69,this);return false;"><span class="cke_button_icon cke_button__horizontalrule_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -888px;background-size:auto;">&nbsp;</span><span id="cke_30_label" class="cke_button_label cke_button__horizontalrule_label" aria-hidden="false">Vložit vodorovnou linku</span></a><a id="cke_31" class="cke_button cke_button__specialchar  cke_button_off" href="javascript:void('Vložit speciální znaky')" title="Vložit speciální znaky" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_31_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(70,event);" onfocus="return CKEDITOR.tools.callFunction(71,event);" onmousedown="return CKEDITOR.tools.callFunction(72,event);" onclick="CKEDITOR.tools.callFunction(73,this);return false;"><span class="cke_button_icon cke_button__specialchar_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1848px;background-size:auto;">&nbsp;</span><span id="cke_31_label" class="cke_button_label cke_button__specialchar_label" aria-hidden="false">Vložit speciální znaky</span></a></span><span class="cke_toolbar_end"></span></span><span class="cke_toolbar_break"></span><span id="cke_32" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_33" class="cke_button cke_button__bold  cke_button_off" href="javascript:void('Tučné')" title="Tučné" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_33_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(74,event);" onfocus="return CKEDITOR.tools.callFunction(75,event);" onmousedown="return CKEDITOR.tools.callFunction(76,event);" onclick="CKEDITOR.tools.callFunction(77,this);return false;"><span class="cke_button_icon cke_button__bold_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -24px;background-size:auto;">&nbsp;</span><span id="cke_33_label" class="cke_button_label cke_button__bold_label" aria-hidden="false">Tučné</span></a><a id="cke_34" class="cke_button cke_button__italic  cke_button_off" href="javascript:void('Kurzíva')" title="Kurzíva" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_34_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(78,event);" onfocus="return CKEDITOR.tools.callFunction(79,event);" onmousedown="return CKEDITOR.tools.callFunction(80,event);" onclick="CKEDITOR.tools.callFunction(81,this);return false;"><span class="cke_button_icon cke_button__italic_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -48px;background-size:auto;">&nbsp;</span><span id="cke_34_label" class="cke_button_label cke_button__italic_label" aria-hidden="false">Kurzíva</span></a><a id="cke_35" class="cke_button cke_button__underline  cke_button_off" href="javascript:void('Podtržené')" title="Podtržené" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_35_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(82,event);" onfocus="return CKEDITOR.tools.callFunction(83,event);" onmousedown="return CKEDITOR.tools.callFunction(84,event);" onclick="CKEDITOR.tools.callFunction(85,this);return false;"><span class="cke_button_icon cke_button__underline_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -144px;background-size:auto;">&nbsp;</span><span id="cke_35_label" class="cke_button_label cke_button__underline_label" aria-hidden="false">Podtržené</span></a><a id="cke_36" class="cke_button cke_button__strike  cke_button_off" href="javascript:void('Přeškrtnuté')" title="Přeškrtnuté" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_36_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(86,event);" onfocus="return CKEDITOR.tools.callFunction(87,event);" onmousedown="return CKEDITOR.tools.callFunction(88,event);" onclick="CKEDITOR.tools.callFunction(89,this);return false;"><span class="cke_button_icon cke_button__strike_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -72px;background-size:auto;">&nbsp;</span><span id="cke_36_label" class="cke_button_label cke_button__strike_label" aria-hidden="false">Přeškrtnuté</span></a><a id="cke_37" class="cke_button cke_button__subscript  cke_button_off" href="javascript:void('Dolní index')" title="Dolní index" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_37_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(90,event);" onfocus="return CKEDITOR.tools.callFunction(91,event);" onmousedown="return CKEDITOR.tools.callFunction(92,event);" onclick="CKEDITOR.tools.callFunction(93,this);return false;"><span class="cke_button_icon cke_button__subscript_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -96px;background-size:auto;">&nbsp;</span><span id="cke_37_label" class="cke_button_label cke_button__subscript_label" aria-hidden="false">Dolní index</span></a><a id="cke_38" class="cke_button cke_button__superscript  cke_button_off" href="javascript:void('Horní index')" title="Horní index" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_38_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(94,event);" onfocus="return CKEDITOR.tools.callFunction(95,event);" onmousedown="return CKEDITOR.tools.callFunction(96,event);" onclick="CKEDITOR.tools.callFunction(97,this);return false;"><span class="cke_button_icon cke_button__superscript_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -120px;background-size:auto;">&nbsp;</span><span id="cke_38_label" class="cke_button_label cke_button__superscript_label" aria-hidden="false">Horní index</span></a></span><span class="cke_toolbar_end"></span></span><span id="cke_39" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_40" class="cke_button cke_button__numberedlist  cke_button_off" href="javascript:void('Číslování')" title="Číslování" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_40_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(98,event);" onfocus="return CKEDITOR.tools.callFunction(99,event);" onmousedown="return CKEDITOR.tools.callFunction(100,event);" onclick="CKEDITOR.tools.callFunction(101,this);return false;"><span class="cke_button_icon cke_button__numberedlist_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1368px;background-size:auto;">&nbsp;</span><span id="cke_40_label" class="cke_button_label cke_button__numberedlist_label" aria-hidden="false">Číslování</span></a><a id="cke_41" class="cke_button cke_button__bulletedlist  cke_button_off" href="javascript:void('Odrážky')" title="Odrážky" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_41_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(102,event);" onfocus="return CKEDITOR.tools.callFunction(103,event);" onmousedown="return CKEDITOR.tools.callFunction(104,event);" onclick="CKEDITOR.tools.callFunction(105,this);return false;"><span class="cke_button_icon cke_button__bulletedlist_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1320px;background-size:auto;">&nbsp;</span><span id="cke_41_label" class="cke_button_label cke_button__bulletedlist_label" aria-hidden="false">Odrážky</span></a><span class="cke_toolbar_separator" role="separator"></span><a id="cke_42" class="cke_button cke_button__outdent cke_button_disabled " href="javascript:void('Zmenšit odsazení')" title="Zmenšit odsazení" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_42_label" aria-haspopup="false" aria-disabled="true" onkeydown="return CKEDITOR.tools.callFunction(106,event);" onfocus="return CKEDITOR.tools.callFunction(107,event);" onmousedown="return CKEDITOR.tools.callFunction(108,event);" onclick="CKEDITOR.tools.callFunction(109,this);return false;"><span class="cke_button_icon cke_button__outdent_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1032px;background-size:auto;">&nbsp;</span><span id="cke_42_label" class="cke_button_label cke_button__outdent_label" aria-hidden="false">Zmenšit odsazení</span></a><a id="cke_43" class="cke_button cke_button__indent  cke_button_off" href="javascript:void('Zvětšit odsazení')" title="Zvětšit odsazení" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_43_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(110,event);" onfocus="return CKEDITOR.tools.callFunction(111,event);" onmousedown="return CKEDITOR.tools.callFunction(112,event);" onclick="CKEDITOR.tools.callFunction(113,this);return false;"><span class="cke_button_icon cke_button__indent_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -984px;background-size:auto;">&nbsp;</span><span id="cke_43_label" class="cke_button_label cke_button__indent_label" aria-hidden="false">Zvětšit odsazení</span></a><a id="cke_44" class="cke_button cke_button__blockquote  cke_button_off" href="javascript:void('Citace')" title="Citace" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_44_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(114,event);" onfocus="return CKEDITOR.tools.callFunction(115,event);" onmousedown="return CKEDITOR.tools.callFunction(116,event);" onclick="CKEDITOR.tools.callFunction(117,this);return false;"><span class="cke_button_icon cke_button__blockquote_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -216px;background-size:auto;">&nbsp;</span><span id="cke_44_label" class="cke_button_label cke_button__blockquote_label" aria-hidden="false">Citace</span></a></span><span class="cke_toolbar_end"></span></span><span id="cke_45" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_46" class="cke_button cke_button__justifyleft cke_button_on" href="javascript:void('Zarovnat vlevo')" title="Zarovnat vlevo" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_46_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(118,event);" onfocus="return CKEDITOR.tools.callFunction(119,event);" onmousedown="return CKEDITOR.tools.callFunction(120,event);" onclick="CKEDITOR.tools.callFunction(121,this);return false;" aria-pressed="true"><span class="cke_button_icon cke_button__justifyleft_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1128px;background-size:auto;">&nbsp;</span><span id="cke_46_label" class="cke_button_label cke_button__justifyleft_label" aria-hidden="false">Zarovnat vlevo</span></a><a id="cke_47" class="cke_button cke_button__justifycenter  cke_button_off" href="javascript:void('Zarovnat na střed')" title="Zarovnat na střed" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_47_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(122,event);" onfocus="return CKEDITOR.tools.callFunction(123,event);" onmousedown="return CKEDITOR.tools.callFunction(124,event);" onclick="CKEDITOR.tools.callFunction(125,this);return false;"><span class="cke_button_icon cke_button__justifycenter_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1104px;background-size:auto;">&nbsp;</span><span id="cke_47_label" class="cke_button_label cke_button__justifycenter_label" aria-hidden="false">Zarovnat na střed</span></a><a id="cke_48" class="cke_button cke_button__justifyright  cke_button_off" href="javascript:void('Zarovnat vpravo')" title="Zarovnat vpravo" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_48_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(126,event);" onfocus="return CKEDITOR.tools.callFunction(127,event);" onmousedown="return CKEDITOR.tools.callFunction(128,event);" onclick="CKEDITOR.tools.callFunction(129,this);return false;"><span class="cke_button_icon cke_button__justifyright_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1152px;background-size:auto;">&nbsp;</span><span id="cke_48_label" class="cke_button_label cke_button__justifyright_label" aria-hidden="false">Zarovnat vpravo</span></a><a id="cke_49" class="cke_button cke_button__justifyblock  cke_button_off" href="javascript:void('Zarovnat do bloku')" title="Zarovnat do bloku" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_49_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(130,event);" onfocus="return CKEDITOR.tools.callFunction(131,event);" onmousedown="return CKEDITOR.tools.callFunction(132,event);" onclick="CKEDITOR.tools.callFunction(133,this);return false;"><span class="cke_button_icon cke_button__justifyblock_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1080px;background-size:auto;">&nbsp;</span><span id="cke_49_label" class="cke_button_label cke_button__justifyblock_label" aria-hidden="false">Zarovnat do bloku</span></a></span><span class="cke_toolbar_end"></span></span><span id="cke_50" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_51" class="cke_button cke_button__link  cke_button_off" href="javascript:void('Odkaz')" title="Odkaz" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_51_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(134,event);" onfocus="return CKEDITOR.tools.callFunction(135,event);" onmousedown="return CKEDITOR.tools.callFunction(136,event);" onclick="CKEDITOR.tools.callFunction(137,this);return false;"><span class="cke_button_icon cke_button__link_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1248px;background-size:auto;">&nbsp;</span><span id="cke_51_label" class="cke_button_label cke_button__link_label" aria-hidden="false">Odkaz</span></a><a id="cke_52" class="cke_button cke_button__unlink cke_button_disabled " href="javascript:void('Odstranit odkaz')" title="Odstranit odkaz" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_52_label" aria-haspopup="false" aria-disabled="true" onkeydown="return CKEDITOR.tools.callFunction(138,event);" onfocus="return CKEDITOR.tools.callFunction(139,event);" onmousedown="return CKEDITOR.tools.callFunction(140,event);" onclick="CKEDITOR.tools.callFunction(141,this);return false;"><span class="cke_button_icon cke_button__unlink_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1272px;background-size:auto;">&nbsp;</span><span id="cke_52_label" class="cke_button_label cke_button__unlink_label" aria-hidden="false">Odstranit odkaz</span></a><a id="cke_53" class="cke_button cke_button__anchor  cke_button_off" href="javascript:void('Záložka')" title="Záložka" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_53_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(142,event);" onfocus="return CKEDITOR.tools.callFunction(143,event);" onmousedown="return CKEDITOR.tools.callFunction(144,event);" onclick="CKEDITOR.tools.callFunction(145,this);return false;"><span class="cke_button_icon cke_button__anchor_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1224px;background-size:auto;">&nbsp;</span><span id="cke_53_label" class="cke_button_label cke_button__anchor_label" aria-hidden="false">Záložka</span></a></span><span class="cke_toolbar_end"></span></span><span id="cke_54" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_55" class="cke_button cke_button__maximize  cke_button_off" href="javascript:void('Maximalizovat')" title="Maximalizovat" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_55_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(146,event);" onfocus="return CKEDITOR.tools.callFunction(147,event);" onmousedown="return CKEDITOR.tools.callFunction(148,event);" onclick="CKEDITOR.tools.callFunction(149,this);return false;"><span class="cke_button_icon cke_button__maximize_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 -1392px;background-size:auto;">&nbsp;</span><span id="cke_55_label" class="cke_button_label cke_button__maximize_label" aria-hidden="false">Maximalizovat</span></a></span><span class="cke_toolbar_end"></span></span><span id="cke_56" class="cke_toolbar" role="toolbar"><span class="cke_toolbar_start"></span><span class="cke_toolgroup" role="presentation"><a id="cke_57" class="cke_button cke_button__about  cke_button_off" href="javascript:void('O aplikaci CKEditor')" title="O aplikaci CKEditor" tabindex="-1" hidefocus="true" role="button" aria-labelledby="cke_57_label" aria-haspopup="false" onkeydown="return CKEDITOR.tools.callFunction(150,event);" onfocus="return CKEDITOR.tools.callFunction(151,event);" onmousedown="return CKEDITOR.tools.callFunction(152,event);" onclick="CKEDITOR.tools.callFunction(153,this);return false;"><span class="cke_button_icon cke_button__about_icon" style="background-image:url(https://is.muni.cz/htmleditor/ckeditor_4.3.1/plugins/icons.png?t=DBAA);background-position:0 0px;background-size:auto;">&nbsp;</span><span id="cke_57_label" class="cke_button_label cke_button__about_label" aria-hidden="false">O aplikaci CKEditor</span></a></span><span class="cke_toolbar_end"></span></span></span></span><div id="cke_1_contents" class="cke_contents cke_reset" role="presentation" style="height: 250px;"><span id="cke_62" class="cke_voice_label">Stiskněte ALT 0 pro nápovědu</span><iframe src="" frameborder="0" class="cke_wysiwyg_frame cke_reset" style="width: 1429px; height: 100%;" title="Textový editor, ZAHLAVI" aria-describedby="cke_62" tabindex="0" allowtransparency="true"></iframe></div><span id="cke_1_bottom" class="cke_bottom cke_reset_all" role="presentation" style="-webkit-user-select: none;"><span id="cke_1_resizer" class="cke_resizer cke_resizer_vertical cke_resizer_ltr" title="Uchopit pro změnu velikosti" onmousedown="CKEDITOR.tools.callFunction(0, event)">◢</span><span id="cke_1_path_label" class="cke_voice_label">Cesta objektu</span><span id="cke_1_path" class="cke_path" role="group" aria-labelledby="cke_1_path_label"><a id="cke_elementspath_8_2" href="javascript:void('body')" tabindex="-1" class="cke_path_item" title="body objekt" hidefocus="true" onkeydown="return CKEDITOR.tools.callFunction(155,2, event );" onclick="CKEDITOR.tools.callFunction(154,2); return false;" role="button" aria-label="body objekt">body</a><a id="cke_elementspath_8_1" href="javascript:void('p')" tabindex="-1" class="cke_path_item" title="p objekt" hidefocus="true" onkeydown="return CKEDITOR.tools.callFunction(155,1, event );" onclick="CKEDITOR.tools.callFunction(154,1); return false;" role="button" aria-label="p objekt">p</a><a id="cke_elementspath_8_0" href="javascript:void('span')" tabindex="-1" class="cke_path_item" title="span objekt" hidefocus="true" onkeydown="return CKEDITOR.tools.callFunction(155,0, event );" onclick="CKEDITOR.tools.callFunction(154,0); return false;" role="button" aria-label="span objekt">span</a><span class="cke_path_empty">&nbsp;</span></span></span></div></div>
//      <script type="text/javascript">
//      CKEDITOR.replace( 'ZAHLAVI', {
//            filebrowserBrowseUrl : '/auth/dok/sfmgr.pl?design=0;htmle=1;pref=a;furl=/www/374368',
//            filebrowserImageBrowseLinkUrl : '/auth/dok/sfmgr.pl?design=0;htmle=1;pref=a;furl=/www/374368',
//            filebrowserImageBrowseUrl : '/auth/dok/sfmgr.pl?only_img=1;design=0;htmle=1;pref=a;furl=/www/374368',
//              toolbar: 'ISMUToolbar',
//  language: 'cs',
//  skin: 'kama',
//  height: '250px'
//
//            });
//      CKEDITOR.instances.ZAHLAVI.on( 'instanceReady', function( ev ) {
//        var obsah = ev.editor.getData();
//        var new_obsah = obsah.replace(/(<p>\&nbsp;<\/p>\n*\s*\n*\s*){2,}/ig,"<p>\&nbsp;<\/p><p>\&nbsp;<\/p>");
//        ev.editor.setData(new_obsah);
//      });
//      </script>
//      <div class="ed-help" align="right"><font size="-2"><a href="/auth/help/elearning/editor_html?fakulta=1441;obdobi=6084;predmet=771131" target="_blank" class="okno"><img src="/pics/fmgr/ik_help_red_small.gif" width="11" height="11" border="0"></a> <a href="/auth/help/elearning/editor_html?fakulta=1441;obdobi=6084;predmet=771131" target="_blank" class="okno">nápověda</a> | nastavit editor <a href="/auth/system/htmleditor_set.pl?fakulta=1441;obdobi=6084;predmet=771131" target="_blank" class="okno">Systém --&gt; Nastavení HTML editoru</a></font></div><!-- ISMU Editor CKeditor konec --><div align="right"><input type="submit" name="textarea" value="textový editor"></div><p><b>Hodnocení příspěvků</b></p>
//<label onclick="bodovani()"><input type="checkbox" name="hodnotit_body" value="ano" checked=""> zapnout bodování</label>
//<span id="zobhuvjq" style=""><a href="#" onclick="
//switchDiv('skdhuvjq');
//switchSpan('zobhuvjq');
//switchSpan('skrhuvjq');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrhuvjq" style="display:none;"><a href="#" onclick="
//switchDiv('skdhuvjq');
//switchSpan('zobhuvjq');
//switchSpan('skrhuvjq');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdhuvjq" style="display:none;">U příspěvků se objeví textové políčko pro vepsání počtu bodů – tento údaj se uloží do poznámkového bloku se shodným názvem jako má název fóra. V případe použití této možnosti není možné ve zkratce fóra použít spojovník. Kromě vyučujících předmětu mohou také příspěvky bodovat moderátoři fóra.</div><input type="hidden" name="student_mohl_nahlizet" value="a"><div class="odsazeni"><p><label><input type="checkbox" name="student_smi_nahlizet" value="a" checked=""> student smí do bloku nahlížet </label>
//<span id="zobaxjhx" style=""><a href="#" onclick="
//switchDiv('skdaxjhx');
//switchSpan('zobaxjhx');
//switchSpan('skraxjhx');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skraxjhx" style="display:none;"><a href="#" onclick="
//switchDiv('skdaxjhx');
//switchSpan('zobaxjhx');
//switchSpan('skraxjhx');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//</p><div class="navodek" id="skdaxjhx" style="display:none;">Umožňuje studentům vidět body u svých příspěvků a v poznámkovém bloku.<p></p></div></div><script language="JavaScript" type="text/javascript">
//        function bodovani() {
//          var hodnotit_body = document.getElementsByName("hodnotit_body")[0];
//          var student_smi_nahlizet = document.getElementsByName("student_smi_nahlizet")[0];
//
//          if (hodnotit_body.checked==true) {
//            student_smi_nahlizet.disabled = false;
//            student_smi_nahlizet.checked = true;
//          } else {
//            student_smi_nahlizet.disabled = true;
//          }
//        }</script><label><input type="checkbox" name="vypnuto_hodnoceni" value="ano"> vypnout slovní hodnocení čtenáři navzájem</label>
//<span id="zobgonda" style=""><a href="#" onclick="
//switchDiv('skdgonda');
//switchSpan('zobgonda');
//switchSpan('skrgonda');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrgonda" style="display:none;"><a href="#" onclick="
//switchDiv('skdgonda');
//switchSpan('zobgonda');
//switchSpan('skrgonda');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdgonda" style="display:none;">Implicitně čtenáři mohou k příspěvkům zaujmout jednoduchý postoj výběrem z menu slovních hodnocení (např. Zajímavé, Otravné, ...). Slovní hodnocení má sloužit k vyfiltrování kvalitnějších příspěvků.</div><p><b>Omezení čtení a přispívání</b></p>
//<label><input type="checkbox" name="cist_az_po_vlozeni" value="ano"> číst fórum lze až poté, co osoba sama přispěje alespoň jedním příspěvkem</label>
//<span id="zobrerks" style=""><a href="#" onclick="
//switchDiv('skdrerks');
//switchSpan('zobrerks');
//switchSpan('skrrerks');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrrerks" style="display:none;"><a href="#" onclick="
//switchDiv('skdrerks');
//switchSpan('zobrerks');
//switchSpan('skrrerks');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdrerks" style="display:none;">Někdy učitel nechce, aby studenti byli ovlivněni názory spolužáků.</div><label><input type="checkbox" name="kazdy_max_1" value="ano"> každý může vložit maximálně jeden příspěvek</label>
//<span id="zobeqlzv" style=""><a href="#" onclick="
//switchDiv('skdeqlzv');
//switchSpan('zobeqlzv');
//switchSpan('skreqlzv');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skreqlzv" style="display:none;"><a href="#" onclick="
//switchDiv('skdeqlzv');
//switchSpan('zobeqlzv');
//switchSpan('skreqlzv');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdeqlzv" style="display:none;">Někdy chce učitel začít diskusi posbíráním právě jednoho příspěvku od každého studenta. Dokud je nastavena tato volba, lze vložit pouze jeden nový příspěvek a nelze reagovat na cizí. Na moderátora fóra se omezení nevztahuje. Po určité době učitel typicky režim změní a nechá diskusi proudit volněji.</div><label><input type="checkbox" name="prispivat_pod_topuzel" value="ano"> pouze vkládat nové příspěvky, nelze reagovat na cizí</label>
//<span id="zobigiap" style=""><a href="#" onclick="
//switchDiv('skdigiap');
//switchSpan('zobigiap');
//switchSpan('skrigiap');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrigiap" style="display:none;"><a href="#" onclick="
//switchDiv('skdigiap');
//switchSpan('zobigiap');
//switchSpan('skrigiap');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdigiap" style="display:none;">Tato volba zamezí větvení diskuse, fórum je lineární proud příspěvků za sebou, účastníci fóra nemají k dispozici volbu 'reagovat'. Moderátor fóra může reagovat.</div><label><input type="checkbox" name="pouze_reagovat" value="ano"> lze pouze reagovat, nelze vkládat nové příspěvky</label>
//<span id="zobomugk" style=""><a href="#" onclick="
//switchDiv('skdomugk');
//switchSpan('zobomugk');
//switchSpan('skromugk');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skromugk" style="display:none;"><a href="#" onclick="
//switchDiv('skdomugk');
//switchSpan('zobomugk');
//switchSpan('skromugk');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdomugk" style="display:none;">Tato volba zamezí narušení struktury vytvořené moderátory, kterou způsobí ostatní přispěvatelé vytvářením nových vláken.</div><label><input type="checkbox" name="institucionalni_regulace" value="ano"> zapnout dotazník s testem pravidel</label>
//<span id="zobctlcm" style=""><a href="#" onclick="
//switchDiv('skdctlcm');
//switchSpan('zobctlcm');
//switchSpan('skrctlcm');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrctlcm" style="display:none;"><a href="#" onclick="
//switchDiv('skdctlcm');
//switchSpan('zobctlcm');
//switchSpan('skrctlcm');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdctlcm" style="display:none;">Chcete-li ve fóru omezit chat, zapněte v něm krátký dotazník, který musí vkládající vyklikat před vložením příspěvku.</div><label><input type="checkbox" name="anonymni" value="ano"> fórum je anonymní</label>
//<span id="zobfklbg" style=""><a href="#" onclick="
//switchDiv('skdfklbg');
//switchSpan('zobfklbg');
//switchSpan('skrfklbg');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrfklbg" style="display:none;"><a href="#" onclick="
//switchDiv('skdfklbg');
//switchSpan('zobfklbg');
//switchSpan('skrfklbg');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdfklbg" style="display:none;">Čtenáři (kromě moderátorů fóra) nevidí identitu vkládajících (až na identitu moderátorů).</div><p><b>Ostatní</b></p>
//<label><input type="checkbox" name="plkarnova_expirace" value="ano"> aplikovat plkárnovou expiraci</label>
//<span id="zobxvcpy" style=""><a href="#" onclick="
//switchDiv('skdxvcpy');
//switchSpan('zobxvcpy');
//switchSpan('skrxvcpy');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-plus.png" alt="Zobrazit popisek" title="Zobrazit popisek" width="16" height="16" class="ico-navodek"></a><br></span><span id="skrxvcpy" style="display:none;"><a href="#" onclick="
//switchDiv('skdxvcpy');
//switchSpan('zobxvcpy');
//switchSpan('skrxvcpy');
//
//return false;
//        "><img src="/pics/design/14/b/ico/navodek-minus.png" alt="Skrýt popisek" title="Skrýt popisek" width="16" height="16" class="ico-navodek"></a></span>
//<div class="navodek" id="skdxvcpy" style="display:none;">Použije se typ expirace aplikovaný na plkárny.</div><label><input type="checkbox" name="pocitat_slova_znaky" value="ano" checked=""> u příspěvku zobrazit počet znaků a slov</label><br>
//<h3>Kdo fórum moderuje, čte, může do něj psát</h3>
//<input type="hidden" name="diskuse_posl_zmena" value="20140906000158"><h4>Moderátoři</h4>
//<table class="data1" border="" style="text-align:center;">
//<tbody><tr>
//<th>Zruš</th>
//<th>Typ práva</th>
//<th>Upřesnění</th>
//
//<th>Již uložené</th>
//</tr>
//
//<tr>
//<td><input type="checkbox" name="zrusit_pravo_a_diskuse" value="a:i:374368"></td>
//<td>osoba</td>
//<td>Jiří Daněk, učo 374368</td>
//      
//<td>ano</td>
//</tr>
//      <input type="hidden" name="diskuse_PRAVO_a1" value="i"><input type="hidden" name="diskuse_PRAVO_a1_UPR" value="374368"><input type="hidden" name="diskuse_PRAVO_a1_DAT" value="">
//</tbody></table><h4>Právo číst</h4>
//<table class="data1" border="" style="text-align:center;">
//<tbody><tr>
//<th>Zruš</th>
//<th>Typ práva</th>
//<th>Upřesnění</th>
//<th>Od kdy se uplatní</th>
//<th>Již uložené</th>
//</tr>
//
//<tr>
//<td><input type="checkbox" name="zrusit_pravo_r_diskuse" value="r:w:"></td>
//<td>kdokoliv přihlášený v ISu</td>
//<td>&nbsp;</td>
//      <td><style type="text/css">@import url(/htmlcalendar/jscalendar-1.0/calendar-win2k-1.css);</style><script type="text/javascript" src="/htmlcalendar/jscalendar-1.0/calendar.js"></script><script type="text/javascript" src="/htmlcalendar/jscalendar-1.0/lang/calendar-cs-ismu-utf8.js"></script><script type="text/javascript" src="/htmlcalendar/jscalendar-1.0/calendar-setup.js"></script><style type="text/css">.special { background-color: #000; color: #fff; }</style>
//  <script type="text/javascript">
//  /**
//   * Funkce vrati true/false podle toho, jestli je dany den svatek
//   */
//  function dateIsSpecial(year, month, day) {
//    var svatky = [["20001028","Den vzniku samostatného Československa"],["20001224","Štědrý den"],["20001225","1. svátek vánoční, Boží hod vánoční"],["20001226","2. svátek vánoční, Štěpán"],["20001227","vánoční prázdniny"],["20001228","vánoční prázdniny"],["20001229","vánoční prázdniny"],["20001230","vánoční prázdniny"],["20001231","vánoční prázdniny"],["20010101","Nový rok"],["20010416","Pondělí velikonoční"],["20010501","Svátek práce"],["20010508","Den osvobození od fašismu"],["20010705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20010706","mistr Jan Hus"],["20010928","Den české státnosti"],["20011028","Den vzniku samostatného Československa"],["20011117","Den boje studentů za svobodu a demokracii"],["20011224","Štědrý den"],["20011225","1. svátek vánoční, Boží hod vánoční"],["20011226","2. svátek vánoční, Štěpán"],["20011227","vánoční prázdniny"],["20011228","vánoční prázdniny"],["20011229","vánoční prázdniny"],["20011230","vánoční prázdniny"],["20011231","vánoční prázdniny"],["20020101","Nový rok"],["20020401","Velikonoční pondělí"],["20020501","Svátek práce"],["20020508","Den osvobození"],["20020705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20020706","Den upálení mistra Jana Husa"],["20020928","Den české státnosti"],["20021028","Den vzniku samostatného československého státu"],["20021117","Den boje za svobodu a demokracii"],["20021223","vánoční prázdniny"],["20021224","Štědrý den"],["20021225","1. svátek vánoční"],["20021226","2. svátek vánoční"],["20021227","vánoční prázdniny"],["20021228","vánoční prázdniny"],["20021229","vánoční prázdniny"],["20021230","vánoční prázdniny"],["20021231","vánoční prázdniny"],["20030101","Nový rok"],["20030421","Velikonoční pondělí"],["20030501","Svátek práce"],["20030508","Den osvobození"],["20030705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20030706","Den upálení mistra Jana Husa"],["20030928","Den české státnosti"],["20031028","Den vzniku samostatného československého státu"],["20031117","Den boje za svobodu a demokracii"],["20031224","Štědrý den"],["20031225","1. svátek vánoční"],["20031226","2. svátek vánoční"],["20040101","Nový rok"],["20040412","Velikonoční pondělí"],["20040501","Svátek práce"],["20040508","Den osvobození"],["20040705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20040706","Den upálení mistra Jana Husa"],["20040928","Den české státnosti"],["20041028","Den vzniku samostatného československého státu"],["20041117","Den boje za svobodu a demokracii"],["20041224","Štědrý den"],["20041225","1. svátek vánoční"],["20041226","2. svátek vánoční"],["20041227","vánoční prázdniny"],["20041228","vánoční prázdniny"],["20041229","vánoční prázdniny"],["20041230","vánoční prázdniny"],["20041231","vánoční prázdniny"],["20050101","Nový rok"],["20050328","Velikonoční pondělí"],["20050501","Svátek práce"],["20050508","Den osvobození"],["20050705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20050706","Den upálení mistra Jana Husa"],["20050928","Den české státnosti"],["20051028","Den vzniku samostatného československého státu"],["20051117","Den boje za svobodu a demokracii"],["20051224","Štědrý den"],["20051225","1. svátek vánoční"],["20051226","2. svátek vánoční"],["20051227","vánoční prázdniny"],["20051228","vánoční prázdniny"],["20051229","vánoční prázdniny"],["20051230","vánoční prázdniny"],["20060101","Nový rok"],["20060417","Velikonoční pondělí"],["20060501","Svátek práce"],["20060508","Den osvobození"],["20060705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20060706","Den upálení mistra Jana Husa"],["20060928","Den české státnosti"],["20061028","Den vzniku samostatného československého státu"],["20061117","Den boje za svobodu a demokracii"],["20061224","Štědrý den"],["20061225","1. svátek vánoční"],["20061226","2. svátek vánoční"],["20061227","vánoční prázdniny"],["20061228","vánoční prázdniny"],["20061229","vánoční prázdniny"],["20061230","vánoční prázdniny"],["20070101","Nový rok"],["20070409","Velikonoční pondělí"],["20070501","Svátek práce"],["20070508","Den osvobození"],["20070705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20070706","Den upálení mistra Jana Husa"],["20070928","Den české státnosti"],["20071028","Den vzniku samostatného československého státu"],["20071117","Den boje za svobodu a demokracii"],["20071224","Štědrý den"],["20071225","1. svátek vánoční"],["20071226","2. svátek vánoční"],["20071227","vánoční prázdniny"],["20071228","vánoční prázdniny"],["20071229","vánoční prázdniny"],["20071230","vánoční prázdniny"],["20071231","vánoční prázdniny"],["20080101","Nový rok"],["20080324","Velikonoční pondělí"],["20080501","Svátek práce"],["20080508","Den osvobození"],["20080705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20080706","Den upálení mistra Jana Husa"],["20080928","Den české státnosti"],["20081028","Den vzniku samostatného československého státu"],["20081117","Den boje za svobodu a demokracii"],["20081224","Štědrý den"],["20081225","1. svátek vánoční"],["20081226","2. svátek vánoční"],["20090101","Nový rok"],["20090413","Velikonoční pondělí"],["20090501","Svátek práce"],["20090508","Den osvobození"],["20090705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20090706","Den upálení mistra Jana Husa"],["20090928","Den české státnosti"],["20091028","Den vzniku samostatného československého státu"],["20091117","Den boje za svobodu a demokracii"],["20091224","Štědrý den"],["20091225","1. svátek vánoční"],["20091226","2. svátek vánoční"],["20100101","Nový rok"],["20100405","Velikonoční pondělí"],["20100501","Svátek práce"],["20100508","Den osvobození"],["20100705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20100706","Den upálení mistra Jana Husa"],["20100928","Den české státnosti"],["20101028","Den vzniku samostatného československého státu"],["20101117","Den boje za svobodu a demokracii"],["20101223","vánoční prázdniny"],["20101224","Štědrý den"],["20101225","1. svátek vánoční"],["20101226","2. svátek vánoční"],["20101227","vánoční prázdniny"],["20101228","vánoční prázdniny"],["20101229","vánoční prázdniny"],["20101230","vánoční prázdniny"],["20101231","vánoční prázdniny"],["20110101","Nový rok"],["20110425","Velikonoční pondělí"],["20110501","Svátek práce"],["20110508","Den osvobození"],["20110705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20110706","Den upálení mistra Jana Husa"],["20110928","Den české státnosti"],["20111028","Den vzniku samostatného československého státu"],["20111117","Den boje za svobodu a demokracii"],["20111223","vánoční prázdniny"],["20111224","Štědrý den"],["20111225","1. svátek vánoční"],["20111226","2. svátek vánoční"],["20111227","vánoční prázdniny"],["20111228","vánoční prázdniny"],["20111229","vánoční prázdniny"],["20111230","vánoční prázdniny"],["20111231","vánoční prázdniny"],["20120101","Nový rok"],["20120409","Velikonoční pondělí"],["20120501","Svátek práce"],["20120508","Den osvobození"],["20120705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20120706","Den upálení mistra Jana Husa"],["20120928","Den české státnosti"],["20121028","Den vzniku samostatného československého státu"],["20121117","Den boje za svobodu a demokracii"],["20121223","vánoční prázdniny"],["20121224","Štědrý den"],["20121225","1. svátek vánoční"],["20121226","2. svátek vánoční"],["20121227","vánoční prázdniny"],["20121228","vánoční prázdniny"],["20121229","vánoční prázdniny"],["20121230","vánoční prázdniny"],["20121231","vánoční prázdniny"],["20130101","Nový rok"],["20130401","Velikonoční pondělí"],["20130501","Svátek práce"],["20130508","Den osvobození"],["20130705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20130706","Den upálení mistra Jana Husa"],["20130928","Den české státnosti"],["20131028","Den vzniku samostatného československého státu"],["20131117","Den boje za svobodu a demokracii"],["20131223","vánoční prázdniny"],["20131224","Štědrý den"],["20131225","1. svátek vánoční"],["20131226","2. svátek vánoční"],["20131227","vánoční prázdniny"],["20131228","vánoční prázdniny"],["20131229","vánoční prázdniny"],["20131230","vánoční prázdniny"],["20131231","vánoční prázdniny"],["20140101","Nový rok"],["20140421","Velikonoční pondělí"],["20140501","Svátek práce"],["20140508","Den vítězství"],["20140705","Den slovanských věrozvěstů Cyrila a Metoděje"],["20140706","Den upálení mistra Jana Husa"],["20140928","Den české státnosti"],["20141028","Den vzniku samostatného československého státu"],["20141117","Den boje za svobodu a demokracii"],["20141222","vánoční prázdniny"],["20141223","vánoční prázdniny"],["20141224","Štědrý den"],["20141225","1. svátek vánoční"],["20141226","2. svátek vánoční"],["20141227","vánoční prázdniny"],["20141228","vánoční prázdniny"],["20141229","vánoční prázdniny"],["20141230","vánoční prázdniny"],["20141231","vánoční prázdniny"]];
//    var datum = year*10000 + (month+1)*100 + day;
//    for (var i in svatky) {
//      if (svatky[i][0] == datum) {
//        return svatky[i][1];
//      }
//    }
//    return false;
//  }
//  </script><nobr><input type="text" name="diskuse_PRAVO_r1_DAT" value="" id="cal_diskuse__te" size="16" maxlength="16"><img src="/htmlcalendar/jscalendar-1.0/img.gif" id="cal_diskuse__tr" style="cursor: pointer; border: 1px solid red;" title="Výběr data" alt="Výběr data" onmouseover="this.style.background='red';" onmouseout="this.style.background=''"></nobr><script type="text/javascript">
//Calendar.setup(
//  {
//    inputField: "cal_diskuse__te",
//    ifFormat: "%d %m %Y %H %M", 
//    showsTime:  true,
//    button:   "cal_diskuse__tr",
//    dateStatusFunc: function(date, y, m, d) {
//      if (dateIsSpecial(y, m, d)) return "special";
//      else return false;
//    }
//  }
//);
//</script></td>
//<td>ano</td>
//</tr>
//      <input type="hidden" name="diskuse_PRAVO_r1" value="w"><input type="hidden" name="diskuse_PRAVO_r1_UPR" value=""><input type="hidden" name="diskuse_PRAVO_r1_DAT" value="">
//</tbody></table><h4>Právo vkládat</h4><table cellspacing="0" cellpadding="0" class="navodek"><tbody><tr><td>Lze zadat datum, do kdy je vhodné vkládat příspěvky. Systém pak automaticky po skončení termínu právo odebere.</td></tr></tbody></table>
//
//<table class="data1" border="" style="text-align:center;">
//<tbody><tr>
//<th>Zruš</th>
//<th>Typ práva</th>
//<th>Upřesnění</th>
//<th>Do kdy se uplatní</th>
//<th>Již uložené</th>
//</tr>
//
//<tr>
//<td><input type="checkbox" name="zrusit_pravo_w_diskuse" value="w:w:"></td>
//<td>kdokoliv přihlášený v ISu</td>
//<td>&nbsp;</td>
//      <td><nobr><input type="text" name="diskuse_PRAVO_w1_DAT" value="" id="cal_diskuse_1_te" size="16" maxlength="16"><img src="/htmlcalendar/jscalendar-1.0/img.gif" id="cal_diskuse_1_tr" style="cursor: pointer; border: 1px solid red;" title="Výběr data" alt="Výběr data" onmouseover="this.style.background='red';" onmouseout="this.style.background=''"></nobr><script type="text/javascript">
//Calendar.setup(
//  {
//    inputField: "cal_diskuse_1_te",
//    ifFormat: "%d %m %Y %H %M", 
//    showsTime:  true,
//    button:   "cal_diskuse_1_tr",
//    dateStatusFunc: function(date, y, m, d) {
//      if (dateIsSpecial(y, m, d)) return "special";
//      else return false;
//    }
//  }
//);
//</script></td>
//<td>ano</td>
//</tr>
//      <input type="hidden" name="diskuse_PRAVO_w1" value="w"><input type="hidden" name="diskuse_PRAVO_w1_UPR" value=""><input type="hidden" name="diskuse_PRAVO_w1_DAT" value="">
//</tbody></table><input type="submit" name="nahrad_pravem_rdiskuse" value="Stejná práva jako pro čtení"><br>
//<hr><input type="submit" name="zrusit_pravo_diskuse" value="Zrušit zaškrtnutá práva" onclick="
//if (! confirm('Opravdu zrušit zaškrtnutá práva?')) {
//  return false;
//}
//    ">
//<br><input type="submit" name="prub_uloz_diskuse" value="Průběžně uložit">
//<fieldset class="pr_fieldset"><legend>Přidat další právo:</legend>
//<div><select name="TYP_diskuse"><option value="r">Právo číst</option><option value="w">Právo vkládat</option><option value="a">Moderátoři</option></select> smí <select name="SUBTYP_diskuse"><option value="W">kdokoliv v Internetu</option><option value="w">kdokoliv přihlášený v ISu</option><option value="p">studenti předmětu v období</option><option value="s">studenti semináře</option><option value="m">studenti předmětu s kódem</option><option value="z">pracovníci</option><option value="f">aktuální studenti fakulty</option><option value="g">pojmenovaná skupina osob</option><option value="i">osoba</option><option value="u">učitelé</option><option value="a">absolventi</option><option value="d">doktorští studenti</option><option value="l">aktuální studenti a zaměstnanci školy</option><option value="k">přihlášení na zkoušku</option><option value="pr">uchazeči o studium, kdokoliv přihlášený v ISu</option><option value="b">známí osoby</option><option value="so">výčet učo osob</option></select> <input type="submit" name="pridat_upr_diskuse" value="Přidat právo"> a upřesnit nastavení
//</div></fieldset>
//
//<br><p><input type="submit" name="uloz" value="Uložit"> &nbsp; </p></form>
//
//*/