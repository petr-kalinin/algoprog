export class Page
    constructor: (@title, @content, options={}) ->
        {@type="page", @skipTree=false} = options

    build: (context) ->
        data = 
            _id: context.generateId(),
            type: @type,
            content: @content
            title: @title

        if @skipTree
            data.treeTitle = null 

        await context.process(data)
        delete data.content
        return data

export default page = (args...) -> () -> new Page(args...)