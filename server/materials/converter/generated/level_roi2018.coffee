import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_32817 = () ->
    return topic("2018, 1 тур", "2018, 1 тур", [
        problem(113911),
        problem(113912),
        problem(113913),
        problem(113914),
    ])

topic_32818 = () ->
    return topic("2018, 2 тур", "2018, 2 тур", [
        problem(113915),
        problem(113916),
        problem(113917),
        problem(113918),
    ])

export default level_roi2018 = () ->
    return level("roi2018", "2018", [
        label("<h2>2018</h2>"),
        topic_32817(),
        topic_32818(),
    ])