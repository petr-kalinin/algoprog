import MaterialList from "./MaterialList"

class Contest extends MaterialList
    constructor: (@title, materials) ->
        super(materials)

    build: (context, order) ->
        properties = 
            _id: context.generateId()
            type: "contest"
            title: @title

        material = await super.build(context, order, properties, {allowAsync: true})

        return material

export default contest = (args...) -> () -> new Contest(args...)