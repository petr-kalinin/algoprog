import MaterialList from "./MaterialList"

labelToName = 
    "": "Уровень"
    "!en": "Level"

class Level extends MaterialList
    constructor: (id, title, levels) ->
        if not levels
            levels = title
            title = undefined
        super(levels)
        @title = title
        @id = id

    build: (context, order) ->
        if not @title
            @title = "#{labelToName[context.label]} #{@id}"
        properties = 
            _id: "#{@id}#{context.label}"
            type: "level"
            title: @title

        material = await super.build(context, order, properties, {keepSubmaterials: true})

        return material

export default level = (args...) -> () -> new Level(args...)