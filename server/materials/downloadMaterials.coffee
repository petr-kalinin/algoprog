import root from './root'

class SaveMaterialContext 
    constructor: () ->
        @levelToId = {}
        @levelStack = [""]


    process: (material) ->
        console.log "Have material ", material

    pushLevel: (id) ->
        @levelStack.push id

    popLevel: (id) ->
        @levelStack.pop()

    generateId: () ->
        level = @levelStack[@levelStack.length - 1]
        if not (level of @levelToId)
            @levelToId[level] = 0
        @levelToId[level]++
        return "#{level}.#{@levelToId[level]}"


export default downloadMaterials = () ->
    context = new SaveMaterialContext()
    root().build(context)