import 'dart:async' as async;
import 'dart:html' as dom;

import 'package:chrome/chrome_app.dart' as chrome;

import 'package:is/is.dart' as ismu;
import 'package:is/discussion.dart' as discussion;
import 'package:is/ropot.dart' as ropot;

import 'demo_ropot_manipulations_data.dart' as data;

import "password.dart";


void main() {
  dom.querySelector("#text_id").onClick.listen(setAllow);
  //nebo
  //dom.querySelector("#text_id").onClick.listen(getAllPosts);

}

void getAllPosts(dom.MouseEvent event) {
  ismu.LogInPage.logIn("374368", "ven2tyrvec").then((_) {
    ismu.get(url).then((html) {
      var element = ismu.elementFromHtml(html);
      var firstPage = new discussion.ForumPage(element);
      var forum = new discussion.Forum(firstPage);
      forum.streamThreads().forEach((thread) {
        thread.streamPosts().forEach((post) {
          storePost(post);
        });
      });
    });
    //FIXME
  });
}


_setAllow(ropot.Summary summary) {
  async.Future.forEach(summary.ropotLinks.sublist(0), (String link) {
    if (!link.contains('ONLINE_A%2Fodp%2Fexperiments%2F50542980%2Fqdesc')) {
      print("not eslvideo, skipping $link \n");
      return new async.Future.value();
    }
    var completer = new async.Completer();
    ropot.Settings.fututeFromUrl(link).then((ropot.Settings settings) {
      var hasChanged = settings.setNebodujeSe();
      if (hasChanged) {
        settings.saveAndPublish();
      }
      var msg = hasChanged ? "processed" : "skipped";
      print("${msg}: ${link}");
      completer.complete();
    });
    return completer.future;
  }).then((_) {
    print("processing finished");
  });
//  for (var link in ) {
//    ropot.Settings.fututeFromUrl(link).then((ropot.Settings settings) {
//      //settings.setSkladatDatesForSpring2014();
//      //print("save&publish");
////    settings.printOpakovaneOdpovidani();
//      var msg = settings.setAllowVicePruchoduCountBest() ? "processed" : "skipped";
//      print("${msg}: ${link}");
////    print("///////\n");
////    settings.printOpakovaneOdpovidani();
////    print("\n");
//      settings.saveAndPublish();
//    });
//  }
}
void setAllow(dom.MouseEvent event) {
  ismu.LogInPage.logIn(USERNAME, PASSWORD).then((_) {

//    ropot.Summary.futureFromURL(ropot.Summary.url(course: '771131', term: '6084')).then((ropot.Summary summary) {
//    });
    
    _setAllow(new ropot.Summary.fromHtml(data.html_odpovedniky));

    //var link = "https://is.muni.cz/auth/elearning/test_desc_edit_el_ucitel.pl?fakulta=1433;obdobi=5984;kod=ONLINE_A;predmet=721682;akce=edit;qdescurl=%2Fel%2F1441%2Fjaro2014%2FONLINE_A%2Fodp%2Ftb%2F7077345%2FAmbition.qdesc";




  });
}
/*
new dom.HttpRequest();
dom.HttpRequest.requestCrossOrigin(url);
var r = new dom.HttpRequest(); //
*/

//  chrome.cookies.getAllCookieStores().then( (listStores) {
//    var details = new chrome.CookiesGetAllParams();
//    chrome.cookies.getAll(details).then((listCookies) {
//      for (var cookie in listCookies) {
//        print(cookie);
//      }
//    });
//  });
//  //print();
//  dom.HttpRequest.getString("https://is.muni.cz/auth").then( (v) {
//    //print(v);
//  });
//
