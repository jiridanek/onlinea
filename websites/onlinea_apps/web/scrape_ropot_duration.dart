import "dart:async" as async;
import "dart:html" as dom;

import "package:chrome/chrome_app.dart" as chrome;

import "package:is/notebooks.dart" as ismu;
import "package:is/ropot.dart" as ismu;
import "package:is/is.dart" as ismu;

import "scrape_ropot_points.dart" as lib;
import "package:is/test_sprava_el_ucitel_pl.dart" as test_sprava_el_ucitel;

import "login_information.dart";

clearLocalStorage() {
  chrome.storage.local.clear();
}

async.Future saveLastFile(entry) {
  var id = chrome.fileSystem.retainEntry(entry);
  return chrome.storage.local.set({'lastFile': id});
}

async.Future restoreLastFile() {
  return chrome.storage.local.get(['lastFile']).then((v) {
    return v['lastFile'];
  }).then((String id) {
    if (id != null) {
      return chrome.fileSystem.restoreEntry(id);
    }
    return new async.Future.error("lastFile in storage is null");
  });
}

async.Future<chrome.FileEntry> openFile() {
  var completer = new async.Completer();
  restoreLastFile().then((entry) {
    completer.complete(entry);
  }).catchError((e){
    chrome.fileSystem.chooseEntry(new chrome.ChooseEntryOptions(type: chrome.ChooseEntryType.OPEN_FILE)).then((result) {
      var entry = result.entry;
      saveLastFile(entry);
      completer.complete(entry);
    }).catchError((e)=>completer.completeError(e));
  });
  return completer.future;
}

parse() {
  dom.querySelector('#clear').onClick.listen((_)=>clearLocalStorage());
  
  openFile().then((chrome.FileEntry entry) {
    entry.file().then((file) {
      dom.Blob blob = new dom.Blob([file]);
print(file);
print(blob);
  var reader = new dom.FileReader();
  reader.readAsText(blob);
  reader.onLoad.listen((_) {
    print(reader.result);
  });

    });
  });
}

main() {
  
  //parse();
  scrape();
}

scrape() {
  lib.openWorkingDirectory().then((dir) {
  ismu.LogInPage.logIn(USERNAME, PASSWORD).whenComplete(() {
  //var futureSummary = ismu.Summary.futureFromURL(ismu.Summary.url);
  var futureSummary = new async.Future.value(new ismu.Summary.fromHtml(test_sprava_el_ucitel.html));
  futureSummary.then((ismu.Summary summary){
    async.Future.forEach(summary.ropotUrls.sublist(153), (ropotUrl){ //DEBUG
      var done = new async.Completer();
      
      var l = url(ropotUrl);
      dom.HttpRequest.request(l.toString()).then((dom.HttpRequest request) {
        var cd = request.getResponseHeader("Content-Disposition").trim();
        var fn = "filename=";
        var i = cd.lastIndexOf(fn);
        var name = null;
        if (i != -1) {
          name = cd.substring(i+fn.length);
        }
        var text = request.responseText;
        if (name != null) {
          lib.writeFile(name, dir, text);
        } else {
          print("skipping $ropotUrl, no name");
        }
        done.complete();
        print("got $name");
      }).catchError((e){
        print("failed to get $ropotUrl");
        done.complete();
      });
      return done.future;
    });
  });
  });
  });
}

url(testurl) {
  return new Uri.https('is.muni.cz', 'auth/elearning/test_odpovedi_el_ucitel.pl', {
    'fakulta':   '1433',
    'obdobi':    '5984',
    'kod':       'ONLINE_A',
    'predmet':   '721682',
    'zuv':       '274116',
    'testurl':   testurl,
    'nabixml':   '1',
    'xmlqa':     'all',
    'prehlosob': '1'});
}