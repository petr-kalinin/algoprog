class Link
    constructor: (@link, @title, @id) ->

    build: (context, order) ->
        data = 
            _id: @id || context.generateId(),
            type: "link",
            content: @link
            title: @title?(context.label) || @title
            order: order

        await context.process(data)
        return data

export default link = (args...) -> () -> new Link(args...)