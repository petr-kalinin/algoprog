import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_922 = () ->
    return contest("2008, 1 тур", [
        problem(1216),
        problem(1217),
        problem(1277),
    ])

contest_988 = () ->
    return contest("2008, 2 тур", [
        problem(1281),
        problem(1282),
        problem(1283),
    ])

export default level_roi2008 = () ->
    return level("roi2008", "2008", [
        contest_922(),
        contest_988(),
    ])