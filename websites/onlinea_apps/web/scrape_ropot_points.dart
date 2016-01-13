import 'dart:html' as dom;
import 'dart:async' as async;
import 'dart:convert' as convert;

import 'package:chrome/chrome_app.dart' as chrome;

import "package:is/notebooks.dart" as ismu;
import "package:is/ropot.dart" as ismu;
import "package:is/is.dart" as ismu;

import "login_information.dart";

import "package:is/test_sprava_el_ucitel_pl.dart" as test_sprava_el_ucitel;

main() {
  ismu.LogInPage.logIn(USERNAME, PASSWORD).whenComplete(scrapeRopotPoints);
  //dom.querySelector('#text_id').onClick.listen((e) {scrapeRopotPoints();});
}

scrapeRopotPoints() {
  openWorkingDirectory().then((directory) {
    writePages(directory);
    //processData(directory);
  });
}

writePages(directory) {
  var summary = new ismu.Summary.fromHtml(test_sprava_el_ucitel.html);
    var fs = [];
    //var what = ['QPT', 'Final Test'];
    var what = summary.ropotNames;
    for (var name in what ) {
      var url = ismu.BlokVseZobraz.URL([Uri.encodeQueryComponent(name)], fakulta: 1441, obdobi: 5846, predmet: 721682);
      fs.add((){
        return ismu.get(url)
          .then((html) => writeFile(name, directory, html))
          .then((_) => print('got $name'));
      });
    }
    async.Future.forEach(fs, (f) => f());
    print('got all');
}

processData(dom.DirectoryEntry directory) {
  directory.createReader().readEntries().then((List<chrome.Entry> entries) {
//    print(entries);
    var result = [];
    async.Future.forEach(entries/*.sublist(0,2)*/, (entry) {
      var completer = new async.Completer();
      if(entry.isFile) {
//        print(entry.name);
        processPage(entry).then((value) {
          result.addAll(value);
          completer.complete();
        });
        
      } else {
        return new async.Future((){});
      }
      
      return completer.future;
    }).whenComplete(() {
      var text = convert.JSON.encode(result);
      writeFile("records.json", directory, text);
      print('finished');
    });
  });
}

async.Future processPage(chrome.ChromeFileEntry entry) {
  var regexp = new RegExp(r'\*(-?[0-9]*(?:\.[0-9]*)?)');
  
  var completer = new async.Completer();
  var result = [];
  entry.readText().then((text) {
    var blok = new ismu.BlokVseZobraz.fromHtml(text);
    var result = blok.process([entry.name]).map((e) {
      num avg = null;
      var body = [];
      for (var match in regexp.allMatches(e['body'])) {
        body.add(double.parse(match.group(1)));
      }
      if (body.length != 0) {
        avg = body.reduce((a, b) => a+b) / body.length;
      }
      e['body'] = avg;
      return e;
    });
    //print(result);
    completer.complete(result);
  });
  return completer.future;
}

String id="";

async.Future openWorkingDirectory() {
  var completer = new async.Completer();
  chrome.fileSystem.isRestorable(id).then((b) {
      if (b) {
        chrome.fileSystem.restoreEntry(id).then((entry) => completer.complete(entry));
      } else {
        var opt = new chrome.ChooseEntryOptions(type: chrome.ChooseEntryType.OPEN_DIRECTORY);
        chrome.fileSystem.chooseEntry(opt).then((res) {
          id = chrome.fileSystem.retainEntry(res.entry);
          completer.complete(res.entry); 
        });
      }
  });
  return completer.future;
}

writeFile(filename, entry, text) {
  entry.createFile(filename).then((chrome.ChromeFileEntry res) {
    res.writeText(text);
  });
}

