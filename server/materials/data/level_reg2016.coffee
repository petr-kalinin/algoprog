import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_18805 = () ->
    return contest("2016, 1 тур", [
        problem(113096),
        problem(113097),
        problem(113098),
        problem(113099),
    ])

contest_18806 = () ->
    return contest("2016, 2 тур", [
        problem(113100),
        problem(113101),
        problem(113102),
        problem(113103),
    ])

export default level_reg2016 = () ->
    return level("reg2016", "2016", [
        contest_18805(),
        contest_18806(),
    ])