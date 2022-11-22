#!/usr/bin/python3
import bs4
import json
import http.cookiejar
import urllib.request
import os
import os.path
import sys
import re

path = sys.argv[1]
server = sys.argv[2]
login = sys.argv[3]
password = sys.argv[4]

def do_login(opener):
    req = urllib.request.Request(server + "/api/login", json.dumps({"username": login, "password": password}).encode("utf-8"))
    req.add_header('Content-type', 'application/json')
    r = opener.open(req)
    data = json.loads(r.read())
    assert data["logged"]
    user = json.loads(opener.open(server + '/api/me').read())
    assert user["admin"]

def get_contest_material(contest_id, opener):
    req = urllib.request.Request(server + "/api/material/" + urllib.parse.quote(contest_id))
    r = opener.open(req)
    data = json.loads(r.read().decode("utf-8"))
    #print(data)
    assert data["type"] == "contest" or data["type"] == "topic"
    return data

jar = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar))
do_login(opener)

files = os.listdir(path)
for f in files:
    fname = os.path.join(path, f)
    print(fname)
    if not os.path.isfile(fname):
        continue
    contest_id, _ = os.path.splitext(f)
    print(contest_id)
    contest = get_contest_material(contest_id, opener)

    doc = open(fname).read()
    soup = bs4.BeautifulSoup(doc, 'html.parser')
    els = list(soup.find_all(class_='problem-statement'))
    problems = [m for m in contest["materials"] if m["type"] == "problem"]
    #print(problems)
    assert len(els) == len(problems)
    for i in range(len(els)-1, -1, -1):
        el = els[i].extract()
        for cls in ["time-limit", "memory-limit", "input-file", "output-file", "MathJax_Preview", "MathJax_CHTML"]:
            for subel in el.find_all(class_=cls):
                subel.decompose()
        for math in el.find_all(type="math/tex"):
            math.replace_with("$" + math.string + "$")
        problem = problems[i]
        title = el.find(class_="title")
        name = re.sub("^[A-Z]*. ", "", title.string)
        h1 = soup.new_tag("h1")
        h1.string = name
        title.replace_with(h1)
        print(contest_id, i,problem["title"], name)
        url = server + "/api/editMaterial/" + problem["_id"]
        payload = json.dumps({"title": name, "content": str(el)}).encode("utf-8")
        req = urllib.request.Request(url, payload)
        req.add_header('Content-type', 'application/json')
        r = opener.open(req)
        assert r.read().decode("utf-8") == "OK"
