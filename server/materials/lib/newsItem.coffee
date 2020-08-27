class NewsItem
    constructor: (@title, @content) ->

    build: (context, order) ->
        data =
            _id: context.generateId(),
            type: "newsItem",
            title: @title,
            content: @content,
            order: order

        await context.process(data)
        return data 

export default newsItem = (args...) -> () -> new NewsItem(args...)
