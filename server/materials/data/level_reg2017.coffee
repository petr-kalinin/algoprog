import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_24703 = () ->
    return contest("2017, 2 тур", [
        problem(113443),
        problem(113444),
        problem(113445),
        problem(113446),
    ])

contest_24702 = () ->
    return contest("2017, 1 тур", [
        problem(113439),
        problem(113440),
        problem(113441),
        problem(113442),
    ])

export default level_reg2017 = () ->
    return level("reg2017", "2017", [
        contest_24702(),
        contest_24703(),
    ])