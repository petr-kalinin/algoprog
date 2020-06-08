import MaterialList from "./MaterialList"

class SimpleLevel extends MaterialList
    constructor: (id, title, levels) ->
        super(levels)
        @title = title
        @id = id

    build: (context) ->
        properties = 
            _id: @id
            type: "simpleLevel"
            title: @title

        material = await super.build(context, properties)

        return material

export default simpleLevel = (args...) -> () -> new SimpleLevel(args...)