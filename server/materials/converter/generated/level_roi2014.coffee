import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest11347 = () ->
    return contest("2014, 1 тур", [
        problem(112335),
        problem(112332),
        problem(112333),
        problem(112334),
    ])

contest11348 = () ->
    return contest("2014, 2 тур", [
        problem(112328),
        problem(112330),
        problem(112329),
    ])

export default level_roi2014 = () ->
    return level("roi2014", "2014", [
        label("<h2>2014</h2>"),
        contest11347(),
        contest11348(),
    ])