import {Label} from './label'

class Link extends Label
    constructor: (link, name) ->
        super("<a href='#{link}'>#{name}</a>")

export default link = (args...) -> new Link(args...)