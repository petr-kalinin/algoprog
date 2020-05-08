import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_14483 = () ->
    return contest("2015, 2 тур", [
        problem(112748),
        problem(112749),
        problem(112750),
        problem(112751),
    ])

contest_14482 = () ->
    return contest("2015, 1 тур", [
        problem(112744),
        problem(112745),
        problem(112746),
        problem(112747),
    ])

export default level_reg2015 = () ->
    return level("reg2015", "2015", [
        contest_14482(),
        contest_14483(),
    ])