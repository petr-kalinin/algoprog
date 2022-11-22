import MaterialList from "./MaterialList"

class Main extends MaterialList
    constructor: (levels) ->
        super(levels)

    build: (context, order) ->
        properties = 
            _id: "main#{context.label}"
            type: "main"
            title: "/"

        material = await super.build(context, order, properties)

        return material

export default main = (args...) -> () -> new Main(args...)

