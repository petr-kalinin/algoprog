import Material from '../../models/Material'

class NewsItem
    constructor: (@title, @content) ->

    build: (context) ->
        data =
            _id: context.generateId(),
            type: "newsItem",
            title: @title,
            content: @content,

        material = new Material(data)
        await context.process(material)
        return data 

export default newsItem = (args...) -> new NewsItem(args...)
