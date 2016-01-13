import 'package:html/dom.dart' as dom;
import 'package:test/test.dart';

main() {
  group('Select b inside span', () {
    final div = new dom.Element.html(
        r"""<div><span class="prep_nove"><b>1</b></span></div>""");

    test('using two separate selectors', () {
      var b = div.querySelector("span.prep_nove").querySelector("b");
      expect(b, isNotNull);
      expect(b.text, '1');
    });
    test('using one combined selector', () {
      var b = div.querySelector("span.prep_nove b");
      expect(b, isNotNull);
      expect(b.text, '1');
    });
  });
}

