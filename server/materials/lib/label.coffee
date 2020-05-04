import Material from '../../models/Material'

export class Label
    constructor: (@content) ->

    build: (context) ->
        material = new Material
            _id: context.generateId(),
            type: "label",
            title: "",
            content: @content,
            materials: []
        await context.process(material)
        return material

export default label = (args...) -> new Label(args...)