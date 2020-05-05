import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest26245 = () ->
    return contest("2017, 1 тур", [
        problem(113544),
        problem(113545),
        problem(113546),
        problem(113547),
    ])

contest26246 = () ->
    return contest("2017, 2 тур", [
        problem(113548),
        problem(113549),
        problem(113550),
        problem(113551),
    ])

export default level_roi2017 = () ->
    return level("roi2017", "2017", [
        label("<h2>2017</h2>"),
        contest26245(),
        contest26246(),
    ])