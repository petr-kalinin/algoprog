import GROUPS from '../../../client/lib/groups'

import table from '../lib/table'
import simpleLevel from '../lib/simpleLevel'

getTableTitle = (table) ->
    if table == "main"
        return "Rankings for all levels"
    else if table == "byWeek"
        return "Rankings by week"
    tables = table.split(",")
    if tables.length == 1
        return "Rankings by level " + table
    else
        return "Rankings by levels " + tables.join(", ")

getTreeTitle = (table) ->
    if table == "main"
        return "All levels"
    else if table == "byWeek"
        return "By week"
    tables = table.split(",")
    if tables.length == 1
        return "Level " + table
    else
        return "Levels " + tables.join(", ")

export allTables = ["1А,1Б", "1В,1Г", "main"]

export default tables = () ->
    materials = []
    for group, data of GROUPS
        if not data.tableNameEn
            continue
        groupName = data.tableNameEn
        thisMaterials = []
        for t in [allTables... , "byWeek"]
            thisMaterials.push(table(group, t, getTableTitle(t), getTreeTitle(t)))

        material = simpleLevel("tables:#{group}", groupName, thisMaterials)
        materials.push(material)

    return simpleLevel("tables", "Rankings", materials)

