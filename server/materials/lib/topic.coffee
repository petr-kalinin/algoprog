import MaterialList from "./MaterialList"

class Topic extends MaterialList
    constructor: (@title, materials) ->
        super(materials)

    build: (context) ->
        properties = 
            _id: context.generateId()
            type: "topic"
            title: @title

        material = await super.build(context, properties)

        return material

export default topic = (args...) -> new Topic(args...)