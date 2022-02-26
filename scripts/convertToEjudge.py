#!/usr/bin/python3
import os.path
import shutil
import sys
import xml.etree.ElementTree as ET
import glob

def copyfile(file1, file2):
    #print(file1 + "->" + file2)
    shutil.copyfile(file1, file2)

def get_problems(filename):
    res = []
    doc = ET.parse(filename).getroot()
    problems = doc.find('problems')
    for problem in problems:
        res.append(problem.get('id'))
    return res

def make_desc(problem_doc):
    name = problem_doc.find("name").get("value")
    script = problem_doc.find("judging").find("script").find("testset")
    input_file = script.get("input-name")
    output_file = script.get("output-name")
    time_limit = script.get("time-limit")
    memory_limit = script.get("memory-limit")
    short_name = chr(ord('A') + id)
    
    assert time_limit.endswith("ms")
    time_limit_millis = time_limit[:-2]

    assert memory_limit.endswith("b")
    max_vm_size = str(int(memory_limit[:-1]) // (2 ** 20)) + "M"

    ejudge_desc = f"""
[problem]
id = {id+1}
super = "Generic"
short_name = "{short_name}"
long_name = "{name}"
type = "standard"
input_file = "{input_file}"
output_file = "{output_file}"
time_limit_millis = {time_limit_millis}
max_vm_size = {max_vm_size}
standard_checker = ""
"""
    return ejudge_desc

def ije_format(fmt, id):
    hashes = fmt.count('#')
    id = str(id)
    while len(id) < hashes:
        id = '0' + id
    res = ''
    pos = 0
    for ch in fmt:
        if ch == '#':
            res += id[pos]
            pos += 1
        else:
            res += ch
    return res

def find_checker(problem_path):
    for mask in ["test.*", "check.*", "checker.*"]:
        files = glob.glob(problem_path + "/" + mask)
        for file in files:
            _, ext = os.path.splitext(file)
            if ext[1:] not in ["exe", "o", "jar"]:
                return file
    assert False

def copy_tests(problem_path, target_path, id, problem_doc):
    script = problem_doc.find("judging").find("script").find("testset")
    target_problem_dir = target_path + "/problems/" + chr(ord('A') + id)
    target_tests_dir = target_problem_dir + "/tests/"
    os.makedirs(target_tests_dir)
    tests_count = len(script.findall("test"))
    input_format = script.get("input-href")
    answer_format = script.get("answer-href")
    for test in range(1, tests_count + 1):
        input_name = problem_path + "/" + ije_format(input_format, test)
        copyfile(input_name, target_tests_dir + "%03d" % test)
        answer_name = problem_path + "/" + ije_format(answer_format, test)
        copyfile(answer_name, target_tests_dir + "%03d.a" % test)
    checker = find_checker(problem_path)
    _, checker_ext = os.path.splitext(checker)
    if checker_ext == ".dpr":
        checker_ext = ".pas"
    copyfile(checker, target_problem_dir + "/check" + checker_ext)
    for file in os.listdir("modules"):
        copyfile("modules/" + file, target_problem_dir + "/" + file)

def process_problem(id, contest_xml, problem_id, target_path):
    problem_path = os.path.normpath(contest_xml + "/../tests/" + problem_id)
    problem_doc = ET.parse(problem_path + "/PROBLEM.xml", parser=ET.XMLParser(encoding="windows-1251")).getroot()
    copy_tests(problem_path, target_path, id, problem_doc)
    return make_desc(problem_doc)


contest_file = sys.argv[1]
target_path = sys.argv[2]
assert not os.path.exists(target_path)
os.makedirs(target_path)

problems = get_problems(contest_file)
descr = []
for id, problem in enumerate(problems):
    descr.append(process_problem(id, sys.argv[1], problem, target_path))

os.makedirs(target_path + "/conf")
with open(target_path + "/conf/serve.cfg.incl", "w") as f:
    print("\n".join(descr), file=f)