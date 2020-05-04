class NewsItem
    constructor: (@title, @content) ->

    build: (context) ->
        data =
            _id: context.generateId(),
            type: "newsItem",
            title: @title,
            content: @content,

        await context.process(data)
        return data 

export default newsItem = (args...) -> new NewsItem(args...)
