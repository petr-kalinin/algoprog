import ContestModel from '../../models/Contest'

class Contest
    constructor: (@id, @name, @contestSystem, @problems) ->

    build: (order) ->
        return new ContestModel
            _id: @id
            name: @name
            problems: []
            contestSystemData: {system: @contestSystem}
            order: order
        return material

export default contest = (args...) -> () -> new Contest(args...)