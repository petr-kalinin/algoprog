import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_24702 = () ->
    return topic("2017, 1 тур", "2017, 1 тур", [
        problem(113439),
        problem(113440),
        problem(113441),
        problem(113442),
    ])

topic_24703 = () ->
    return topic("2017, 2 тур", "2017, 2 тур", [
        problem(113443),
        problem(113444),
        problem(113445),
        problem(113446),
    ])

export default level_reg2017 = () ->
    return level("reg2017", "2017", [
        label("<h2>2017</h2>"),
        topic_24702(),
        topic_24703(),
    ])