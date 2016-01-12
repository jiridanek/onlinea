import "dart:html";
import "package:html/parser.dart" as html;

import "package:http/browser_client.dart";
import "package:http/http.dart" as http;

import "package:ismu/notebooks.dart" as ismu;

class NotebooksService {
  List<ismu.Blok> notebooks;

  num get totalPoints {
    var points = pointsInBlok('Total Points / Body celkem');
    return points;
  }
  num get discussionPoints {
    return pointsInBlok('Sum of Points from Discussion');
  }

  pointsInBlok(String name) {
    var blok = notebooks.firstWhere((ismu.Blok b) => b.name == name,  orElse: () => null);
    var points = blok?.totalPoints;
    return points;
  }

  fetchNotebooks() async {
    var url = ismu.BlokyNahled.URL('6184');
    var client = new BrowserClient();
    var page = await client.get(url);
    var dom = html.parse(page.body);
    var all = new ismu.BlokyNahled(dom);
    var course = all.courses.firstWhere((ismu.Predmet p) => p.code == 'ONLINE_A');
    notebooks = all.bloky(course.id);
  }
}