import 'package:test/test.dart';
import 'package:html/parser.dart' show parse;

import 'package:ismu/notebooks.dart';
import 'data_historie.dart' as data;

checkHistorie(p) {
  var f = p.first;
  expect(f.event, 'vytvoření');
  expect(f.name, 'Kratochvílová, Denisa');
  expect(f.uco, '392089');
  expect(f.text.split('\n').first, '[df_id:59326573]');
  expect(f.date, new DateTime(2015, 9, 28, 8, 39, 58));
  expect(f.osoba, 'P. Buchtová');
}
checkUnescapedHtml(d) {;
  for (var r in d) {
    for (var line in r.text.split('\n')) {
      if (line == r'<I don´t like books about ghosts and OTHER scary books>') {
        return;
      }
    }
  }
  throw 'line not found';
}

main() {
  group('historie', () {
    var dom = parse(data.historie);
    var h = new BlokHistorie.fromDom(dom);
    test('parse', () {
      var p = h.parse();
      checkHistorie(p);
    });
    test('parsePlain', () {
      var d = BlokHistorie.parsePlain(data.historie);
      checkHistorie(d);
    });
    test('equalResults', () {
      var p = h.parse();
      var d = BlokHistorie.parsePlain(data.historie);

      var i1 = d.map((e)=>e.toString()).iterator;
      var i2 = p.map((e)=>e.toString()).iterator;
      do {
        expect(i1.current, i2.current);
      } while (i1.moveNext() && i2.moveNext());
      expect(i1.moveNext(), false);
      expect(i2.moveNext(), false);
    });
  });

  group('unescapedHtml', () {
    test('parsePlain', () {
      var d = BlokHistorie.parsePlain(data.unescapedHtml);

      checkUnescapedHtml(d);
    });
  });

  group('unittests', () {
    test('no newline after header', () {
      var text =
r"""<LI><B>Chaloupková, Markéta</B> (učo 390728)<BR>ONLINE_A <I>změna</I>: [df_id:59421708]
*5
[df_id:59421504]
*5 (9. 12. 2015 11:22.30, J. Sedláčková)""";
      var ri = BlokHistorie.parsePlainRecord(text.split('\n'), 0, 3);
      expect(ri[0].text.split('\n').first, '[df_id:59421708]');
    });
  });
}