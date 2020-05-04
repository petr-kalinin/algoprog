import Material from '../../models/Material'

class NewsItem
    constructor: (@title, @content) ->

    build: (context) ->
        material = new Material
            _id: context.generateId(),
            type: "newsItem",
            title: @title,
            content: @content,
            materials: []
        await context.process(material)
        return material

export default newsItem = (args...) -> new NewsItem(args...)
