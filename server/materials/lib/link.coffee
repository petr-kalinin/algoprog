class Link
    constructor: (@link, @title) ->

    build: (context) ->
        data = 
            _id: context.generateId(),
            type: "link",
            content: @link
            title: @title

        await context.process(data)
        return data

export default link = (args...) -> () -> new Link(args...)