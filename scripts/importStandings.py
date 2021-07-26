import bs4
import sys
import pprint
import http.cookiejar
import urllib.request
import json
import random
import hashlib

def parse_nnstuicpc(doc):
    soup = bs4.BeautifulSoup(doc, 'html.parser')
    result = []
    for el in soup.find_all('tr'):
        problemResults = []
        teamName = None
        for probEl in el.children:
            if probEl.name == "th":
                continue
            if not isinstance(probEl, bs4.element.Tag):
                continue
            if probEl.get("class") and "team" in probEl["class"]:
                teamName = probEl.string
                continue
            res = None
            time = None
            resEl = probEl.find('span', 'accepted')
            ok = True
            if not resEl:
                resEl = probEl.find('span', 'rejected')
                ok = False
            if resEl: 
                res = resEl.string
                timeEl = probEl.find('span', 'additional')
                if timeEl:
                    time = timeEl.string.split(':')
                    time = int(time[0]) * 60 + int(time[1])
            else:
                if probEl.string != ".":
                    continue
            problemResults.append((res, time,))
        if not teamName:
            continue
        result.append((teamName, problemResults))
    return result

def do_login(opener):
    req = urllib.request.Request(server + "/api/login", json.dumps({"username": login, "password": password}).encode("utf-8"))
    req.add_header('Content-type', 'application/json')
    r = opener.open(req)
    data = json.loads(r.read())
    assert data["logged"]
    user = json.loads(opener.open(server + '/api/me').read())
    assert user["admin"]

def convert_result(result, contest):
    """
    { 
        "_id" : "547820::sample", 
        "contest" : "sample", 
        "contestResult" : { 
            "ok" : 0, 
            "attempts" : 3 ,
            "time: 123
        }, 
        "problemResults" : { 
            "p1340" : { 
                "_id" : "547820::p1340::sample", 
                "table" : "p1340", 
                "ps" : 0, 
                "attempts" : 2, 
                "lastSubmitId" : 
                "27525148p1340", 
                "lastSubmitTime" : ISODate("2021-07-26T09:15:34Z"), 
                "contestResult" : { "ok" : 0 } 
            }, 
            ...
        }, 
        "user" : "547820", 
        "registered" : false, 
        "startTime" : ISODate("2021-07-26T09:11:35.258Z") 
    }
    """
    name, problemResults = result
    subid = hashlib.md5(name.encode('utf-8')).hexdigest()[:8]
    result_id = session_id + "v" + subid
    result = {
        "_id": result_id + ":" + contest["_id"],
        "virtualId": session_id,
        "contest" : contest["_id"], 
        "user": name,
        "problemResults": {}
    }
    assert len(problemResults) == len(contest["problems"])
    totalOk = 0
    totalAttempts = 0
    totalTime = 0
    for i in range(len(contest["problems"])):
        problem_id = contest["problems"][i]["_id"]
        prob_res, time = problemResults[i]
        ok = False
        attempts = 0
        if prob_res and prob_res != "+":
            attempts = abs(int(prob_res))
        ok = prob_res and prob_res[0] == "+"
        
        if ok:
            totalOk += 1
            totalAttempts += attempts
            totalTime += time + 20 * attempts

        result["problemResults"][problem_id] = { 
            "_id" : f"{result_id}::{problem_id}::{contest['_id']}", 
            "table" : problem_id, 
            "ps" : 0, 
            "attempts" : attempts,
            "contestResult" : { 
                "ok" : 1 if ok else 0,
                "time": time
            } 
        }
    result["contestResult"] = { 
        "ok" : totalOk, 
        "attempts" : totalAttempts,
        "time": totalTime
    }

    return result

def upload(opener, result):
    print(result["user"])
    req = urllib.request.Request(server + "/api/importVirtualResult", json.dumps(result).encode("utf-8"))
    req.add_header('Content-type', 'application/json')
    r = opener.open(req)
    data = json.loads(r.read())
    assert data["imported"]

server = sys.argv[1]
login = sys.argv[2]
password = sys.argv[3]
contest_id = sys.argv[4]
fname = sys.argv[5]

session_id = hashlib.md5(fname.encode('utf-8')).hexdigest()[:8]

jar = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar))

do_login(opener)
contest = json.loads(opener.open(server + "/api/contest/" + contest_id).read())
doc = open(fname).read()
results = parse_nnstuicpc(doc)

for result in results:
    upload(opener, convert_result(result, contest))
