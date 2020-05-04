import MaterialList from "./MaterialList"

class Contest extends MaterialList
    constructor: (@title, materials) ->
        super(materials)

    build: (context) ->
        properties = 
            _id: context.generateId()
            type: "contest"
            title: @title

        material = await super.build(context, properties, {allowAsync: true, keepSubmaterials: true})

        return material

export default contest = (args...) -> () -> new Contest(args...)