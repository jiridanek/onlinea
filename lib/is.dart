import 'dart:async' as async;
//import 'dart:html' as dom;
import 'package:html5lib/dom.dart' as dom;
import 'package:html5lib/parser.dart' as dom;
//import 'dart:js' as js;
import 'dart:math' as math;

var jsPrefix = 'xpath';
List<dom.Element> xpathSelectorAll(query, element) {
  var context = js.context;
  var result = js.context[jsPrefix].callMethod('xpathSelectorAll', [query, element]);
  return result;
}

dom.Element xpathSelector(query, element) {
  var list = xpathSelectorAll(query, element);
  if(list.isNotEmpty) {
    return list.first;
  }
  return null;
}

//// avoids the implicit sanitization? do I really want that?
//// Uncaught Error: Bad state: More than one element
////FIXME The library can fetch whole Documents, I do not need to do this
//class NullHtmlValidator implements dom.NodeValidator {
//  const NullHtmlValidator();
//  @override
//  bool allowsAttribute(dom.Element element, String attributeName, String value)
//    => true;
//
//  @override
//  bool allowsElement(dom.Element element)
//    => true;
//}
//final nullHtmlValidator = const NullHtmlValidator();
////final silentHtmlValidator = new dom.NodeValidatorBuilder.common().;
//dom.Element elementFromHtml(String html) {
//  //print(html);
//  //dom.document.createExpression();
//  return new dom.DivElement()..setInnerHtml(html, validator: nullHtmlValidator);
//  //return new dom.Element.html(html);
//  //return new dom.DocumentFragment.html(html, validator: nullHtmlValidator);
//}

dom.Document elementFromHtml(String html) {
  return dom.parse(html, encoding: 'utf-8');
}

async.Future<String> get(String url, {bool shouldNotDelay: false}) {
  //skip that
  return CONFIG.get(url, shouldNotDelay);
  // does ad-hoc caching in chrome.storage for faster testing
//  var completer = new async.Completer();
//  var found = false;
//  chrome.storage.local.get([url]).then((map) {
//    if (map.containsKey(url)) {
//      completer.complete(map[url]);
//    } else {
//      _get(url).then((v) {
//        chrome.storage.local.set({url: v});
//        completer.complete(v);
//      });
//    }
//  });
//  return completer.future;
}

var random = new math.Random();

class CONFIG {
  static var postFormData = null; //dom.HttpRequest.postFormData;
  static var request = null; //dom.HttpRequest.request;
  static var get = (String url, bool shouldNotDelay) {
    int maxDelay = 6;
    var completer = new async.Completer();
    var ajax = () {
      CONFIG.request(url).then((var request) {
        var body = null;
        try {
          body = request.body;
        } on NoSuchMethodError {
          body = request.responseText; // would be responseText with dart:html
        }
        completer.complete(body); // would be responseText with dart:html
      }//, //library:http always returns http.Response
//          onError: (e) {
//          var r = e.target;
//          completer.completeError(r);
//        }
    );};

    if(shouldNotDelay) {
      ajax();
    } else {
      new async.Timer(new Duration(milliseconds: 500, seconds: random.nextInt(maxDelay)), () {
        ajax();
      });
    }
    return completer.future;
  };
}

//TODO: failed login
//logout
class LogInPage {
  static const url = 'https://is.muni.cz/system/login_form.pl';
  static const expiration = '345600'; //1 hodině    8 hodinách    1 dni    4 dnech
    
  static async.Future<dynamic> logIn(String username, String password, {destination: '/auth/'}) {
    var data = {'destination': destination,
                'credential_0': username,
                'credential_1': password,
                'credential_2': expiration};
    var completer = new async.Completer();
    CONFIG.postFormData(url, data).then((response) {
      completer.complete(response); //i need cookies // dart:html would use request.responseText
    }, onError: (e) => completer.completeError(e));
    return completer.future;
  }
}