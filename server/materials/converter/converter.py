#!/usr/bin/python3.8
import asyncio
import aiohttp
import json
import os
import re
import shutil


SESSION = None
IMPORT_PREFIX = "../../lib"


class MaterialFile:
    def __init__(self, filename):
        self.filename = filename
        self.imports = set()
        self.functions = []

    def add_import(self, imp):
        self.imports.add(imp)

    def add_function(self, fn):
        self.functions.append(fn)

    def finalize(self):
        with open(os.path.join("generated", self.filename + ".coffee"), "w") as f:
            self.imports = list(self.imports)
            self.imports.sort(key=get_file_from_import)
            f.write("\n".join(self.imports))
            f.write("\n\n")
            f.write("\n\n".join(self.functions))


def get_file_from_import(filename):
    m = re.match('import .* from "([^"]*)"', filename)
    if not m:
        raise Exception("Can not detect filename in import " + filename)
    return m.group(1)


def lib_import(fn):
    return 'import {} from "{}/{}"'.format(fn, IMPORT_PREFIX, fn)


async def download(id):
    url = 'https://algoprog.ru/api/material/{}'.format(id)
    async with SESSION.get(url) as resp:
        return json.loads(await resp.text())


def id_to_filename(id):
    return id.replace("А", "A").replace("Б", "B").replace("В", "C").replace("Г", "D")


def escape_quotes(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


async def convert_problem(problem):
    return "problem({})".format(problem["_id"][1:]), lib_import("problem")


async def convert_topic_like(name, tree_name, materials, file):
    if not materials:
        raise Exception("No materials in topic {} {}".format(name, tree_name))
    if len(materials) > 1:
        if not name or not tree_name:
            raise Exception("No name in topic {} {}".format(name, tree_name))
        type = "topic"
        parameters = '"{}", "{}", '.format(escape_quotes(name), escape_quotes(tree_name))
    else:
        if name:
            raise Exception("Have name in topic {} {}".format(name, tree_name))
        type = "contest"
        parameters = '"{}", '.format(escape_quotes(tree_name))
    function_name = "{}{}".format(type, materials[-1]["_id"])
    function = '{} = () ->\n    return {}({}[\n'.format(function_name, type, parameters)
    converted = []
    for material in materials:
        if material["type"] == "contest":
            full_material = await download(material["_id"])
            problems = full_material.get("materials")
            if not problems:
                raise Exception("No problems in topic {} {} {}".format(name, tree_name, material["_id"]))
            for problem in problems:
                converted.append(convert_problem(problem))
        else:
            converted.append(convert_material(material["_id"], file))
    converted = await asyncio.gather(*converted)
    for line, imp in converted:
        if imp:
            file.add_import(imp)
        if line:
            function += "        " + line + ",\n"
    function += "    ])"
    file.add_function(function)
    return function_name + "()", lib_import(type)


async def fix_topics(materials, file):
    pending_materials = []
    result = []
    in_topic = False
    topic_name = None
    for material in materials:
        if material["type"] == "label":
            match = re.match(r"<h4>([^<]*)</h4>", material["content"])
            if match:
                if in_topic:
                    result += pending_materials
                    pending_materials = []
                in_topic = True
                topic_name = match.group(1)
        if material["type"] == "contest":
            pending_materials.append(material)
            result.append(convert_topic_like(topic_name, material["title"], pending_materials, file))
            pending_materials = []
            in_topic = False
            topic_name = None
            continue
        if not in_topic:
            result.append(material)
        else:
            pending_materials.append(material)
    if in_topic:
        result += pending_materials

    return result


async def convert_level_like(id, data):
    idfn = id_to_filename(id)
    if id == "tables":
        return None, None
    if id == "0":
        id = "about"
        idfn = "about"
    if id == "main":
        function_name = "root"
    else:
        function_name = "level_{}".format(idfn)
    file = MaterialFile(function_name)
    file.add_import(lib_import(data["type"]))
    if id == "main":
        params = ""
    elif not data["title"].startswith("Уровень"):
        params = '"{}", "{}", '.format(id, data["title"])
    else:
        params = '"{}", '.format(id)
    function = 'export default {} = () ->\n    return {}({}[\n'.format(function_name, data["type"], params)
    materials = await fix_topics(data["materials"], file)
    converted = []
    for material in materials:
        if isinstance(material, dict):
            converted.append(convert_material(material["_id"], file))
        else:
            converted.append(material)
    converted = await asyncio.gather(*converted)
    for line, imp in converted:
        if imp:
            file.add_import(imp)
        if line:
            function += "        " + line + ",\n"
    function += "    ])"
    file.add_function(function)
    file.finalize()
    return function_name + "()", 'import {} from "./{}"'.format(function_name, file.filename)


async def convert_label(id, data):
    content = data["content"]
    content = re.sub(r"<h\d>Уровень [^<]*</h\d>", "", content).strip()
    content = escape_quotes(content).replace("\n", "\\n")
    if not content:
        return None, None
    return 'label("{}")'.format(content), lib_import("label")


async def convert_page_like(id, data, file):
    content = data["content"]
    if not content:
        return None, None
    content = content.replace("\n", "\n        ")
    title = escape_quotes(data["title"]).replace("\n", "\\n")

    function_name = id.replace("-", "")
    type = data["type"]
    function = '{} = () ->\n    {}("{}", """\n        {}\n    """)'.format(function_name, type, title, content)
    file.add_function(function)
    return '{}()'.format(function_name), lib_import(type)


async def convert_link(id, data):
    title = escape_quotes(data["title"]).replace("\n", "\\n")
    content = data["content"]
    return 'link("{}", "{}")'.format(content, title), lib_import("link")


async def convert_material(id, file):
    data = await download(id)
    if data["type"] in ["level", "main"]:
        return await convert_level_like(id, data)
    elif data["type"] == "label":
        return await convert_label(id, data)
    elif data["type"] in ["link", "image"]:
        return await convert_link(id, data)
    elif data["type"] in ["page", "epigraph"]:
        return await convert_page_like(id, data, file)
    else:
        print("Unknown material type {}, {}".format(data["_id"], data["type"]))
        return None, None


async def main():
    global SESSION
    shutil.rmtree("generated")
    os.mkdir("generated")
    async with aiohttp.ClientSession() as session:
        SESSION = session
        await convert_material("main", None)


asyncio.run(main())