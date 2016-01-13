import 'package:test/test.dart' show group, test, expect;

import 'package:html/dom.dart' show Element, Text;
import 'package:html/parser.dart' show parse;

import 'package:ismu/notebooks.dart' show BlokVseZobraz;
import 'data_technicky_blok.dart' as data;

main() {
  group('parse', () {
    var dom = parse(data.technicky_vypis);
    var b = new BlokVseZobraz.fromDom(dom);
    var p = b.process(['Discussion Forum for Points (BCg3)']);

    test('p', () {
      expect(p.first['uco'], '397578');
      expect(p.first['text'].split('\n').first, '[df_id:59568375]');
    });
  });
}