import 'data_discussion.dart' as data;

import 'package:ismu/discussion.dart';

import 'package:test/test.dart' as $;

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
}
