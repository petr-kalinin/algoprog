import ContestModel from '../../models/Contest'

class Contest
    constructor: (@id, @name, @contestSystem, @problems, @length) ->

    build: (order) ->
        return new ContestModel
            _id: @id
            name: @name
            problems: []
            contestSystemData: {system: @contestSystem}
            order: order
            length: @length * 60 * 1000
        return material

export default contest = (args...) -> () -> new Contest(args...)