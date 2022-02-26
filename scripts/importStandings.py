#!/usr/bin/python3
import bs4
import sys
import pprint
import http.cookiejar
import urllib.request
import json
import random
import hashlib
import os
import zipfile
import copy
from collections import defaultdict
import xml.etree.ElementTree as ET

def parse_nnstuicpc(fname):
    doc = open(fname).read()
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

def load_io_runs(fname):
    fname = os.path.splitext(fname)[0]+'.runs.zip'
    if not os.path.exists(fname):
        return (None, None)
    files = zipfile.ZipFile(fname, 'r').infolist()
    runs = {}
    mintime = 1e9
    for f in files:
        this_fname = os.path.splitext(f.filename)[0]
        team, prob, att = this_fname.split("-")
        prob = ord(prob) - ord('a')
        att = att.split(".")[0]
        att = int(att) - 1
        time = f.date_time[3] * 60 + f.date_time[4]
        if team not in runs:
            runs[team] = {}
        if prob not in runs[team]:
            runs[team][prob] = {}
        runs[team][prob][att] = time
        if time < mintime:
            mintime = time
    for team in runs:
        team_runs = runs[team]
        for prob in team_runs:
            prob_runs = []
            i = 0
            while i in team_runs[prob]:
                prob_runs.append(team_runs[prob][i])
                i += 1
            if i != len(team_runs[prob]):
                print("Non-consequitve runs for problem ", prob, team)
                pprint.pprint(team_runs)
                print(prob_runs, i)
            team_runs[prob] = prob_runs
    return (mintime, runs)

def parse_io(fname):
    doc = open(fname).read()
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

def parse_ije(filename):
    doc = ET.parse(filename).getroot().find("parties")
    result = []
    for party in doc:
        name = party.get("name")
        teamResult = []
        for problem in party:
            solved = int(problem.get("solved"))
            if solved > 0:
                solved = "+" + str(solved)
            else:
                solved = str(solved)
            problem_res = [solved]
            for submit in problem:
                problem_res.append(int(submit.get("time")))
            teamResult.append(problem_res)
        result.append((name, teamResult))
    return result

def assign_runs_to_results(results, mintime, runs):
    for team, result in results:
        bestRun = None
        inf = 1e9
        bestScore = inf
        diff = 0
        bestDrop = {}
        for t in runs:
            team_runs = copy.deepcopy(runs[t])
            score = 0
            cnt = 0
            sumDiff = 0
            drop = {}
            for i in range(len(result)):
                prob_res, time = result[i]
                if prob_res is None:
                    if i in team_runs:
                        score += inf
                    continue
                if i not in team_runs:
                    score += inf
                    continue
                attempts = 0
                if prob_res != "+":
                    attempts = abs(int(prob_res))
                ok = prob_res[0] == "+"
                if ok:
                    attempts += 1
                if attempts > len(team_runs[i]):
                    score += inf
                    continue
                if attempts < len(team_runs[i]):
                    score += 100
                    drop[i] = len(team_runs[i]) - attempts
                    team_runs[i] = team_runs[i][:attempts]
                if time:
                    score += abs(team_runs[i][-1] - mintime - time)
                    sumDiff += team_runs[i][-1] - time
                    cnt += 1
            if score < bestScore and cnt:
                bestScore = score
                bestRun = team_runs
                diff = int(sumDiff / cnt)
                bestDrop = drop
        if not bestRun:
            print("Can't find runs for ", team, result)
            continue
        print(team, result, bestRun, "score=", bestScore, "drop=", bestDrop)
        for i in range(len(result)):
            prob_res, time = result[i]
            if not prob_res:
                continue
            times = [prob_res]
            for att_time in bestRun[i]:
                times.append(att_time - diff)
            if time:
                print("Diff is ", time - times[-1])
                times[-1] = time
            result[i] = times

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
        prob_res = problemResults[i][0]
        times = problemResults[i][1:]
        if not times or times[0] is None:
            continue
        ok = False
        attempts = 0
        if prob_res and prob_res != "+":
            attempts = abs(int(prob_res))
        ok = prob_res and prob_res[0] == "+"

        submit_id = user_id + "::" + problem_id + "::"
        fullTime = times[-1] * 60 * 1000
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
            if att < len(times):
                submit["time"] = times[att] * 60 * 1000
            else:    
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
    print(result["user"] + " = " + str(result))
    req = urllib.request.Request(server + "/api/importVirtualResult", json.dumps(result).encode("utf-8"))
    req.add_header('Content-type', 'application/json')
    r = opener.open(req)
    data = json.loads(r.read())
    assert data["imported"]
    req = urllib.request.Request(server + "/api/updateResults/" + result["user"])
    r = opener.open(req)
    data = r.read()
    assert data == b'OK'

def main():
    ##io
    #results = parse_io(sys.argv[-1])
    #mintime, runs = load_io_runs(sys.argv[-1])
    #assign_runs_to_results(results, mintime, runs)

    #ije
    results = parse_ije(sys.argv[-1])

    pprint.pprint(results)
    if len(sys.argv) > 2:
        global server, login, password, contest_id, session_id
        server = sys.argv[1]
        login = sys.argv[2]
        password = sys.argv[3]
        contest_id = sys.argv[4]
        fname = sys.argv[5]

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

main()