import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_197 = () ->
    return contest("2006, 1 тур", [
        problem(8),
        problem(15),
        problem(16),
    ])

contest_198 = () ->
    return contest("2006, 2 тур", [
        problem(17),
        problem(18),
        problem(19),
    ])

export default level_roi2006 = () ->
    return level("roi2006", "2006", [
        contest_197(),
        contest_198(),
    ])