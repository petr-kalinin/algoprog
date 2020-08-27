export class Label
    constructor: (@content) ->

    build: (context, order) ->
        data = 
            _id: context.generateId(),
            type: "label",
            content: @content
            order: order

        await context.process(data)
        return data

export default label = (args...) -> () -> new Label(args...)