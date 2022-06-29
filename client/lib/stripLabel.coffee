export default stripLabel = (id) ->
    idx = id.indexOf("!")
    if idx != -1
        return id.substring(0, idx)
    return id

