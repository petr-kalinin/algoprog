import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_10372 = () ->
    return contest("2014, 1 тур", [
        problem(112036),
        problem(112037),
        problem(112038),
        problem(112039),
    ])

contest_10376 = () ->
    return contest("2014, 2 тур", [
        problem(112040),
        problem(112041),
        problem(112042),
        problem(112043),
    ])

export default level_reg2014 = () ->
    return level("reg2014", "2014", [
        contest_10372(),
        contest_10376(),
    ])