import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_4908 = () ->
    return contest("2012", [
        problem(111221),
        problem(111222),
        problem(111223),
        problem(111224),
        problem(111225),
        problem(111226),
        problem(111562),
        problem(111227),
    ])

export default level_roi2012 = () ->
    return level("roi2012", "2012", [
        contest_4908(),
    ])