import 'dart:html' show HttpRequest;
import 'package:ismu/discussion.dart' show postNewThread;
import 'groups.dart' show groups;

fetchguz(String url) async {
  var page = await HttpRequest.getString(url, withCredentials: true);
  var guz = new RegExp(r'guz=(\d+)').firstMatch(page).group(1);
  return guz;
}

main() async {
  for (var group in groups) {
    var url = 'https://is.muni.cz/auth/cd/1441/jaro2016/ONLINE_A.${group.oznaceni}';
    var guz = await fetchguz(url);
    var subject = "Toto fórum NENÍ bodované / Not a discussion forum for points";
    var body = '''<table>
<tr>
<td width="500px">
<h3>Toto fórum NENÍ bodované</h3> </td>
<td width="500px">
<h3>Not a discussion forum for points</h3> </td> </tr>
<tr>
<td width="500px">
<p>Toto je diskusní fórum seminární skupiny. Informační systém je vytváří automaticky, nedá se smazat a nelze v něm bodovat příspěvky. </p>
</td>
<td width="500px">
<p>This is not a discussion forum for points. </p>
</td> </tr>
<tr>
<td width="500px">
<h4>Kde najdu bodované fórum?</h4>
<ol>
<li>Odkaz najdete v <a href="https://is.muni.cz/auth/el/1441/jaro2016/ONLINE_A/index.qwarp">Interaktivní osnově</a>,</li>
<li>nebo na stránce <a href="https://is.muni.cz/auth/diskuse/">DISKUSE</a> (odkaz na titulní straně ISu a v levém sloupci),</li>
<li>nebo Osobní administrativa → Student → Diskusní fóra předmětů </li>
</ol>
<p>Do diskusního fóra je vám umožněno vstoupit až poté, co se přihlásíte do příslušné seminární skupiny.</p>
<p>Vaše fórum se jmenuje např. <strong>Discussion Forum for Points (Bg2)</strong>, kde v závorce je kód vaší seminární skupiny. </p>
</td>
<td width="500px">
<h4>Where do I find Discussion Forum for Points?</h4>
<ul>
<li>The link is in <a href="https://is.muni.cz/auth/el/1441/jaro2016/ONLINE_A/index.qwarp">Interactive Syllabus</a>,</li>
<li>or in page <a href="https://is.muni.cz/auth/diskuse/">DISCUSSION</a> (link in the left column in this page)</li>
<li>or Personal Administration → Student → Discussion Groups - Courses</li>
</ul>
<p>You can open discussion forum only after registering for a seminar group first. </p>
<p>Your forum is called e.g. <strong>Discussion Forum for Points (Bg2)</strong>. ID of your seminar group is in parenthesis. </p>
</td> </tr> </table>''';
    postNewThread('predmet', guz, subject, body, isHtml: true);
  }
}