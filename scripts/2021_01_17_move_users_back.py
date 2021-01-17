#!/usr/bin/python3
from bson.json_util import dumps
import json
import pymongo
import os

MONGODB_URI = os.environ['MONGODB_URI']
IDS = [454364, ]

algoprog = pymongo.MongoClient(MONGODB_URI)["algoprog"]
log = open("log_2021_01_17.txt", "a")
for user_id in IDS:
    print(user_id)
    user = algoprog["users"].find_one({"_id": str(user_id)})
    log.write(dumps(user) + "\n")
    user["userList"] = user["mainUserList"]
    algoprog["users"].replace_one({"_id": str(user_id)}, user)
