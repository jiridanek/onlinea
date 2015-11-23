/*
 * statistika
 * kumulativní graf získaných bodů na čase pro studenta
 * příspěvky v diskusi a ohodnocení příspěvků
 * shluknout průběhy
 */

import 'package:html/dom.dart' as dom;
import 'dart:core';
import 'dart:async' as async;

import 'is.dart';
import 'is.dart' as ismu;

//xpathSelectorAllTest() {
//  var query = '//p';
//  var element = new dom.Element.html('<div><p>pes</p><p>les</p></div>');
//  var ps = xpathSelectorAll(query, element);
//  print(ps.length);
//}

//void main() {
//  dom.querySelector("#text_id").onClick.listen(run);
//  run(null);
//  //evaluate('count(//p)', '<p>df</p>');
//  //xpathSelectorAllTest();
//}

const idPrefixPost = 'pr_ce_';
const allPostsXpath = "//*[starts-with(@id, '${idPrefixPost}')]";
// obsolete
const allPostsCssPath = "*[id^='${idPrefixPost}']";
const newPostClass = 'df_pr_nect';

var gradeClass = 'hodn_pri';

var baseUrl = 'https://is.muni.cz';

_fetchMySeminarGroups(String html) {
  var groups = [];
  dom.Element el = ismu.elementFromHtml(html);
  var tableRows = el.querySelectorAll("#aplikace > form > table.data1 > tbody > tr.stav1");
  for (dom.Element tr in tableRows) {
    var courseAhref = tr.querySelector("th > a");
    String group = tr.nextElementSibling.querySelector("td > div > h5").text; // "ONLINE_A/BC1"
    groups.add(group);
  }
  return groups;
}

var u_fetchMySeminarGroups = _fetchMySeminarGroups;

// podzim2014 term=6184
async.Future<List> fetchMySeminarGroups(int term) {
  var completer = new async.Completer();
  var url = "https://is.muni.cz/auth/seminare/student.pl?obdobi=${term};lang=cs";
  get(url).then((String html) {
    completer.complete(_fetchMySeminarGroups(html));
  });
  return completer.future;
}

async.Future<List> fetchMySeminarGroup(int term, String course) {
  var completer = new async.Completer();
  fetchMySeminarGroups(term).then((groups) {
    completer.complete(
        groups.where((g) => g.course == course)
    );
  });
  return completer.future;
}

/*

 * https://is.muni.cz/auth/ucitel/ucitel_diskusni_fora.pl?fakulta=1441;predmet=771131;obdobi=5846 

var out = {};

var nastavenis = document.querySelectorAll("#aplikace > ul:nth-child(14) > li > ul:nth-child(3) > li > a:nth-child(2)");
for(var i = 0; i <  nastavenis.length; i++) {
  var a = nastavenis[i].previousElementSibling;
  if (/For points/.test(a.text)) {
    console.log(a.text);
    var name = /For points (.*)/.exec(a.text)[1];
    var guz = /guz=([0-9]*)/.exec(a.href)[1];
    out[name] = guz;
  }
}

console.log(window.JSON.stringify(out));

 * https://is.muni.cz/auth/ucitel/ucitel_diskusni_fora.pl?fakulta=1441;obdobi=6084;predmet=771131
 
var out = {};

var nastavenis = document.querySelectorAll("#aplikace > ul:nth-child(14) > li > ul:nth-child(3) > li > a:nth-child(2)");
for(var i = 0; i <  nastavenis.length; i++) {
  var a = nastavenis[i].previousElementSibling;
  if (/Discussion For Points/.test(a.text)) {
    console.log(a.text);
    var name = /PdF:ONLINE_A\/([A-Z]*[0-9]*)/.exec(a.text)[1];
    var guz = /guz=([0-9]*)/.exec(a.href)[1];
    out[name] = guz;
  }
}

console.log(window.JSON.stringify(out));

 */

var groupToGuzJaro2014 = {"A level /01":"46976735", "A level /02":"46976742", "A level /03":"46976747", "A level /04":"46976750", "A level /05":"46976756", "A level /08":"46976766", "A level /09":"46976937", "A level /10":"46976969", "B level /12":"46987544", "B level /13":"46987546", "B level /14":"46987548", "B level /15":"46987550", "B level /16":"46987552", "B level /17":"46987554", "B level /18":"46987658", "B level /19":"46987763", "B level /20":"46987765", "B level /21":"46987767", "B level /22":"46987769", "B level /23":"46987771", "B level /24":"46987774", "B level /25":"46987776", "B level /26":"46987778", "B level /27":"46987780", "B level /28":"46987782", "B level /29":"46987784", "B level /30":"46987786", "B - C level /38":"46988210", "C level /37":"46988212", "C level /35":"46988214", "C level /36":"46988216"};

//var groupToGuzPodzim2014 = {"A1":"50462366","C2":"50462399","C1":"50462402","BC1":"50462405","A2":"50462413","A3":"50462415","A4":"50462417","A5":"50462419","A6":"50462422","B1":"50462424","B2":"50462427","B3":"50462429","B4":"50462431","B5":"50462433","B6":"50462435","B7":"50462437","B8":"50462439","B9":"50462441","B10":"50462444","B11":"50462446","B12":"50462497","B13":"50462499","B14":"50462501","B15":"50462503","B16":"50462506","B17":"50462510"};
var groupToGuzPodzim2014 = {"A1":"50462366", "C2":"50462399", "C1":"50462402", "BC1":"50462405", "A2":"50462413", "A3":"50462415", "A4":"50462417", "A5":"50462419", "A6":"50462422", "B1":"50462424", "B2":"50462427", "B3":"50462429", "B4":"50462431", "B5":"50462433", "B6":"50462435", "B7":"50462437", "B8":"50462439", "B9":"50462441", "B10":"50462444", "B11":"50462446", "B12":"50462497", "B13":"50462499", "B14":"50462501", "B15":"50462503", "B16":"50462506", "B17":"50462510", "B18":"50802379", "B19":"50802482", "B20":"50802523", "B21":"50802540", "B22":"50802552", "B23":"50802560", "B24":"50980016", "B25":"50980027", "B26":"50980052"};

async.Future postNewThread(String guz, String subject, String body, {bool isHtml:false}) {
  //var guz = '50462499';
  var urlsuffix = "/auth/diskuse/diskusni_forum_indiv.pl?guz=${guz};vl_zal=1;re=1" /*;lang=cs"*/;
  var url = "https://is.muni.cz" + urlsuffix;
  return dom.HttpRequest.postFormData(url, {
    "guz": guz,
//    _:5255808582
    "dfos_vl": '',
    "vyhl_ban_${guz}": '',
    "dfos_pr": '',
    "slo_test": '',
    "upr":'',
    "jn": 'v',
    "expar": '1',
    "vl_zal": '1',
    "re_za": 're',
    "SENAZEV_${guz}": subject,
    "SEZKRA_${guz}": '',
    "SETEXT_${guz}": body,
    "SETETYP_${guz}": isHtml ? 'ht' : 'tf',
    "edsezav": 'Uložit',
    "preves": '',
  });
}


class ThreadPage {
  static const paginationDivQuery = '//*[@id="aplikace"]//div[@class="strankovani"]';
  static const paginationCssQuery = '#aplikace div.strankovani';

  var element;

  // Element Document

  ThreadPage(this.element);

  static fromHtml(html) {
    return new ThreadPage(elementFromHtml(html));
  }

  static String urlFromGuz(guz) {
    return "https://is.muni.cz/auth/diskuse/diskusni_forum_indiv.pl?lang=cs;jp=v;guz=$guz";
  }

  Iterable<Post> get posts {
    var re = new RegExp('^${idPrefixPost}[0-9]*\$');
    // allPostsCssPath matches pr_ce_$id and also pr_ce_ajax_$id (the favorite stars)
    var elements = element.querySelectorAll(allPostsCssPath).where((e) => re.hasMatch(e.id));
    //print(elements.length);
    //print(elements.first);
    //print(elements.first.innerHtml);
    //throw('halt');
    var posts = elements.map((e) => new Post(e));
    return posts;
  }

  String next() {
    dom.Element paginationDiv = element.querySelector(paginationCssQuery);
    if (paginationDiv == null) {
      return '';
    }
    var a = paginationDiv.querySelector("a[title=další]");
    if (a != null) {
      var url = a.attributes['href'];
      return baseUrl + url;
    }
    return '';
  }
}

dom.Element lastChild(dom.Element el) {
  return el.children.last;
}

class ForumPage {
  var paginationXpath = '//*[@id="aplikace"]/form/div[3]';

  //obsolete
  var paginationCssPath = '#aplikace div.strankovani';

  static fromHtml(String html) {
    return new ForumPage(elementFromHtml(html));
  }

  var element;

  //dom.Element dom.Document
  ForumPage(this.element);

  Iterable<Thread> get threads {
    var query = element.querySelectorAll(allPostsCssPath); //xpathSelectorAll(allPostsXpath, element);
    //print(element.innerHtml);
    //print(query);
    //throw('halt');
    var threads = query.map((e) {
      var url = e.querySelector('h4 a').attributes['href'];
      return new Thread.fromUrl(baseUrl + url);
    });
    //print(threads.first.url);
    //throw('halt');
    return threads;
  }

  String next() {
    var pagination = element.querySelector(paginationCssPath); //xpathSelector(paginationXpath, element);
    if (pagination == null) {
      return '';
    }
    dom.Element a = pagination.querySelector('a[title=další]');
    if (a != null) {
      //if (last is dom.AnchorElement && last.nodeName == 'A') {
      var link = baseUrl + a.attributes['href'];
      return link;
    }
    return '';
  }
}

class ThreadInForumPage {
  dom.Element element;

  ThreadInForumPage(this.element);

  static nextNode(dom.Element e) {
    var result;
    var found = false;
    for (var n in e.parentNode.nodes) {
      if (found) {
        result = n;
        break;
      }
      found = e.text == n.text;
    }
    return result;
  }

  get postCount {
    var text;

    var a = element.querySelector("div.operace + a");
    if (a != null) {
      text = nextNode(a).text;
      //FIXME: a.nextNode.text
    } else {
      // have unread posts
      var span = element.querySelector("span.prep_vs");
      text = span.text;
    }
    var count = new RegExp(r'\d+').stringMatch(text);
    return int.parse(count);


  }

  get unreadCount {
    var b = element.querySelector("span.prep_nv > b");
    return (b != null) ? int.parse(b.text) : 0;
  }

  get unreadReactionCount {
    var b = element.querySelector("span.prep_nove").querySelector("b"); //FIXME: bug in html5lib
    return (b != null) ? int.parse(b.text) : 0;
  }
}

class Post {
  dom.Element element;
  var g;

  Post.$(){
  }

  // creates uninicialized instance, to avoid creating abstract class to serve as an interface
  Post(this.element) {
    var msg = element.querySelector("span.pr_vloz_ret").firstChild.text; // get only the TextNode
    "6. 3. 2014 23:42, Iva Bandurová, " //absolventka
    "4. 10. 2014 10:58, Markéta Chalupníková (stud ESF MU), ";
    "11. 9. 2014 21:45 (změněno 20. 9. 2014 12:29), moderátor Jiří Daněk (stud FI MU), ";
    r"(\d+). (\d+). (\d+) (\d+):(\d+)( \(změněno (\d+). (\d+). (\d+) (\d+):(\d+)\))?, ([^\(]*) ([^\(]*), ";
    var datum_cas = r"(\d+). (\d+). (\d+) (\d+):(\d+)";
    var zmena_datum_cas = r" \(změněno " + datum_cas + r"\)";
    var moderator_jmeno = r"([^\(]+)";
    var pracoviste = r"\(([^\(]+)\)";
    var r = new RegExp(datum_cas
    + "(?:" + zmena_datum_cas + ")?, "
    + moderator_jmeno
    + "(?:" + pracoviste + ")?"); // absolvent nemá fakultu/pracoviště
    var m = r.firstMatch(msg);
    this.g = m.group;

    //verbose printout
//    for (var i = 0; i <= m.groupCount; i++) {
//      print("g($i): ${g(i)}");
//    }
  }

  num id() {
    //print(element);
    //print(element.innerHtml);
    //print(element.id);
    return num.parse(element.id.substring(idPrefixPost.length));
  }


  get text {
    var pre = element.querySelector('div.pr_te > pre');
    if (pre != null) {
      return pre.text;
    }
    return element.querySelector('div.pr_te').text;
  }

  get author {
    String s = g(11).trim();
    if (s.endsWith(",")) {
      // regex pridava absolventovi carku za jmeno
      return s.substring(0, s.length - 1);
    }
    return s;
  }

  DateTime submitted() {
    return new DateTime(int.parse(g(3)), int.parse(g(2)), int.parse(g(1)), int.parse(g(4)), int.parse(g(5)));
  }

  /// @returns null if never
  DateTime editted() {
    try {
      return new DateTime(int.parse(g(8)), int.parse(g(7)), int.parse(g(6)), int.parse(g(9)), int.parse(g(10)));
    } on ArgumentError catch (e) {
      return submitted();
    }
  }

  async.Future<DateTime> graded() {

  }

  bool unread() {
    return element.classes.contains(newPostClass);
  }

  bool notGraded() {
    var gradeArea = element.querySelector('.${gradeClass}');
    if (gradeArea == null) {
      // - author is not a student in the course
      // - forum has grading disabled
      // - ...?
      return false;
    }
    //print(element.innerHtml);
    //print(gradeArea);
    return gradeArea.text.contains(StringsCs.hodnotitDoPoznamkovehoBloku);
  }

  markUnread() {
    ///auth/diskuse/diskuse_ajax.pl?fakulta=1433;obdobi=5984;predmet=721682;ts_0=20140326213043:46976735;guz=46976737;akce=vrat_neprec;cop=', 'vr_ne_46976737'
    return get('https://is.muni.cz/auth/diskuse/diskuse_ajax.pl?guz=${id()};akce=vrat_neprec', shouldNotDelay: true);
  }

  num points() {

  }
}

class StringsCs {
  static final hodnotitDoPoznamkovehoBloku = "Hodnotit do poznámkového bloku";
  final zmenitHodnoceni = "změnit hodnocení";
  final obsahBlokuNaposledyZmenen = "obsah bloku naposledy změněn: ";
//Mgr. Radek Vogel, Ph.D., 20. 3. 2014 23:06
//[a-zA-Z., ]*, [0-9]\. [0-9]\. [0-9]* [0-9]:[0-9]
}

evaluate(String query, html) {
  var element;
  if (html is String) {
    element = elementFromHtml(html);
  } else if (html is dom.Element) {
    element = html;
  } else {
    throw 'error';
  }

  var context = js.context;
  var result = js.context.callMethod('evaluate', [query, element]);
  return result;
}


//void run(dom.MouseEvent event) {
//  var aDiscussionThreadUrl = 'https://is.muni.cz/auth/cd/1441/jaro2006/ONLINE_A/1237758';
//  //var aDiscussionForumUrl = 'https://is.muni.cz/auth/diskuse/diskusni_forum_predmet.pl?guz=1041062';
//  var aDiscussionForumUrl = 'https://is.muni.cz/auth/diskuse/diskusni_forum_indiv.pl?guz=46987554';
//  //_run(aDiscussionThreadUrl, processThreadTest);
//  //_run(aDiscussionForumUrl, processForumTest);
//  _run(aDiscussionForumUrl, markAllUngradedTest);
//  //_run(aDiscussionForumUrl, readAllInForum);
//  //_run(aDiscussionThreadUrl, readAllInThread);
//}

void _run(url, func) {
  LogInPage.logIn('dnk', 'password')
    .then((r) => get(url))
    .then((r) {
      func(r);
    }
  );

//void _run(url, func) {
//  LogInPage.logIn(USERNAME, PASSWORD)
//    .then((r) => get(url))
//    .then((r) {
//      func(r);
//    }
//  );
//}

String forceCzechL10n(String oldurl) {
  var uri = Uri.parse(oldurl);
  var query = new Map();
  uri.query.split(";").forEach((q) {
    var kv = q.split('=');
    query[kv.first] = kv.last;
  });
  query['lang'] = 'cs';
  query.remove('setlang');
  var url = uri.replace(queryParameters: query).toString();
//  print(url);
  return url;
>>>>>>> 0ce1a81... force czech locales; in marking ungraded messages unread messages are now not kept unerad (it was flaky at best); some methods for fetching students own seminar/discussion group for Speaking exercise
}

markAllUngraded(String url, progress) {
//  print(url);
  url = forceCzechL10n(url);
  get(url).then((html) {
    var forum = new Forum(ForumPage.fromHtml(html));

    //throw('halt');
    var posts = new async.StreamController();

    var t = 0;
    var t_done = false;

    forum.streamThreads().forEach((Thread thread) {
      t++;
      progress.thread();
      thread.streamPosts().forEach(posts.add)
      .catchError(() => progress.failed("Some posts were not processed"))
      .whenComplete(() {
        t--;
        if (t_done && t == 0) {
          posts.close();
        }
      }).whenComplete(() => t_done = true);
    }).catchError(() {
      progress.failed("Some discussion threads were not processed");
    });

    posts.stream.forEach((post) {
      progress.post();
      if (post.notGraded() /*|| post.unread()*/) {
        progress.markedPost();
        post.markUnread();
        //can fail as well, and probably does from time to time
      }
    }).catchError(() {
      progress.failed("Some posts were not processed");
    }).whenComplete(() => progress.succeeded());
  });
}

markAllUngradedTest(String html) {
  var forum = new Forum(ForumPage.fromHtml(html));
  //throw('halt');
  forum.streamThreads().forEach((Thread thread) {
    thread.streamPosts()
    .where((post) => post.notGraded())
    .forEach((post) => post.markUnread());
  });
}

markAllTest(String html) {
  var forum = new Forum(ForumPage.fromHtml(html));
  forum.streamThreads().toList().then((threads) {
    print(threads);
  });

  forum.streamThreads().forEach((Thread thread) {
    thread.streamPosts()
    .forEach((e) => null);
    //.forEach((post)=> post.markUnread());
  });
}

readAllInForum(String html) {
  var forum = new Forum(ForumPage.fromHtml(html));
  forum.streamPages()
  .forEach((p) => p.threads.forEach((t) => t.streamPosts().drain()));
}

readAllInThread(String html) {
  var thread = new Thread(new ThreadPage(elementFromHtml(html)));
  thread.streamPosts().forEach((e) => null);
  //.forEach((post)=> post.markUnread());
}

processForumTest(String html) {
  var forum = new Forum(ForumPage.fromHtml(html));
  forum.streamPages().toList().then((pages) {
    print('got ${pages.length} pages');
  });
}

abstract class PageStreamer<T> {
  T firstPage;

  ForumPage pageFromHtml(String html);

  async.Stream<T> streamPages() {
    var _pages = new async.StreamController<T>();
    var pages = new async.StreamController<T>();
    _pages.stream.listen((page) {
      String link = page.next();
      if (link != '') {
        get(forceCzechL10n(link)).then((String html) {
          var page = pageFromHtml(html);
          _pages.add(page);
          pages.add(page);
        });
      } else {
        _pages.close();
        pages.close();
      }
    });

    _pages.add(firstPage);
    pages.add(firstPage);
    return pages.stream;
  }
}

class Thread {
  ThreadPage _firstPage;
  String url;

  Thread(this._firstPage);

  Thread.fromUrl(this.url);

  async.Future<ThreadPage> get firstPage {
    var completer = new async.Completer();
    if (_firstPage == null) {
      get(forceCzechL10n(url)).then((html) {
        //print(url);
        //throw('halt');
        _firstPage = ThreadPage.fromHtml(html);
        completer.complete(_firstPage);
      });
    } else {
      completer.complete(_firstPage);
    }
    return completer.future;
  }

  async.Stream<ThreadPage> streamThreadPages() {
    var _threadPages = new async.StreamController<ThreadPage>();
    var threadPages = new async.StreamController<ThreadPage>();
    _threadPages.stream.listen((page) {
      String link = page.next();
      //print(link);
      //safdasd(link);
      if (link != '') {
        get(link).then((String html) {
          var page = new ThreadPage(elementFromHtml(html));
          _threadPages.add(page);
          threadPages.add(page);
        });
      } else {
        _threadPages.close();
        threadPages.close();
      }
    });

    firstPage.then((p) {
      //print(p);
      //throw('halt');
      _threadPages.add(p);
      threadPages.add(p);
    });

    return threadPages.stream;
  }

  async.Stream<Post> streamPosts() {
    var posts = new async.StreamController<Post>();
    streamThreadPages().listen((ThreadPage tp) {
      for (var p in tp.posts) {
        posts.add(p);
      }
    }, onDone:(() => posts.close()));
    return posts.stream;
  }
}

/// may (if multiple pages probably always will) give some duplicates
async.Stream<Post> streamAllPosts(String firstPageHtml) {
  var firstPage = new ThreadPage(elementFromHtml(firstPageHtml));
  var thread = new Thread(firstPage);
  return thread.streamPosts();
}

processThreadTest(String firstPage) {
  var posts = streamAllPosts(firstPage);
  posts.toList().then((l) {
    print('Have ${l.length} posts');
    var notGraded = l.where((p) => p.notGraded());
    print('There is ${notGraded.length} ungraded posts');
  });
//        var threadPage = new ThreadPage(elementFromHtml(firstPage));
//        var html;
//        var link;
//        threadPages.add(threadPage);


//        while () {

//          html = get(link);

//          threadPages.add(threadPage);
//        }
//        print('#pages: ${threadPages.length}');
//        var posts = threadPages.first.posts;
//        print('posts: ${posts.map((Post p) => p.id())}');
//      posts.forEach((Post p) {
//        p.markUnread();
//      });
}

class Forum extends PageStreamer<ForumPage> {
  //mixin
  ForumPage firstPage;

  Forum(this.firstPage);

  @override
  ForumPage pageFromHtml(String html) {
    return ForumPage.fromHtml(html);
  }

  async.Stream<Thread> streamThreads() {
    var threads = new async.StreamController();
    streamPages().listen((page) {
      for (var t in page.threads) {
        threads.add(t);
        //print('adding thread');
        //throw('halt');
      }
    }, onDone: () => threads.close());
    return threads.stream;
  }
}
