import 'package:ismu/notebooks.dart' as notebooks;
import 'package:test/test.dart' as $;
import 'package:html/parser.dart' as dom;
import 'package:html/dom.dart' as dom;

import "data_notebooks.dart" as data;

// https://is.muni.cz/auth/student/poznamkove_bloky_nahled?studium=vse;obdobi=6184

main() {
  $.group('', () {
    $.test('', () {
      $.expect(notebooks.escapeNblokus(['a']), 'nbloku=a');
      $.expect(notebooks.escapeNblokus(['a', 'b']), 'nbloku=a;nbloku=b');
      $.expect(notebooks.escapeNblokus(['a', 'b', 'c']), 'nbloku=a;nbloku=b;nbloku=c');
      $.expect(notebooks.escapeNblokus(['Discussion Forum for Points (Bg19)']), 'nbloku=Discussion%20Forum%20for%20Points%20(Bg19)');
    });
  });
  $.group('', () {
    var b = new notebooks.RegularBlok();
    $.test('', () {
      var tt = [
        ['', 0],
        ['1', 0],
        ['*1', 1],
        ['-1', 0],
        ['*-1', -1],
        ['+1', 0],
        ['*+1', 1],
        ['*1 a *1', 2],
        ['aa*1*1aa', 2],
        ['*1 -*1', 2],

        ['*1.1', 1.1],
        ['*1,1', 1.1],
      ];
      for (var t in tt) {
        b.text = t[0];
        $.expect(b.totalPoints, t[1], reason: "text: ${b.text}");
      }
    });
  });
  $.group('', () {
    $.test('', () {
      var changed = notebooks.BlokyNahled.parseChanged(
          'změněno: 15. 9. 2014 10:56, J. Šplíchal');
      $.expect(changed.date, new DateTime(2014, 9, 15, 10, 56));
      $.expect(changed.user, 'J. Šplíchal');
    });
  });
  $.group('', () {
    var page = dom.parse(data.poznamkove_bloky_nahled);
    var bloky = new notebooks.BlokyNahled(page);

    $.test('get courses', () => $.expect(bloky.courses.first.toString(),
    new notebooks.Predmet('769221', 'ADAPT_AJ', 'Adaptivní test Aj').toString()));
    $.test('get blocks (single)', () {
      var bs = bloky.bloky('769221');
      $.expect(1, bs.length);
      var b = bs.first;
      $.expect(b, new $.isInstanceOf<notebooks.Blok>());
      $.expect(b.name, 'Výsledky testu podzim 2014');
      $.expect(b.change, 'změněno: 15. 9. 2014 10:56, J. Šplíchal');
//      $.expect(b.modifiedBy, '');
//      $.expect(b.modifiedWhen, '');
      $.expect(b.text, '*96 (C1 plus)');
    });
    $.test("get blocks (all)", () {
      var courses = bloky.courses;
      var records = {};
      for (var course in courses) {
        var id = course.id;
        records[id] = bloky.bloky(id);
      }
    });
    var onlinea = bloky.bloky(bloky.courses.firstWhere((notebooks.Predmet p) => p.code == 'ONLINE_A').id);
    $.test("discussion", () {
      var b2 = onlinea.firstWhere((notebooks.Blok b) => b.name == 'PdF:ONLINE_A/BC1 Discussion For Points');
      var sum =  onlinea.firstWhere((notebooks.Blok b) => b.name == 'Sum of Points from Discussion');

      $.expect(sum.totalPoints, 160);

      $.expect(b2.totalPoints, 115);
    });
  });
}