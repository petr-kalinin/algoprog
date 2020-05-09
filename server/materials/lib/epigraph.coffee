import  {Page} from './page'

class Epigraph extends Page
    constructor: (title, content) ->
        super(title, content, {type: "epigraph"})

export default epigraph = (args...) -> () -> new Epigraph(args...)