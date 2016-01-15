import 'dart:async' show Future, Timer, Completer, Stream;
import 'dart:io' show Cookie, ContentType;
import 'dart:io' show File;
import 'dart:convert' show UTF8;

import 'dart:io' show HttpClient, HttpClientRequest, HttpClientResponse;
// TODO(jirka): reevaluate if package:http is worth it
import 'package:http/http.dart' show Client, ClientException, Response;
import 'package:html/parser.dart' show parse;

import 'package:ismu/is.dart' show CONFIG, LogInPage;
import 'package:ismu/discussion.dart' show Forum, ForumPage, Post, getGroupGuzs, streamAllPosts, markAllUngraded;
import 'package:ismu/notebooks.dart' show BlokHistorie;

import 'package:onlinea_apps/password.dart' show USERNAME, PASSWORD;

import 'package:postgresql/postgresql.dart' as pg;

//TODO: consider faking HttpClient and injecting that
/// Fake implementation that relies on the pageStore
class OfflineImprovedClient extends ImprovedClient {
  OfflineImprovedClient(PageStore pageStore) : super(pageStore);

  Future<String> _get(String url) {
    return null;
  }

  Future<String> post(String url, {contentType, Map headers, String body}) {
    return null;
  }

  // TODO: do I need this? Not now.
//  noSuchMethod(Invocation invocation) => null;

}

class ImprovedClient implements HttpClient {
  HttpClient client = new HttpClient();
  List<Cookie> jar = [];
  int failures = 0;

  var _pageStore;

  ImprovedClient(this._pageStore);

  /// with retry and caching
  Future<String> get(String url) async {
    var text = await _pageStore.loadPage(url);
    if (text != null) {
      return text;
    }
    text = await _tryPerform(() => _get(url));
    if (text != null) {
      _pageStore.storePage(url, text);
    }
    return text;
  }

  Future<String> _get(String url) async {
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.persistentConnection = false;
    request.followRedirects = false;
    request.cookies.addAll(_cookies());
    HttpClientResponse response = await request.close();
    _storeCookies(response.cookies);
    return response.transform(UTF8.decoder).join();
  }

  Future<String> post(String url, {contentType, Map headers, String body}) async {
    HttpClientResponse response = await _tryPerform(() async {
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.persistentConnection = false;
      request.followRedirects = false;
      request.headers.contentType = contentType;
      request.cookies.addAll(_cookies());
      var b = UTF8.encode(body);
      request.contentLength = b.length;
      request.write(body);
      return request.close();
    });
    _storeCookies(response.cookies);
    return response.transform(UTF8.decoder).join();
  }

  _tryPerform(f) async {
    var lastException;
    for (var i = 0; i < 5; i++) {
      try {
        return await f();
      } catch (e) {
        lastException = e;
      }
    }
    throw lastException;
  }

  // adapted from GO's http.PostForm
  Future<String> postForm(String url, Map<String, String> formData) async {
    var body = new Uri(queryParameters: formData).query;
    var contentType = new ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
    return post(url, contentType: contentType, body: body);
  }

  /// returns the last saved cookie of each name and compacts the jar
  _cookies () {
    var names = {};
    for (var cookie in jar) {
      names[cookie.name] = cookie;
    }
    jar = names.values.toList();
    return jar;
  }

  _storeCookies(List<Cookie> cookies) {
    jar.addAll(cookies);
  }

  close() => client.close();
}

init(client) {
  CONFIG.get = (url, shouldDelay) => client.get(url);
  CONFIG.postFormData = (String url, Map data) => client.postForm(url, data);
}

main() async {
  var pageStore = new PageStore();
  await pageStore.connect();
  var client = new ImprovedClient(pageStore);
//  var client = new OfflineImprovedClient(pageStore);
  init(client);

  var result;
  result = await LogInPage.logIn(USERNAME, PASSWORD);


//  print(result);

  //downloadDiscussion(client, '58866587'); // empty forum with one thread and message

//  for (var guz in (await downloadGuzs(client)).values) {
//    await downloadDiscussion(client, guz);
//  }

  var guzs = await downloadGuzs(client);
//  await teacherDates(guzs: guzs, pageStore: pageStore, client: client);
//  await studentDates(guzs: guzs, pageStore: pageStore, client: client);

  await markUngraded(guzs);

  print("exiting");

  await pageStore.flush();
  pageStore.disconnect();
  client.close();

}

class FakeProgress {
  failed(m) => print(m);
  noSuchMethod(Invocation invocation);



markUngraded(guzs) async {
  for (var guz in guzs.values) {
    print(guz);
    await markAllUngraded(discussionForumUrl(guz), new FakeProgress());
  }
}

studentDates({guzs, pageStore, client}) async {
  var studentdates = {};
  var teachers = {};
  await for (var tg in getTeacherMapping(client, guzs)) {
    teachers[tg[0]] = tg[1];
  }

//  print(teachers);
//  throw 'halt';

  var f = (Post post, {guz}) {
    var teacher = teachers[guz];
    if (!studentdates.containsKey(teacher)) {
      studentdates[teacher] = [];
    }
    studentdates[teacher].add(new GuzDate(guz, post.submitted()));
  };

  for (var guz in guzs.values) {
    await downloadDiscussionForEachDo(client, guz, f);
  }

  return writeOut(studentdates, 'studentdates.txt');
}

Stream<List> getTeacherMapping(client, guzs) async* {
  var fakulta = '1441';
  var obdobi = '6343';
  var predmet = '835600';
  for (var guz in guzs.values) {
    var url = 'https://is.muni.cz/auth/diskuse/diskusni_forum_nastaveni?fakulta=$fakulta;obdobi=$obdobi;predmet=$predmet;akce=edit;predmet_id=$predmet;guz=$guz';
    var page = await client.get(url);
    var dom = parse(page);
    var h = dom.querySelectorAll('h4').firstWhere((e)=>e.text == 'Moderátoři');
    var table = h.nextElementSibling;

    var regexp = new RegExp(r'([A-Z])\S+ (\S+),');
    var moderators = table.querySelectorAll('td').map((e)=>e.innerHtml);
    var teacher = '';
    for (var moderator in moderators) {
      var m = regexp.firstMatch(moderator);
      if (m != null && !['Zerzová', 'Váňová', 'Daněk'].contains(m.group(2))) {
        teacher = '${m.group(1)}. ${m.group(2)}';
        yield [guz, teacher];
      }
    }
  }
}

teacherDates({guzs, pageStore, client}) async {
  var teacherdates = {};
  var f = (record, {guz}) {
//    print('${record.event}: ${record.date}, ${record.osoba}'
  if (!teacherdates.containsKey(record.osoba)) {
    teacherdates[record.osoba] = [];
  }
  teacherdates[record.osoba].add(new GuzDate(guz, record.date));
 };

    for (var code in guzs.keys) {
      var name = 'Discussion Forum for Points (${code})';
      await downloadBlokForEachDo(client, name, f);
    }

  return writeOut(teacherdates, 'inforum-teacherdates-sessions.txt');
}

class GuzDate {
  String guz;
  var date;
  GuzDate(this.guz, this.date);
}

writeOut(Map<String, List<GuzDate>> dates, filename) async {
    for (var k in dates.keys) {
    dates[k].sort((gd1, gd2) => gd1.date.compareTo(gd2.date));

    // enable if doing session lengths
      dates[k] = computeSessionLengths(dates[k]);
  }

  // dates is now just List of something time related and toString()able
  var out = new File(filename).openWrite();
  for (var k in dates.keys) {
    print("$k ${dates[k].length}");
    await out.writeln("${k}, ${dates[k].join('\t')}");
  }
  return out.close();
}

List<num> computeSessionLengths(List<GuzDate> data) {
  var lengths = [];
  var sessionIdle = new Duration(minutes: 30);
  GuzDate previous = null;
  for (var gd in data) {
    if (previous != null && previous.guz == gd.guz) {
      DateTime date = gd.date;
      var length = date.difference(previous.date);
      if (length < sessionIdle) {
        lengths.add(length.inSeconds);
      }
    }
    previous = gd;
  }
  return lengths;
}

downloadGuzs(var client) async {
  var url = 'https://is.muni.cz/auth/ucitel/ucitel_diskusni_fora?fakulta=1441;predmet=775322;obdobi=6343';
  var page = await client.get(url);
  var dom = parse(page);
  var guzs = getGroupGuzs(dom, new RegExp(r'Discussion Forum for Points \(([A-Z]+g\d+)\)'));
  return guzs;
}

discussionForumUrl(guz) {
    return "https://is.muni.cz/auth/diskuse/diskusni_forum_indiv?guz=$guz";
}

downloadDiscussionForEachDo(var client, var guz, f) async {
  var url = discussionForumUrl(guz)
  var dom = parse(await client.get(url));
  var forumPage = new ForumPage(dom);
  var forum = new Forum(forumPage);
  await for (var thread in forum.streamThreads()) {
    await for (var post in thread.streamPosts()) {
      f(post, guz: guz);
    }
  }
}

downloadBlokForEachDo(var client, var name, f) async {
  var url = BlokHistorie.URL([name], fakulta: '1441', obdobi: '6343', predmet: '835600');
  var page = await client.get(url);
  print(name);
//  var dom = parse(page);
//  var blok = new BlokHistorie.fromDom(dom);
//  var records = blok.parse();
  var records = BlokHistorie.parsePlain(page);
  for (var record in records) {
    f(record);
  }
}

class PageStore {
  pg.Connection _conn;
  int _inFlight = 0;

  connect() {
    return pg.connect('postgres://jirka@127.0.0.1:5432/ismu').then((conn) => _conn = conn)
    .catchError((e) { print('error connecting: $e'); });
  }

  disconnect() {
    _conn.close();
  }

  storePage(url, text) {
    var f = _conn.execute("INSERT INTO pages(url, text) VALUES (@url, @text);", {'url': url, 'text': text});
    _addInFlight(f);
  }

  loadPage(url) async {
    var f = _conn.query("SELECT text, ctime FROM pages WHERE url=@url ORDER BY ctime DESC LIMIT 1", {'url': url});
    await for (var row in f) {
      return row.text;
    }
    return null;
  }

  flush() {
    var t;
    var f = new Completer();
    t = new Timer.periodic(new Duration(milliseconds: 50), (_) {
      if(_inFlight == 0) {
        f.complete(true);
        t.cancel();
      }
    });
    return f.future;
  }

  _addInFlight(f) async {
    try {
      _inFlight++;
      await f;
    } finally {
      _inFlight--;
    }
  }
}