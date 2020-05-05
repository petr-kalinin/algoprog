import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest18806 = () ->
    return contest("2016, 2 тур", [
        problem(113100),
        problem(113101),
        problem(113102),
        problem(113103),
    ])

contest18805 = () ->
    return contest("2016, 1 тур", [
        problem(113096),
        problem(113097),
        problem(113098),
        problem(113099),
    ])

export default level_reg2016 = () ->
    return level("reg2016", "2016", [
        label("<h2>2016</h2>"),
        contest18805(),
        contest18806(),
    ])