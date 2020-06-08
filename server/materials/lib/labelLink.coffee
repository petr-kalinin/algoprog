import {Label} from './label'

class LabelLink extends Label
    constructor: (link, name) ->
        super("<a href='#{link}'>#{name}</a>")

export default labelLink = (args...) -> () -> new LabelLink(args...)