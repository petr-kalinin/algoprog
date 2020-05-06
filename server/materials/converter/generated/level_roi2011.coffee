import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_3102 = () ->
    return topic("2011", "2011", [
        problem(3393),
        problem(3394),
        problem(3395),
        problem(3396),
        problem(3397),
        problem(3398),
        problem(3399),
        problem(3400),
    ])

export default level_roi2011 = () ->
    return level("roi2011", "2011", [
        label("<h2>2011</h2>"),
        topic_3102(),
    ])