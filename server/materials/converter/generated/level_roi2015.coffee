import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_15255 = () ->
    return contest("2015, 1 тур", [
        problem(112815),
        problem(112816),
        problem(112817),
        problem(112818),
    ])

contest_15256 = () ->
    return contest("2015, 2 тур", [
        problem(112819),
        problem(112820),
        problem(112821),
        problem(112822),
    ])

export default level_roi2015 = () ->
    return level("roi2015", "2015", [
        contest_15255(),
        contest_15256(),
    ])