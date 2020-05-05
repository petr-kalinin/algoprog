import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest14483 = () ->
    return contest("2015, 2 тур", [
        problem(112748),
        problem(112749),
        problem(112750),
        problem(112751),
    ])

contest14482 = () ->
    return contest("2015, 1 тур", [
        problem(112744),
        problem(112745),
        problem(112746),
        problem(112747),
    ])

export default level_reg2015 = () ->
    return level("reg2015", "2015", [
        label("<h2>2015</h2>"),
        contest14482(),
        contest14483(),
    ])