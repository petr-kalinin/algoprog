class Page
    constructor: (@title, @content) ->

    build: (context) ->
        data = 
            _id: context.generateId(),
            type: "page",
            content: @content
            title: @title

        await context.process(data)
        delete data.content
        return data

export default page = (args...) -> () -> new Page(args...)