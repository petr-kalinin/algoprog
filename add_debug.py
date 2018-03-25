import os

count = 0
def marker(line):
    global count
    result = ""
    for i in line:
        if i != " ":
            break
        result += " "
    s = "_".join([str(count)] * 10000)
    result += "_debug_marker = {{qwe: '{}'}}\n".format(s)
    count += 1
    return result
    
def convert(file):
    with open(file, encoding="cp866") as f:
        lines = f.readlines()
    result = ""
    for line in lines:
        if "await" in line and "noawait" not in line:
            result += marker(line)
        result += line
    with open(file, "w", encoding="cp866") as f:
        f.write(result)
            

data = os.walk(".")
for d in data:
    dirname = d[0]
    for f in d[2]:
        file = os.path.join(dirname, f)
        if not os.path.splitext(file)[1] == ".coffee":
            continue
        convert(file)
    
    
# MaterialsDownloader
# tableSchema