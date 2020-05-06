import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_11348 = () ->
    return contest("2014, 2 тур", [
        problem(112328),
        problem(112330),
        problem(112329),
    ])

contest_11347 = () ->
    return contest("2014, 1 тур", [
        problem(112335),
        problem(112332),
        problem(112333),
        problem(112334),
    ])

export default level_roi2014 = () ->
    return level("roi2014", "2014", [
        contest_11347(),
        contest_11348(),
    ])