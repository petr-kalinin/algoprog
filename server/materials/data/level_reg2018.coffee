import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_30794 = () ->
    return contest("2018, 2 тур", [
        problem(113761),
        problem(113762),
        problem(113763),
        problem(113764),
    ])

contest_30793 = () ->
    return contest("2018, 1 тур", [
        problem(113757),
        problem(113758),
        problem(113759),
        problem(113760),
    ])

export default level_reg2018 = () ->
    return level("reg2018", "2018", [
        contest_30793(),
        contest_30794(),
    ])