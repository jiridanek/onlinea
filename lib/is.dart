import 'dart:async' as async;
import 'dart:html' as dom;
import 'dart:js' as js;
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

// avoids the implicit sanitization? do I really want that?
// Uncaught Error: Bad state: More than one element
class NullHtmlValidator implements dom.NodeValidator {
  const NullHtmlValidator();
  @override
  bool allowsAttribute(dom.Element element, String attributeName, String value)
    => true;

  @override
  bool allowsElement(dom.Element element)
    => true;
}
final nullHtmlValidator = const NullHtmlValidator();
//final silentHtmlValidator = new dom.NodeValidatorBuilder.common().;
dom.Element elementFromHtml(String html) {
  //print(html);
  //dom.document.createExpression();
  return new dom.DivElement()..setInnerHtml(html, validator: nullHtmlValidator);
  //return new dom.Element.html(html);
  //return new dom.DocumentFragment.html(html, validator: nullHtmlValidator);
}

async.Future<String> get(String url, {bool shouldNotDelay: false}) {
  //skip that
  return _get(url, shouldNotDelay);
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

async.Future<String> _get(String url, bool shouldNotDelay) {
  int maxDelay = 6;
  var completer = new async.Completer();
  var ajax = () {
    dom.HttpRequest.request(url).then((dom.HttpRequest r) {
        completer.complete(r.responseText);
      }, onError: (e) {
        dom.HttpRequest r = e.target;
        completer.complete(r);
      });
  };
  
  
  if(shouldNotDelay) {
    ajax();
  } else {
    new async.Timer(new Duration(milliseconds: 500, seconds: random.nextInt(maxDelay)), () {
      ajax();
    });
  }
  return completer.future;
}

//TODO: failed login
//logout
class LogInPage {
  static const url = 'https://is.muni.cz/system/login_form.pl';
  static const expiration = '345600'; //1 hodině    8 hodinách    1 dni    4 dnech
    
  static async.Future<String> logIn(String username, String password, {destination: '/auth'}) {
    var data = {'destination': destination,
                'credential_0': username,
                'credential_1': password,
                'credential_2': expiration};
    var completer = new async.Completer();
    dom.HttpRequest.postFormData(url, data).then((dom.HttpRequest r) {
      completer.complete(r.responseText);
    }, onError: (e) => completer.completeError(e));
    return completer.future;
  }
}