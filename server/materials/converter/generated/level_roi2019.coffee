import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_41903 = () ->
    return contest("2019, 1 тур", [
        problem(114125),
        problem(114126),
        problem(114127),
        problem(114128),
    ])

contest_41904 = () ->
    return contest("2019, 2 тур", [
        problem(114129),
        problem(114130),
        problem(114131),
        problem(114132),
    ])

export default level_roi2019 = () ->
    return level("roi2019", "2019", [
        contest_41903(),
        contest_41904(),
    ])