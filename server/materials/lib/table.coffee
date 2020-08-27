import MaterialList from "./MaterialList"


getTableLink = (group, table) ->
    if table == "byWeek"
        return "/solvedByWeek/#{group}"
    return "/table/#{group}/#{table}"

class Table
    constructor: (@group, @table, @title, @treeTitle) ->

    build: (context, order) ->
        data =
            _id: "table:" + @group + ":" + @table
            type: "table"
            title: @title
            treeTitle: @treeTitle
            content: getTableLink(@group, @table)   
            order: order

        await context.process(data)

        return data

export default table = (args...) -> () -> new Table(args...)