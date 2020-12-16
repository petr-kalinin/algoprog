import label from './label'
import MaterialList from "./MaterialList"

class Topic extends MaterialList
    constructor: (@title, @contestTitle, materials, @id) ->
        super(materials)

    build: (context, order) ->
        properties = 
            _id: @id || context.generateId()
            type: "topic"
            title: @title
            treeTitle: @contestTitle

        material = await super.build(context, order, properties, {keepSubmaterials: true})
        material.treeTitle = @contestTitle

        return material

export default topic = (args...) -> () -> new Topic(args...)