import 'data_discussion.dart' as data;
import 'data_ucitel_diskusni_fora.dart' as data_ucitel_diskusni_fora;

import 'package:ismu/discussion.dart';

import 'package:test/test.dart' as $;
import 'package:html/parser.dart' show parse;
import 'dart:convert' show JSON;

main() {
  $.group('Test Post Attributes', () {
    var post = new Post(data.post);
    $.test(
        'get text',
        () => $.expect(
            post.text,
            """Hello everybody!
Do you read books in your free time except for school literature ? Sometimes I
have no idea which book I’ll choose to read so I think that it is a good way to
inspire. Which book can you highly recommend?
Two books which I read recently and wich me really interested are The Glass room
by Simon Mawer and The Godfather by Mario Puzo.
"""));
    $.test('get id', () => $.expect(post.id(), 51003395));
    $.test('get submitted',
        () => $.expect(post.submitted(), new DateTime(2014, 10, 4, 10, 58)));
    $.test('get editted',
        () => $.expect(post.editted(), new DateTime(2014, 10, 4, 10, 58)));
    //$.test('get graded', () => $.expect(post.graded(), true));
    $.test('get notGraded', () => $.expect(post.notGraded(), false));
    //$.test('get points', () => $.expect(post.points(), 5));
    $.test('get unread', () => $.expect(post.unread(), false));
    $.test('get author', () => $.expect(post.author, 'Markéta Chalupníková'));
  });
  $.group("Test Post Absolvent", () {
    var post = new Post(data.post_absolventa);
    $.test('get author', () => $.expect(post.author, 'Iva Bandurová'));
  });

  $.group('Counting the number of posts', () {
    $.test('when everything is read', () {
      var thread = new ThreadInForumPage(data.vlaknoPrectenePrispevky);
      $.expect(thread.postCount, 95);
      $.expect(thread.unreadCount, 0);
    });
    $.test('when something is unread', () {
      var thread = new ThreadInForumPage(data.vlaknoNeprectenePrispevky);
      $.expect(thread.postCount, 9);
      $.expect(thread.unreadCount, 1);
    });
    $.test('when there is unread reaction for me', () {
      var thread = new ThreadInForumPage(data.vlaknoNeprecteneReakceNaMe);
      $.expect(thread.postCount, 10);
      $.expect(thread.unreadCount, 1);
      $.expect(thread.unreadReactionCount, 1);
    });
  });

  $.group('Pagination', () {
    $.test('no pagination', () {
      var page = new ForumPage(data.pageWithoutPagination);
      var next = page.next();
      $.expect(next, "");
    });
    $.test('last page', () {
      var page = new ForumPage(data.pageWithPaginationLast);
      var next = page.next();
      $.expect(next, "");
    });
    $.test('not a last paga', () {
      var page = new ForumPage(data.pageWithPaginationFirst);
      var next = page.next();
      $.expect(next,
          "https://is.muni.cz/auth/diskuse/diskusni_forum_indiv?guz=56128455;jn=v;st=2;hromadne=");
    });
  });

  $.group('', () {
    $.test('jaro2014', () {
      var dom = parse(data_ucitel_diskusni_fora.jaro2014);
      var groupToGuzJaro2014 = {"A level /01":"46976735", "A level /02":"46976742", "A level /03":"46976747", "A level /04":"46976750", "A level /05":"46976756", "A level /08":"46976766", "A level /09":"46976937", "A level /10":"46976969", "B level /12":"46987544", "B level /13":"46987546", "B level /14":"46987548", "B level /15":"46987550", "B level /16":"46987552", "B level /17":"46987554", "B level /18":"46987658", "B level /19":"46987763", "B level /20":"46987765", "B level /21":"46987767", "B level /22":"46987769", "B level /23":"46987771", "B level /24":"46987774", "B level /25":"46987776", "B level /26":"46987778", "B level /27":"46987780", "B level /28":"46987782", "B level /29":"46987784", "B level /30":"46987786", "B - C level /38":"46988210", "C level /37":"46988212", "C level /35":"46988214", "C level /36":"46988216"};
      var jaro2014 = new RegExp(r'For points (.*)');
      $.expect(getGroupGuzs(dom, jaro2014), groupToGuzJaro2014);
    });
    $.test('podzim2014', () {
      var dom = parse(data_ucitel_diskusni_fora.podzim2014);
      var groupToGuzPodzim2014 = {"A1":"50462366", "C2":"50462399", "C1":"50462402", "BC1":"50462405", "A2":"50462413", "A3":"50462415", "A4":"50462417", "A5":"50462419", "A6":"50462422", "B1":"50462424", "B2":"50462427", "B3":"50462429", "B4":"50462431", "B5":"50462433", "B6":"50462435", "B7":"50462437", "B8":"50462439", "B9":"50462441", "B10":"50462444", "B11":"50462446", "B12":"50462497", "B13":"50462499", "B14":"50462501", "B15":"50462503", "B16":"50462506", "B17":"50462510", "B18":"50802379", "B19":"50802482", "B20":"50802523", "B21":"50802540", "B22":"50802552", "B23":"50802560", "B24":"50980016", "B25":"50980027", "B26":"50980052"};
      var podzim2014 = new RegExp(r'(?:PdF:)?ONLINE_A/([A-Z]*[0-9]*)');
      $.expect(getGroupGuzs(dom, podzim2014), groupToGuzPodzim2014);
    });
    $.test('podzim2015', () {
      var dom = parse(data_ucitel_diskusni_fora.podzim2015);
      var groupToGuzPodzim2015 = {"Cg1":"58866392","BCg1":"58866394","BCg3":"58866395","BCg2":"58866439","BCg4":"58866441","BCg5":"58866443","Bg1":"58866444","Bg2":"58866448","Bg3":"58866449","Bg4":"58866451","Bg5":"58866463","Bg6":"58866526","Bg7":"58866532","Bg8":"58866535","Bg9":"58866536","Bg10":"58866537","Bg11":"58866540","Bg12":"58866541","Bg13":"58866542","Bg14":"58866543","Bg15":"58866544","Bg16":"58866546","Bg17":"58866548","Bg18":"58866550","Bg19":"58866554","Bg20":"58866560","Bg21":"58866562","Bg22":"58866565","Bg23":"58866566","Bg24":"58866569","Bg25":"58866572","Ag1":"58866573","Ag2":"58866574","Ag3":"58866578","Ag4":"58866579","Ag5":"58866587","Ag6":"58866604","Ag7":"58866608","Bg26":"59607736","Bg27":"59607762","Bg28":"59607799","Bg29":"59607874"};
      var podzim2015 = new RegExp(r'Discussion Forum for Points \(([A-Z]+g\d+)\)');
      $.expect(getGroupGuzs(dom, podzim2015), groupToGuzPodzim2015);
    });
  });
}
