import ContestModel from '../../models/Contest'

class Contest
    constructor: (@id, @name, @contestSystem, @problems, @length, @freeze, @hasStatements=false) ->

    build: (order) ->
        return new ContestModel
            _id: @id
            name: @name
            problems: []
            contestSystemData: {system: @contestSystem}
            order: order
            length: if @length then @length * 60 * 1000 else null
            freeze: if @freeze then @freeze * 60 * 1000 else null
            hasStatements: @hasStatements
        return material

export default contest = (args...) -> () -> new Contest(args...)