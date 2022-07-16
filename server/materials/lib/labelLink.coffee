import {Label} from './label'

class LabelLink extends Label
    constructor: (link, name) ->
        super((label) -> "<a href='#{link?(label) || link}'>#{name?(label) || name}</a>")

export default labelLink = (args...) -> () -> new LabelLink(args...)