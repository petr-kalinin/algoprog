#!/usr/bin/python3
from bson.json_util import dumps
import json
import pymongo
import os
import pprint

MONGODB_URI = os.environ['MONGODB_URI']

algoprog = pymongo.MongoClient(MONGODB_URI)["algoprog"]

def process_problem(problem_id, parent):
    submits = list(algoprog["submits"].find(
        {"problem": problem_id, 
        "sourceRaw": {"$ne": None},
        "results": {"$ne": []},
        "results.tests": {"$ne": None}},
         limit=100))
    ok_submits = [s for s in submits if s["outcome"] == "AC"]
    def calc_wa_tests(submit):
        if not isinstance(submit["results"]["tests"], dict):
            return 0
        return len([x for x in submit["results"]["tests"].values() if x["status"] != "OK"])
    wa_submits = [s for s in submits if calc_wa_tests(s) != 0]
    wa_submits.sort(key=calc_wa_tests)
    dir = "submits/{}/{}".format(parent, problem_id)
    os.makedirs(dir, exist_ok=True)
    for i in range(min(2, len(ok_submits))):
        with open("{}/ok{}".format(dir, i), "w") as f:
            f.write(ok_submits[i]["sourceRaw"])
    for i in range(min(3, len(wa_submits))):
        with open("{}/wa{}".format(dir, i), "w") as f:
            f.write(wa_submits[i]["sourceRaw"])

def process(material_id, parent):
    print("Processing ", material_id)
    material = algoprog["materials"].find_one({"_id": material_id})
    if material["type"] == "problem":
        process_problem(material_id, parent)
        return
    for m in material["materials"]:
        process(m["_id"], material_id)


process("1", "")
