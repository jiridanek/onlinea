import 'package:ismu/notebooks.dart' as notebooks;
import 'package:test/test.dart' as $;
import 'package:html/parser.dart' as dom;
import 'package:html/dom.dart' as dom;

import "data_notebooks.dart" as data;

main() {
  $.group('', () {
    var page = dom.parse(data.poznamkove_bloky_nahled);
    var bloky = new notebooks.BlokyNahled(page);
    $.test('get courses', () => $.expect(bloky.courses.first.toString(),
    new notebooks.Predmet('769221', 'ADAPT_AJ', 'Adaptivní test Aj').toString()));
    $.test('get blocks (single)', () => $.expect(bloky.bloky('769221'),
    [{'name': 'Výsledky testu podzim 2014',
      'change': 'změněno: 15. 9. 2014 10:56, J. Šplíchal',
      'text': '*96 (C1 plus)',
      'posts': []}]));
    $.test("get blocks (all)", () {
      var courses = bloky.courses;
      var records = {};
      for (var course in courses) {
        var id = course.id;
        records[id] = bloky.bloky(id);
      }
    });
  });
}