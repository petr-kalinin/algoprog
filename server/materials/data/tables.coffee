import table from '../lib/table'
import simpleLevel from '../lib/simpleLevel'

getTableTitle = (table) ->
    if table == "sch"
        return "Сводная таблица по школьным олимпиадам"
    else if table == "nnoi"
        return "Сводная таблица по нижегородским олимпиадам"
    else if table == "reg"
        return "Сводная таблица по региональным олимпиадам"
    else if table == "roi"
        return "Сводная таблица по всероссийским олимпиадам"
    else if table == "main"
        return "Сводная таблица по всем уровням"
    else if table == "byWeek"
        return "Сводная таблица по неделям"
    tables = table.split(",")
    if tables.length == 1
        return "Сводная таблица по уровню " + table
    else
        return "Сводная таблица по уровням " + tables.join(", ")

getTreeTitle = (table) ->
    if table == "sch"
        return "Школьные олимпиады"
    else if table == "nnoi"
        return "Нижегородские олимпиады"
    else if table == "reg"
        return "Региональные олимпиады"
    else if table == "roi"
        return "Всероссийские олимпиады"
    else if table == "main"
        return "Все уровни"
    else if table == "byWeek"
        return "По неделям"
    tables = table.split(",")
    if tables.length == 1
        return "Уровень " + table
    else
        return "Уровни " + tables.join(", ")

export allTables = ["0", "1", "2", "main", "reg", "roi"]

export default tables = () ->
    groups =
        pk: "Все школьники"
        ###
        lic40: "Лицей 40",
        zaoch: "Занятия во ВШЭ + нижегородские заочно",
        unn: "Занятия в ННГУ"
        lic87: "Лицей 87",
        notnnov: "Остальные школьники",
        stud: "Студенты и старше"
        ###

    materials = []
    for group, groupName of groups
        thisMaterials = []
        for t in [allTables... , "byWeek"]
            thisMaterials.push(table(group, t, getTableTitle(t), getTreeTitle(t)))

        material = simpleLevel("tables:#{group}", groupName, thisMaterials)
        materials.push(material)

    return simpleLevel("tables", "Сводные таблицы", materials)

