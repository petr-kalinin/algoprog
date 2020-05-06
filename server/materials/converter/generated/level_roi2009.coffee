import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_1041 = () ->
    return topic("2009", "2009", [
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
        topic_1041(),
    ])