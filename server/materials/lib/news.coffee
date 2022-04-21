import MaterialList from "./MaterialList"

labelToName = 
    "": "Новости"
    "en": "News"

class News extends MaterialList
    constructor: (materials) ->
        super(materials)

    build: (context, order) ->
        properties = 
            _id: "news#{context.label}"
            type: "news"
            title: labelToName[context.label]

        material = await super.build(context, order, properties)

        return material

export default news = (args...) -> () -> new News(args...)