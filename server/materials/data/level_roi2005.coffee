import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_195 = () ->
    return contest("2005, 1 тур", [
        problem(9),
        problem(10),
        problem(11),
    ])

contest_196 = () ->
    return contest("2005, 2 тур", [
        problem(12),
        problem(13),
        problem(14),
    ])

export default level_roi2005 = () ->
    return level("roi2005", "2005", [
        contest_195(),
        contest_196(),
    ])