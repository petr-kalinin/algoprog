import label from './label'
import MaterialList from "./MaterialList"

class Topic extends MaterialList
    constructor: (@title, @contestTitle, materials, @id) ->
        super(materials)

    build: (context, order) ->
        properties = 
            _id: if @id then "#{@id}#{context.label}" else context.generateId()
            type: "topic"
            title: @title?(context.label) || @title
            treeTitle: @contestTitle?(context.label) || @contestTitle

        material = await super.build(context, order, properties, {keepSubmaterials: true})
        material.treeTitle = properties.treeTitle

        return material

export default topic = (args...) -> () -> new Topic(args...)