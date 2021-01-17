#!/usr/bin/python3
from bson.json_util import dumps
import json
import pymongo
import os

MONGODB_URI = os.environ['MONGODB_URI']
IDS = [301755]

algoprog = pymongo.MongoClient(MONGODB_URI)["algoprog"]
algoprog_sbory = pymongo.MongoClient(MONGODB_URI)["algoprog_sbory"]
log = open("log.txt", "a")
for user_id in IDS:
    print(user_id)
    registered_user = algoprog["registeredusers"].find_one({"informaticsId": user_id})
    user = algoprog["users"].find_one({"_id": str(user_id)})
    log.write(dumps(registered_user) + "\n")
    log.write(dumps(user) + "\n")
    user["mainUserList"] = user["userList"]
    user["userList"] = "sbory"
    algoprog["users"].replace_one({"_id": str(user_id)}, user)
    
    user["userList"] = "all"
    algoprog_sbory["users"].replace_one({"_id": str(user_id)}, user, upsert=True)
    algoprog_sbory["registeredusers"].replace_one({"informaticsId": user_id}, registered_user, upsert=True)
