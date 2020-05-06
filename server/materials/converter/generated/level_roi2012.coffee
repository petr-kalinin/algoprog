import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_4908 = () ->
    return topic("2012", "2012", [
        problem(111221),
        problem(111222),
        problem(111223),
        problem(111224),
        problem(111225),
        problem(111226),
        problem(111562),
        problem(111227),
    ])

export default level_roi2012 = () ->
    return level("roi2012", "2012", [
        label("<h2>2012</h2>"),
        topic_4908(),
    ])