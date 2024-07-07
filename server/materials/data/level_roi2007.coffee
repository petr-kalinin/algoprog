import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_199 = () ->
    return contest("2007, 1 тур", [
        problem(20),
        problem(21),
        problem(22),
    ])

contest_200 = () ->
    return contest("2007, 2 тур", [
        problem(23),
        problem(24),
        problem(25),
    ])

export default level_roi2007 = () ->
    return level("roi2007", "2007", [
        contest_199(),
        contest_200(),
    ])