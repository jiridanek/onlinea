import 'package:test/test.dart';
import 'package:html/parser.dart' show parse;

import 'package:ismu/notebooks.dart';
import 'data_historie.dart' as data;

main() {
  group('historie', () {
    var dom = parse(data.historie);
    var h = new BlokHistorie.fromDom(dom);
    test('can', () {
      var p = h.parse();
    });
  });
}