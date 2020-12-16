import MaterialList from "./MaterialList"

class News extends MaterialList
    constructor: (materials) ->
        super(materials)

    build: (context, order) ->
        properties = 
            _id: "news"
            type: "news"
            title: "Новости"

        material = await super.build(context, order, properties)

        return material

export default news = (args...) -> () -> new News(args...)