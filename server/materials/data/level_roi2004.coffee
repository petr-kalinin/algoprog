import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_791 = () ->
    return contest("2004, 1 тур", [
        problem(1047),
        problem(1048),
        problem(1049),
    ])

contest_805 = () ->
    return contest("2004, 2 тур", [
        problem(1053),
        problem(1054),
        problem(1055),
    ])

export default level_roi2004 = () ->
    return level("roi2004", "2004", [
        contest_791(),
        contest_805(),
    ])