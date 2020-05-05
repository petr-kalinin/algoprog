export class Page
    constructor: (@title, @content, type="page") ->
        @type = type

    build: (context) ->
        data = 
            _id: context.generateId(),
            type: @type,
            content: @content
            title: @title

        await context.process(data)
        delete data.content
        return data

export default page = (args...) -> () -> new Page(args...)