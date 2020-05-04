export class Label
    constructor: (@content) ->

    build: (context) ->
        data = 
            _id: context.generateId(),
            type: "label",
            content: @content

        await context.process(data)
        return data

export default label = (args...) -> () -> new Label(args...)