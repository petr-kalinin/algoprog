import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_74625 = () ->
    return contest("2022, 1 тур", [
        problem(114760),
        problem(114761),
        problem(114762),
        problem(114763),
    ])

contest_74664 = () ->
    return contest("2022, 2 тур", [
        problem(114764),
        problem(114765),
        problem(114766),
        problem(114767),
    ])

export default level_roi2022 = () ->
    return level("roi2022", "2022", [
        contest_74625(),
        contest_74664(),
    ])