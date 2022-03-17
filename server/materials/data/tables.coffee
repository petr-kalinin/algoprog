import GROUPS from '../../../client/lib/groups'

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

export allTables = ["1А,1Б", "1В,1Г", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "main", "sch", "nnoi", "reg", "roi"]

export default tables = () ->
    materials = []
    for group, data of GROUPS
        if not data.tableName
            continue
        groupName = data.tableName
        thisMaterials = []
        for t in [allTables... , "byWeek"]
            thisMaterials.push(table(group, t, getTableTitle(t), getTreeTitle(t)))

        material = simpleLevel("tables:#{group}", groupName, thisMaterials)
        materials.push(material)

    return simpleLevel("tables", "Сводные таблицы", materials)

