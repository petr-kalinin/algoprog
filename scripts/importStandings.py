#!/usr/bin/python3
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
        teamName = teamName.replace('`', '')
        result.append((teamName, problemResults))
    return result

def parse_io(doc):
    soup = bs4.BeautifulSoup(doc, 'html.parser')
    result = []
    for el in soup.find_all('tr'):
        problemResults = []
        teamName = None
        for probEl in el.children:
            if not isinstance(probEl, bs4.element.Tag):
                continue
            if probEl.get("class") and "rankl" in probEl["class"]:
                continue
            if probEl.get("class") and "party" in probEl["class"]:
                teamName = probEl.string
                continue
            res = None
            time = None
            resEl = probEl.find('i')
            ok = True
            if not resEl:
                resEl = probEl.find('b')
                ok = False
            if resEl: 
                res = resEl.contents[0].string
                timeEl = probEl.find('s')
                if timeEl:
                    time = timeEl.contents[1].string.split(':')
                    time = int(time[0])
            else:
                if probEl.string != ".":
                    continue
            problemResults.append((res, time,))
        if not teamName:
            continue
        if not problemResults:
            continue
        teamName = teamName.replace('`', '')
        result.append((teamName, problemResults))
        print(teamName, problemResults)
    return result    

def do_login(opener):
    req = urllib.request.Request(server + "/api/login", json.dumps({"username": login, "password": password}).encode("utf-8"))
    req.add_header('Content-type', 'application/json')
    r = opener.open(req)
    data = json.loads(r.read())
    assert data["logged"]
    user = json.loads(opener.open(server + '/api/me').read())
    assert user["admin"]

def make_user_id(name):
    return session_id + "v" + hashlib.md5(name.encode('utf-8')).hexdigest()[:8]

def make_submits(result, contest):
    """
    _id: String
    time: Date
    downloadTime: { type: Date, default: new Date(0) }
    user: String
    userList: String
    problem: String
    outcome: String
    source: String
    sourceRaw: String
    language: String
    comments: [String]
    results: mongoose.Schema.Types.Mixed
    force: { type: Boolean, default: false },
    quality: { type: Number, default: 0 },
    testSystemData: mongoose.Schema.Types.Mixed
    findMistake: String
    """
    name, problemResults = result
    user_id = make_user_id(name)
    assert len(problemResults) == len(contest["problems"])
    for i in range(len(contest["problems"])):
        problem_id = contest["problems"][i]["_id"]
        prob_res, time = problemResults[i]
        if not time:
            continue
        ok = False
        attempts = 0
        if prob_res and prob_res != "+":
            attempts = abs(int(prob_res))
        ok = prob_res and prob_res[0] == "+"

        submit_id = user_id + "::" + problem_id + "::"
        fullTime = time * 60 * 1000
        submit = {
            "time": fullTime,
            "user": user_id,
            "problem": problem_id,
            "outcome": "WA",
            "testSystemData": {},
            "virtualId": session_id,
            "force": True
        }

        for att in range(attempts):
            submit["_id"] = submit_id + str(att)
            submit["time"] = fullTime - att - 1
            yield submit

        if ok:
            submit["_id"] = submit_id + "ok"
            submit["outcome"] = "OK"
            submit["time"] = fullTime
            yield submit

    return result

def make_result(result, contest):
    name, problemResults = result
    user_id = make_user_id(name)
    return { 
        "contest" : contest["_id"],
        "user" : user_id, 
        "startTime" : 0,
        "virtualName": name,
        "virtualId": session_id
    }

def upload_submit(opener, result):
    print("Upload submit", result)
    req = urllib.request.Request(server + "/api/importVirtualSubmit", json.dumps(result).encode("utf-8"))
    req.add_header('Content-type', 'application/json')
    r = opener.open(req)
    data = json.loads(r.read())
    assert data["imported"]

def upload_result(opener, result):
    print(result["user"] + " = " + result["virtualName"])
    req = urllib.request.Request(server + "/api/importVirtualResult", json.dumps(result).encode("utf-8"))
    req.add_header('Content-type', 'application/json')
    r = opener.open(req)
    data = json.loads(r.read())
    assert data["imported"]
    req = urllib.request.Request(server + "/api/updateResults/" + result["user"])
    r = opener.open(req)
    data = r.read()
    assert data == b'OK'


if len(sys.argv) == 2:
    doc = open(sys.argv[1]).read()
    results = parse_io(doc)
    results = results[:30]
else:
    server = sys.argv[1]
    login = sys.argv[2]
    password = sys.argv[3]
    contest_id = sys.argv[4]
    fname = sys.argv[5]

    doc = open(fname).read()
    results = parse_io(doc)
    results = results[:30]

    session_id = hashlib.md5(fname.encode('utf-8')).hexdigest()[:8]

    jar = http.cookiejar.CookieJar()
    opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar))

    do_login(opener)
    contest = json.loads(opener.open(server + "/api/contest/" + contest_id).read())
    print(contest)

    for result in results:
        for submit in make_submits(result, contest):
            upload_submit(opener, submit)
        upload_result(opener, make_result(result, contest))
