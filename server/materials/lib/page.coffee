export class Page
    constructor: (@title, @content, options={}) ->
        {@type="page", @skipTree=false, @id} = options

    build: (context, order) ->
        data = 
            _id: if @id then "#{@id}#{context.label}" else context.generateId(),
            type: @type,
            content: @content
            title: @title
            order: order

        if @skipTree
            data.treeTitle = null 

        await context.process(data)
        delete data.content
        return data

export default page = (args...) -> () -> new Page(args...)