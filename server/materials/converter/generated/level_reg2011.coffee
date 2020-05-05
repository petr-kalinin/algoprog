import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest2780 = () ->
    return contest("2011, 2 тур", [
        problem(3206),
        problem(3207),
        problem(3208),
        problem(3209),
    ])

contest2748 = () ->
    return contest("2011, 1 тур", [
        problem(3181),
        problem(3182),
        problem(3183),
        problem(3184),
    ])

export default level_reg2011 = () ->
    return level("reg2011", "2011", [
        label("<h2>2011</h2>"),
        contest2748(),
        contest2780(),
    ])