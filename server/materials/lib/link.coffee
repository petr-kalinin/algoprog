class Link
    constructor: (@id, @link, @title) ->

    build: (context) ->
        data = 
            _id: @id,
            type: "link",
            content: @link
            title: "Комментарии"

        await context.process(data)
        return data

export default link = (args...) -> () -> new Link(args...)