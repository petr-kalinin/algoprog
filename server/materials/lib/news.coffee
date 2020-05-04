import MaterialList from "./MaterialList"

class News extends MaterialList
    constructor: (materials) ->
        super(materials)

    build: (context) ->
        properties = 
            _id: "news"
            type: "news"
            title: "Новости"

        context.pushLevel("news")
        material = await super.build(context, properties)
        context.popLevel()

        return material

export default news = (args...) -> new News(args...)