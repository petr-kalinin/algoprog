import Material from '../../models/Material'

export class Label
    constructor: (@content) ->

    build: (context) ->
        data = 
            _id: context.generateId(),
            type: "label",
            content: @content

        material = new Material(data)

        await context.process(material)
        return data

export default label = (args...) -> new Label(args...)