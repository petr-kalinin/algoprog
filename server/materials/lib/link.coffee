class Link
    constructor: (@link, @title) ->

    build: (context, order) ->
        data = 
            _id: context.generateId(),
            type: "link",
            content: @link
            title: @title
            order: order

        await context.process(data)
        return data

export default link = (args...) -> () -> new Link(args...)