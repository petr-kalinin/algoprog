import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_15255 = () ->
    return topic("2015, 1 тур", "2015, 1 тур", [
        problem(112815),
        problem(112816),
        problem(112817),
        problem(112818),
    ])

topic_15256 = () ->
    return topic("2015, 2 тур", "2015, 2 тур", [
        problem(112819),
        problem(112820),
        problem(112821),
        problem(112822),
    ])

export default level_roi2015 = () ->
    return level("roi2015", "2015", [
        label("<h2>2015</h2>"),
        topic_15255(),
        topic_15256(),
    ])