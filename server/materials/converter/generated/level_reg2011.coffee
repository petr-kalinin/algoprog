import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_2780 = () ->
    return contest("2011, 2 тур", [
        problem(3206),
        problem(3207),
        problem(3208),
        problem(3209),
    ])

contest_2748 = () ->
    return contest("2011, 1 тур", [
        problem(3181),
        problem(3182),
        problem(3183),
        problem(3184),
    ])

export default level_reg2011 = () ->
    return level("reg2011", "2011", [
        contest_2748(),
        contest_2780(),
    ])