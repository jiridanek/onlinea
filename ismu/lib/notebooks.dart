//import "dart:html" as dom;
//import "package:ismu/ropot.dart" as ismu;
import "package:ismu/is.dart" as ismu;

class Predmet {
  var id;
  var code;
  var name;

  Predmet(this.id, this.code, this.name);

  toString() {
    return {'id':id, 'code':code, 'name':name}.toString();
  }
}

abstract class Blok {
  String name;
  String modifiedBy;
  String modifiedWhen;
  String change;

  static _totalPointsIn(String str) {
    // originally in lib/blok.pm
    var float = new RegExp(r'\*([+-]?\d+([.,]\d+)?)');
    var ms = float.allMatches(str);
    var total = ms.fold(0, (s, m) => s + num.parse(m.group(1).replaceAll(',', '.')));
    return total;
  }

  num get totalPoints;
}

class RegularBlok extends Blok {
  String text;

  num get totalPoints {
    return Blok._totalPointsIn(text);
  }
}

class DiscussionBlok extends Blok {
  List<Post> posts;

  num get totalPoints {
    return posts.fold(0, (s, n) => s + Blok._totalPointsIn(n.text));
  }
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
    if (h3 == null) {
      return bloky;
    }
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
          var comment = div.querySelector('pre');
          blokposts.add(new Post()
            ..url = a.attributes['href'] // in DartVM mi prošlo a.href
            ..text = (comment != null) ? comment.text : "");
        }

        var blok;
        var change = (span != null) ? span.text : "";
        var text = (pre != null) ? pre.text : "";
        if (divs.isEmpty) {
          blok = new RegularBlok()
              ..text = text;
        } else {
          blok = new DiscussionBlok()
              ..posts = blokposts;
        }
        blok.name = name;
        blok.change = change;
        blok.modifiedBy = blokchangeuser;
        blok.modifiedWhen = blokchangedate;

        bloky.add(blok);
      }
    }
    return bloky;
  }
}

//class AnglictinaOnline {
//  _fakulta = '';
//  _obdobi = '';
//  _predmet = '';
//  _kod = 'ONLINE_A';
//}
//
//class AnglictinaOnlineNotebooks {
//  _totalPoints = 'Total Points ()';
//  _discussionPoints = 'Discussion Points';
//  _discussionPrefix = 'Discussion Forum for Points (';
//
//  isDiscussion(String name) => name.startsWith(_discussionPrefix;
//  isSuma(String name) {
//    for (n in ['Total Points', 'Discussion Points', 'Deadline Assignment', 'Colloquium']) {
//      if (name.startsWith(n)) {
//          return true;
//      }
//    }
//    return false;
//  }
//}
//
//class AnglictinaOnline2014 {
//  _obdobi = '';
//}
//
//class AnglictinaOnline2014Notebooks extends AnglictinaOnlineNotebooks {
//  _totalPoints = ;
//  _discussionPoints = ;
//  _discussionPrefix = ;
//}



// z pohledu učitele
class BlokVseZobraz {
  String _text;

  var course;
  var notebook;
  var student;
  var uco;
  var fakulta;
  var program;
  var obor;
  var rest;
  var current = null;

  var rs = [];

  static String URL(List<String> nbloku, {fakulta, obdobi, predmet}) {
    var bloky = escapeNblokus(nbloku);
    return "https://is.muni.cz/auth/ucitel/blok_vse_zobraz.pl?lang=cs;fakulta=$fakulta;obdobi=$obdobi;predmet=$predmet;$bloky";
  }

  BlokVseZobraz.fromDom(dom) {
    _text = dom.querySelector('*[id=aplikace] > form').innerHtml;
  }

  List<Map> process(List<String> notebooks) {
    var regexp = new RegExp(r'([\w-_]*): (.*) -- (.*), učo (\d+) <b [^>]+>(.*)</b> <span [^>]+>(.*)</span> <span [^>]+>(.*)</span> (.*):$');
    for (var line in _text.split('\n')) {
      var match = regexp.firstMatch(line);
      if (match != null) {
        addRecord();

        course = match.group(1);
        notebook = match.group(2);
        student = match.group(3);
        uco = match.group(4);
//        fakulta = match.group(4);
//        program = match.group(5);
//        obor = match.group(6);
//        rest = match.group(7);

        current = [];
      } else if (current != null) {
        current.add(line);
      } else {
        // ignore line
      }
    }
    addRecord();
    return rs;
  }

  addRecord() {
    if (current != null) {
      var record = {'uco': uco};
      record['text'] = current.join('\n');
      rs.add(record);
    }
  }
}

escapeNblokus(List<String> nblokus) {
  return 'nbloku=' + nblokus.map((s) => Uri.encodeFull(s)).join(';nbloku=');
}

class HistorieRecord {
  var name;
  var uco;
  var event;
  var text;
  DateTime date;
  String osoba;

  String toString() {
    return [name, uco, event, text, date, osoba].toString();
  }

}

class BlokHistorie {
  List _lis;

  //TODO: add lang=cs and vc_zrusenych = 1
  static String URL(List<String> nblokus, {fakulta, obdobi, predmet}) {
    var bloky = escapeNblokus(nblokus);
    return 'https://is.muni.cz/auth/ucitel/blok_historie?fakulta=${fakulta};obdobi=${obdobi};predmet=${predmet};${bloky};razeni=cas;vc_zrusenych=';
  }

  BlokHistorie.fromDom(dom) {
    var ol = dom.querySelector('*[id=aplikace] > form > ol');
    _lis = ol?.querySelectorAll('li') ?? [];
  }

  /// This method is always wrong in case the date in blok are messy: unescaped HTML
  /// (see tests)
  List<HistorieRecord> parse() {
    return _lis.map(_parseLi).where((e) => e != null).toList();
  }

  HistorieRecord _parseLi(li) {
    List<String> lines = li.innerHtml.split('\n');
    var header = lines[0];
    var body = lines.sublist(1, lines.length - 1); // skip last empty line
    var date;
    var name;

    var list = parseTimestamp(body.last);
    if (list.length == 2) {
      date = list[0];
      name = list[1];
    } else {
      print('parseTimestamp failed to parse a li');
    }

    var re = parseHeader(header);
    var r = re[0];
    var end = re[1];
    if (re != null) {
      r
        ..text = body.join('\n')
        ..date = date
        ..osoba = name;
    }
    return r;
  }

  static List parseHeader(String line) {
    var regex = new RegExp(r'^<b>(.*)</b> \(učo (\d+)\)<br>ONLINE_A <i>(\S+)</i>:?\s*', caseSensitive: false);
    var m = regex.firstMatch(line);
    if (m != null) {
      var r = new HistorieRecord()
          ..name = m.group(1)
          ..uco = m.group(2)
          ..event = m.group(3);
      return [r, m.end];
    }
    print('parseHeader: failed to parse a li');
    return null;
  }

  static List parseTimestamp(String line) {
        var regexp = new RegExp(r'\((\d+)\. (\d+)\. (\d+) (\d+):(\d+).(\d+), (.*)\)$', caseSensitive: false);
    var n = regexp.firstMatch(line);
    if (n != null) {
      var args = n.groups([3, 2, 1, 4, 5, 6]).map(int.parse).toList();
      var date = Function.apply(new DateTime#, args);
      var name = n.group(7);
      return [date, name];
    }

    return null;
  }

  static List<HistorieRecord> parsePlain(String text) {
    var lines = text.split('\n');
    var start;
    var end;
    var i = 0;
    for (var line in lines) {
      if (line.startsWith(r'<input type="hidden" name="razeni" value="cas">Řadit dle změny')) {
        start = i;
      } else if (line.startsWith(r'</div> <!-- aplikace -->')) {
        if (lines[i-1] != '</form>') {
          if (lines [i-2].endsWith(r'</script>')) {
            print('parsePlain: blok does not exist');
            return [];
          }
          print('parsePlain: parser got lost (1)');
          return null;
        }
        end = i - 3;
      }
      i++;
    }

    if (start == null || end == null) {
      print('parsePlain: parser got lost (2)');
      return null;
    }
    if (end < start) {
      return [];
    }
    lines[start] = lines[start].split(r'<OL>')[1];

    var result = [];

    for (var i = start; i <= end; i++) {
      var ri = parsePlainRecord(lines, i, end);
      var r = ri[0];
      i = ri[1];

      result.add(r);
    }
    return result;
  }

  static List parsePlainRecord(lines, i, end) {
    var date;
    var name;

      if (!lines[i].startsWith(r'<LI>')) {
        print('parsePlain: parser got lost (3)');
        return null;
      }
      var header = lines[i].substring(r'<LI>'.length);
      var bodystart = i + 1;

      for (; i <= end; i++) {
        var m = parseTimestamp(lines[i]);
        if (m != null) {
            date = m[0];
            name = m[1];
          break;
        }
      }

      var re = parseHeader(header);
      var r = re[0];
      var headerend = re[1];
      String rest = header.substring(headerend);
      if (rest.trim() == '') {
        rest = '';
      } else {
        rest = rest + '\n';
      }
      if (re != null) {
        r
          ..text = rest + lines.sublist(bodystart, i + 1).join('\n')
          ..date = date
          ..osoba = name;
      } else {
        print('adding null to result');
      }
      return [r, i];
  }
}