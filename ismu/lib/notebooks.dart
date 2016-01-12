//import "dart:html" as dom;
//import "package:ismu/ropot.dart" as ismu;
//import "package:ismu/is.dart" as ismu;

class Predmet {
  var id;
  var code;
  var name;

  Predmet(this.id, this.code, this.name);

  toString() {
    return {'id':id, 'code':code, 'name':name}.toString();
  }
}

class Blok {
  String name;
  String modifiedBy;
  String modifiedWhen;
  String change;
  String text;

  num get totalPoints {
    // originally in lib/blok.pm
    var float = new RegExp(r'\*([+-]?\d+([.,]\d+)?)');
    var ms = float.allMatches(text);
    var total = ms.fold(0, (s, m) => s + num.parse(m.group(1).replaceAll(',', '.')));
    return total;
  }
}

class DiscussionBlok extends Blok {
  List<Post> posts;
}

class Post {
  String url;
  String text;
}

class Change {
  DateTime date;
  String user;
}

// z pohledu studenta
class BlokyNahled {
  var root;

  //dom root, a dom node

  static String URL(String obdobi, {String studium: 'vse'}) {
    return "https://is.muni.cz/auth/student/poznamkove_bloky_nahled?studium=$studium;obdobi=$obdobi;lang=cs";
  }

  static Change parseChanged(String s) {
    var change = new Change();
    var re = new RegExp(r'.* (\d+)\. (\d+)\. (\d+) (\d+):(\d+), (.*)$');
    var m = re.matchAsPrefix(s);
    if (m == null || m.groupCount != 6) {
      return change;
    }
    var n = m.groups([3, 2, 1, 4, 5]).map(int.parse).toList();
    var date = Function.apply(new DateTime#, n);
    var user = m.group(6);
    return change
        ..date = date
        ..user = user;
  }

  BlokyNahled(this.root);

  List<Predmet> get courses {
    //workaround-ish code:
    final String predmet_ = 'predmet_';
    var predmets = [];
    //var predmets = root.querySelectorAll('#aplikace h3[id^="predmet_"'); // TODO(jirka): not implemented in package:html
    for (var h3 in root.querySelector('#aplikace').querySelectorAll('h3')) {
      final String id = h3.id;
      if (id.startsWith(predmet_)) {
        final i = h3.text.indexOf(' ');
        final code = h3.text.substring(0, i);
        final name = h3.text.substring(i + 1);
        predmets.add(new Predmet(id.substring(predmet_.length), code, name));
      }
    }
    return predmets;
  }

  List<Blok> bloky(id) {
    var bloky = [];
    var h3 = root.querySelector('#predmet_$id');
    var dl = h3.nextElementSibling;
    if (dl == null || dl.localName != 'dl') {
      return bloky;
    }
    var dts = dl.querySelectorAll('dt');
    for (var dt in dts) {
      final name = dt.text;
      var blokchangedate = null;
      var blokchangeuser = null;
      var bloktext = null;
      var blokposts = [];
      var dd = dt.nextElementSibling;
      if (dd != null || dd.localName == 'dd') {
        var span = dd.querySelector('span'); // last changed
        var pre = dd.querySelector('pre'); // text
        var divs = dd.querySelectorAll('div.hodn_pri'); // only in discussion forum blocks
        for (var div in divs) {
          var a = div.querySelector('a');
          var pre = div.querySelector('pre');
          blokposts.add({'url': a.attributes['href'], 'text': (pre != null) ? pre.text : ""});
          // in DartVM mi prošlo a.href
        }

        var blok;
        var change = (span != null) ? span.text : "";
        var text = (pre != null) ? pre.text : "";
        if (divs.isEmpty) {
          blok = new Blok();
        } else {
          blok = new DiscussionBlok();
          blok.posts = blokposts;
        }
        blok.name = name;
        blok.change = change;
        blok.modifiedBy = blokchangeuser;
        blok.modifiedWhen = blokchangedate;
        blok.text = text;

        bloky.add(blok);
      }
    }
    return bloky;
  }
}

// z pohledu učitele, vyžaduje browser, takže zatím disabled
//class BlokVseZobraz {
//  var blok;
//  var texts;
//  var course = 'ONLINE_A';
//  BlokVseZobraz.fromHtml(var html) {
//    blok = ismu.elementFromHtml(html);
//    texts = ismu.xpathSelector('//*[@id="aplikace"]/form', blok);
//  }
//  List<Map> process(List<String> notebooks) {
//    var rs = [];
//    
//    if (texts == null) {
//      print('skipped blok: $blok');
//      return rs;
//    }
//    
//    var notebook = '(?:' + notebooks.join(')|(?:') + ')';
//    var regexp = new RegExp('$course: ($notebook) -- .*, učo ([0-9]*) .*:(.*)\$', multiLine: true);
//    var matches = regexp.allMatches(texts.text);
//    for (var match in matches) {
//      var uco = match.group(2);
//      var nb = match.group(1);
//      var body = match.group(3);
//      var r = {'uco': uco, 'blok': nb, 'body': body};
//      rs.add(r);
//    }
//    return rs;
//  }
//  
//  static String URL(List<String> nbloku, {fakulta, obdobi, predmet}) {
//    var bloky = 'nbloku=' + nbloku.join(';nbloku=');
//    return "https://is.muni.cz/auth/ucitel/blok_vse_zobraz.pl?lang=cs;fakulta=$fakulta;obdobi=$obdobi;predmet=$predmet;$bloky";
//  }
//}