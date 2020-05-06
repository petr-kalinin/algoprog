import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_11348 = () ->
    return topic("2014, 2 тур", "2014, 2 тур", [
        problem(112328),
        problem(112330),
        problem(112329),
    ])

topic_11347 = () ->
    return topic("2014, 1 тур", "2014, 1 тур", [
        problem(112335),
        problem(112332),
        problem(112333),
        problem(112334),
    ])

export default level_roi2014 = () ->
    return level("roi2014", "2014", [
        label("<h2>2014</h2>"),
        topic_11347(),
        topic_11348(),
    ])