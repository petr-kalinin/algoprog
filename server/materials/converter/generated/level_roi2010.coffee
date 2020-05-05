import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest1681 = () ->
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
        label("<h2>2010</h2>"),
        contest1681(),
    ])