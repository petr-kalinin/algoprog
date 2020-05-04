import MaterialList from "./MaterialList"

getTableTitle = (table) ->
    if table == "reg"
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
    if table == "reg"
        return "Региональные олимпиады"
    else if table == "reg"
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

getTableLink = (group, table) ->
    if table == "byWeek"
        return "/solvedByWeek/#{group}"
    return "/table/#{group}/#{table}"

class Table
    constructor: (@group, @table) ->

    build: (context) ->
        data =
            _id: "table:" + @group + ":" + @table
            type: "table"
            title: getTableTitle(@table)
            treeTitle: getTreeTitle(@table)
            content: getTableLink(@group, @table)   

        await context.process(data)

        return data

export default table = (args...) -> () -> new Table(args...)