import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_895 = () ->
    return contest("2009, 2 тур", [
        problem(1209),
        problem(1210),
        problem(1211),
        problem(1212),
    ])

contest_894 = () ->
    return contest("2009, 1 тур", [
        problem(1205),
        problem(1206),
        problem(1207),
        problem(1208),
    ])

export default level_reg2009 = () ->
    return level("reg2009", "2009", [
        contest_894(),
        contest_895(),
    ])