export class Page
    constructor: (@title, @content, options={}) ->
        {@type="page", @skipTree=false, @id} = options
        if options.id
            console.log "Have id in options: id=#{@id}"

    build: (context, order) ->
        data = 
            _id: @id || context.generateId(),
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