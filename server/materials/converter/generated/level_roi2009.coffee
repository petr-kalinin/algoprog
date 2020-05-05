import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest1041 = () ->
    return contest("2009", [
        problem(1337),
        problem(1338),
        problem(1339),
        problem(1340),
        problem(1341),
        problem(1342),
    ])

export default level_roi2009 = () ->
    return level("roi2009", "2009", [
        label("<h2>2009</h2>"),
        contest1041(),
    ])