import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_1540 = () ->
    return contest("2010, 1 тур", [
        problem(1922),
        problem(1923),
        problem(1924),
        problem(1925),
    ])

contest_1541 = () ->
    return contest("2010, 2 тур", [
        problem(1926),
        problem(1927),
        problem(1928),
        problem(1929),
    ])

export default level_reg2010 = () ->
    return level("reg2010", "2010", [
        contest_1540(),
        contest_1541(),
    ])