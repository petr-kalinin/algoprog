import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_1681 = () ->
    return contest("2010", [
        problem(2529),
        problem(2530),
        problem(2531),
        problem(2532),
        problem(2533),
        problem(2534),
    ])

export default level_roi2010 = () ->
    return level("roi2010", "2010", [
        contest_1681(),
    ])