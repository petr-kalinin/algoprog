import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_20058 = () ->
    return contest("2016, 1 тур", [
        problem(113217),
        problem(113218),
        problem(113219),
        problem(113220),
    ])

contest_20059 = () ->
    return contest("2016, 2 тур", [
        problem(113221),
        problem(113222),
        problem(113223),
        problem(113224),
    ])

export default level_roi2016 = () ->
    return level("roi2016", "2016", [
        contest_20058(),
        contest_20059(),
    ])