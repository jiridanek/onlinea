import urllib.request
import http.cookiejar
import json

#time taken is not present now (May 2015)
def print_event(event):
    for attr in ["lesson_number", "num_skills_learned", "skill_lessons", "skill_title", "time_taken", "type", "xp"]:
        print(attr, ' : ', event[attr], end="   ")
    print()
    
host = 'https://duolingo.com'

jar = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar))

def doLogin():
    auth = {'came_from': "", 'login': 'AnglictinaOnline', 'password': '4sdf6g4sdfxx+955', "": 'Sign in'}
    data = urllib.parse.urlencode(auth).encode('utf-8')
    request = urllib.request.Request(url='https://www.duolingo.com/login', method='POST', data=data)
    r = opener.open(request)
    return json.loads(r.read().decode('utf-8'))

def doDashboardGet():
    url = host + '/api/1/observers/progress_dashboard'
    r = opener.open(url)
    jdoc = json.loads(r.read().decode('utf-8'))
    return jdoc

def doEventsGet(student_id, week):
    url = host + '/api/1/observers/detailed_events'
    ui_language = 'en'
    from_language = 'cs'
    learning_language = 'en'
    params = {'student_id': student_id, 'ui_language': ui_language, 'learning_language': learning_language, 'from_language': from_language, 'week': week}
    request = urllib.request.Request(url=url + '?' + urllib.parse.urlencode(params))
    r = opener.open(request)
    jdoc = json.loads(r.read().decode('utf-8'))
    return jdoc

       

