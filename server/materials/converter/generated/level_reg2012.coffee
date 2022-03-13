import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_4361 = () ->
    return contest("2012, 2 тур", [
        problem(3868),
        problem(3869),
        problem(3870),
        problem(3871),
    ])

contest_4345 = () ->
    return contest("2012, 1 тур", [
        problem(3864),
        problem(3865),
        problem(3866),
        problem(3867),
    ])

export default level_reg2012 = () ->
    return level("reg2012", "2012", [
        contest_4345(),
        contest_4361(),
    ])