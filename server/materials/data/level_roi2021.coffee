import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_76875 = () ->
    return contest("2021, 1 тур", [
        problem(114896),
        problem(114897),
        problem(114898),
    ])

contest_76876 = () ->
    return contest("2021, 2 тур", [
        problem(114895),
        problem(114894),
        problem(114899),
        problem(114900),
    ])

export default level_roi2021 = () ->
    return level("roi2021", "2021", [
        contest_76875(),
        contest_76876(),
    ])