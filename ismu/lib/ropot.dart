//import 'dart:html' as dom;

import 'dart:async' as async;
import 'dart:html' as dom;

import 'package:form_data/form_data.dart' as fd;

import 'package:ismu/is.dart' as ismu;

class Summary {
  //TODO: parametrize course, term
  static url({course, term}) => "https://is.muni.cz/auth/elearning/test_sprava_el_ucitel.pl?fakulta=1433;obdobi=${term};predmet=${course};lang=cs";

  List<String> ropotLinks;
  List<String> ropotNames;
  List<String> ropotUrls;

  Summary.fromHtml(html) {
    var page = ismu.elementFromHtml(html);
    var ahrefs = ismu.xpathSelectorAll('//*[@id="aplikace"]/ul/li/a[1]', page);
    ropotLinks = ahrefs.map(
            (e) => e.attributes['href'].replaceFirst("..", 'https://is.muni.cz/auth')
    ).toList();
    ropotNames = ismu.xpathSelectorAll('//*[@id="aplikace"]/ul/li/a[1]/b', page).map(
            (e) => e.text
    ).toList();
    ropotUrls = ismu.xpathSelectorAll('//*[@id="aplikace"]/ul/li/font', page).map(
            (e) => e.text
    ).toList();
  }

  static async.Future<Summary> futureFromURL(url) {
    var completer = new async.Completer();
    ismu.get(url, shouldNotDelay: true).then((html) {
      completer.complete(new Summary.fromHtml(html));
    }, onError: (e) => completer.complete(e));
    return completer.future;
  }
}

class Settings {
  String submitURL;
  String enctype;
  fd.FormData data;

  Settings(dom.Element page) {
    var form = ismu.xpathSelector('//*[@id="aplikace"]/form', page);
    submitURL = "https://is.muni.cz" + form.attributes['action'];
    enctype = form.attributes['enctype'];
    data = new fd.FormData(form);
  }

  static async.Future fututeFromUrl(String url) {
    // this is duplicate
    var completer = new async.Completer<Settings>();
//    print(url);
    ismu.get(url, shouldNotDelay: false).then((html) {
//      print(html);
      var form = ismu.elementFromHtml(html);
//      print("got form");
      completer.complete(new Settings(form));
    }, onError: (e) => completer.complete(e));
    return completer.future;
  }

  //TODO: if not logged in, this silently fails (with code 200)
  async.Future saveAndPublish() {
    data["uloz_zpristupni"] = "1";
//    print(submitURL);

    var mapa = new Map<String, String>();
    data.forEach((k, v) {
      if (k != null && v != null) {
        mapa[k] = v;
      }
    });

    return dom.HttpRequest.postFormData(submitURL, mapa/*, responseType: enctype*/);
  }

  bool setNebodujeSe() {
    data.remove('IMPL_BODY_OK');
    data["NEBODOVAT"] = 'ano';
    data["SUMA_DO_BLOKU"] = '';
    return true;
  }

  setSkladatDatesForSpring2014() {
    data.keys.where(
            (String e) => e.startsWith('SKLADAT_OD') || e.startsWith('SKLADAT_DO')
    ).toList().forEach(
            (e) => data.remove(e)
    );
    data["SKLADAT_OD"] = "17 02 2014 12 00";
    data["SKLADAT_DO"] = "25 05 2020 23 59";
    //settings["SKLADAT_OD1"] = "01 06 2014 12 00";
    //settings["SKLADAT_DO1"] = "01 09 2099 23 59";
  }

  var opakovaneOdpovidaniOptions = [
    "SKLADAT_OPAKOVANE"
    , "MAXIMALNI_POCET_PRUCHODU"
    , "ZAPOCITAT_OTEVRENI"
    , "SKLADAT_OPAKOVANE_NE_ZNOVU_ODPOVIDAT"
  ];

  purgeOpakovaneOdpovidani() {
    opakovaneOdpovidaniOptions.forEach(
            (e) => data.remove(e)
    );
  }

  printOpakovaneOdpovidani() {
    opakovaneOdpovidaniOptions.forEach(
            (e) => print("${e}: ${data[e]}\n")
    );
  }

  setAllowPrubezneUlozeni() {
    // povolen jen jeden pruchod
    if (data["SKLADAT_OPAKOVANE"] == "ne" ||
    data["SKLADAT_OPAKOVANE"] == "ano_totez") {
      purgeOpakovaneOdpovidani();
      data["MAXIMALNI_POCET_PRUCHODU"] = "1";
      data["SKLADAT_OPAKOVANE"] = "ano_totez";
      data["SUMA_DO_BLOKU"] = "posledni";
//tohle nefunguje jak jsem myslel
//    } else if (data["SKLADAT_OPAKOVANE"] == "ano") {
//        data.remove("SKLADAT_OPAKOVANE_NE_ZNOVU_ODPOVIDAT");
      return true;
    }
    return false;
  }

  setAllowVicePruchoduCountBest() {
    // povolen jen jeden pruchod
    if (data["SKLADAT_OPAKOVANE"] == "ne" ||
    // povoleno prubezne ulozeni
    (data["MAXIMALNI_POCET_PRUCHODU"] == "1" && data["SKLADAT_OPAKOVANE"] == "ano_totez")) {
      purgeOpakovaneOdpovidani();
      data["MAXIMALNI_POCET_PRUCHODU"] = "";
      data["SKLADAT_OPAKOVANE"] = "ano_totez";
      data["SUMA_DO_BLOKU"] = "nejlepsi";
      return true;
    }
    return false;
  }
}

