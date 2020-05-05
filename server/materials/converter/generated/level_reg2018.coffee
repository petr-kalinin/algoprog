import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest30794 = () ->
    return contest("2018, 2 тур", [
        problem(113761),
        problem(113762),
        problem(113763),
        problem(113764),
    ])

contest30793 = () ->
    return contest("2018, 1 тур", [
        problem(113757),
        problem(113758),
        problem(113759),
        problem(113760),
    ])

export default level_reg2018 = () ->
    return level("reg2018", "2018", [
        label("<h2>2018</h2>"),
        contest30793(),
        contest30794(),
    ])