import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_26245 = () ->
    return topic("2017, 1 тур", "2017, 1 тур", [
        problem(113544),
        problem(113545),
        problem(113546),
        problem(113547),
    ])

topic_26246 = () ->
    return topic("2017, 2 тур", "2017, 2 тур", [
        problem(113548),
        problem(113549),
        problem(113550),
        problem(113551),
    ])

export default level_roi2017 = () ->
    return level("roi2017", "2017", [
        label("<h2>2017</h2>"),
        topic_26245(),
        topic_26246(),
    ])