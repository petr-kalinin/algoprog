import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest41903 = () ->
    return contest("2019, 1 тур", [
        problem(114125),
        problem(114126),
        problem(114127),
        problem(114128),
    ])

contest41904 = () ->
    return contest("2019, 2 тур", [
        problem(114129),
        problem(114130),
        problem(114131),
        problem(114132),
    ])

export default level_roi2019 = () ->
    return level("roi2019", "2019", [
        label("<h2>2019</h2>"),
        contest41903(),
        contest41904(),
    ])