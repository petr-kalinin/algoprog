import contest from "../../lib/contest"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_7513 = () ->
    return contest("2013, 2 тур", [
        problem(111637),
        problem(111644),
        problem(111645),
        problem(111646),
    ])

contest_7334 = () ->
    return contest("2013, 1 тур", [
        problem(111633),
        problem(111634),
        problem(111635),
        problem(111636),
    ])

export default level_roi2013 = () ->
    return level("roi2013", "2013", [
        contest_7334(),
        contest_7513(),
    ])