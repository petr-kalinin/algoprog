import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest7513 = () ->
    return contest("2013, 2 тур", [
        problem(111637),
        problem(111644),
        problem(111645),
        problem(111646),
    ])

contest7334 = () ->
    return contest("2013, 1 тур", [
        problem(111633),
        problem(111634),
        problem(111635),
        problem(111636),
    ])

export default level_roi2013 = () ->
    return level("roi2013", "2013", [
        label("<h2>2013</h2>"),
        contest7334(),
        contest7513(),
    ])