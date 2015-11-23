root = exports ? this

{first-non-null, getUrlParameters, getvar, setvar, get-user-events, get-condition, forcehttps, updatecookies, updatecookiesandevents, getFBAppId} = root # commonlib.ls
{post-json, post-start-event, addlog, addlogfblogin} = root # logging_client.ls

root.skip-prereqs = false

readable-test-names = {
  pretest1: 'Pre-Test for Week 1'
  pretest2: 'Pre-Test for Week 2'
  pretest3: 'Pre-Test for Week 3'
  posttest1: 'Post-Test for Week 1'
  posttest2: 'Post-Test for Week 2'
  posttest3: 'Post-Test for Week 3'
}

alert-prereqs = (plist) ->
  #if window.location.href == "http://localhost:5000/study1"
  #  return
  if root.skip-prereqs
    return true
  for x in plist
    if not root.completed-parts[x]?
      testname = x
      if readable-test-names[x]?
        testname = readable-test-names[x]
      toastr.error 'You need to take the following test first: ' + testname
      return false
  return true

export consent-agreed = ->
  $('#collapseOne').data 'allowcollapse', true
  $('#collapseOne').collapse('hide')
  root.completed-parts.consentagreed = Date.now()
  open-part-that-needs-doing()
  #forcecollapse $('#collapseOne')
  #$('#collapseTwo').collapse('show')
  show-consent-agreed()
  post-start-event 'consentagreed'

export open-pretest1 = ->
  #if not alert-prereqs ['consentagreed']
  #  return
  window.open('matching?vocab=japanese1&type=pretest')

export open-posttest3 = ->
  if not alert-prereqs ['pretest3']
    return
  testtime = root.completed-parts['pretest3'] + 1000*3600*24*7
  if Date.now() < testtime
    toastr.error 'Please wait until ' + moment(testtime).format('llll') + ' to take the post-test for week 3 vocabulary'
    return
  window.open('matching?vocab=japanese3&type=posttest')

export open-survey = ->
  target = 'https://stanforduniversity.qualtrics.com/SE/?SID=SV_6nCpYFc4aBE0Z81&' + $.param({
    fbname: getvar('fbname')
    fburl: getvar('fburl')
    fullname: get-user-name()
    condition: getvar('condition')
    lang: getvar('lang')
  })
  window.open target

interactive-description = '''
This week, you will be shown quizzes that you can interact with directly inside your Facebook feed, without leaving it.<br>
It should look like this:<br><br>

<img src="feedlearn-screenshot.png" style="border-radius: 15px"></img>

<div>
<br><br>
<a href="geza@cs.stanford.edu">Email me</a> if you have already finished the pre-test for this week's vocabulary, but you do not see the quizzes in your Facebook feed.<br>
</div>
'''


show-consent-agreed = (timestamp) ->
  if not timestamp?
    timestamp = Date.now()
  readable = moment(timestamp).format('llll')
  $('#consentcheck').css 'visibility', 'visible'
  $('#consentbutton').attr 'disabled', true
  $('#consentdisplay').css('color', 'green').text 'You agreed to this on ' + readable

  
  if $('#extensioninstalledcheck').css('visibility') != 'visible' # extension
    $('#collapseThree').data 'allowcollapse', false
    $('#collapseThree').collapse('show')
    return
  $('#collapseThree').data 'allowcollapse', true
  if not events.extensionfirstinstalled?
    post-start-event 'extensionfirstinstalled'

    

