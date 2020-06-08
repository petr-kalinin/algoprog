import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_40162 = () ->
    return contest("2019, 1 тур", [
        problem(114038),
        problem(114039),
        problem(114040),
        problem(114041),
    ])

contest_40163 = () ->
    return contest("2019, 2 тур", [
        problem(114042),
        problem(114043),
        problem(114044),
        problem(114045),
    ])

export default level_reg2019 = () ->
    return level("reg2019", "2019", [
        contest_40162(),
        contest_40163(),
    ])