import 'dart:js' as js;
import 'dart:html' as dom;
import 'package:chrome/chrome_ext.dart' as chrome;

import 'package:is/ropot.dart' as ropot;
import 'package:is/is.dart'; // ignore


main() {
  odpovednik();
}

odpovedniky() {
  var page = elementFromHtml(html_odpovedniky);
  var ahrefs = xpathSelectorAll('//*[@id="aplikace"]/ul/li/a[1]', page);
  var links = ahrefs.map(
        (e) => e.attributes['href'].replaceFirst("..", 'https://is.muni.cz/auth')
  ).toList();
  print(links[5]);
}

odpovednik() {
  var page = elementFromHtml(html_odpovednik);
  var form = xpathSelector('//*[@id="aplikace"]/form', page);
  var settings = new ropot.Settings(form);
  print(settings.toString());
  
  settings.setSkladatDatesForSpring2014();
  
  print("length ${settings.data.length}");
  settings.data.forEach((k, v) => print("$k, $v"));
  
  print("length ${settings.data.submit.length}");  
  settings.data.submit.forEach((k, v) => print("$k, $v"));
}