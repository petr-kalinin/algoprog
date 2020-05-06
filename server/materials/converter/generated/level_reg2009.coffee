import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_894 = () ->
    return topic("2009, 1 тур", "2009, 1 тур", [
        problem(1205),
        problem(1206),
        problem(1207),
        problem(1208),
    ])

topic_895 = () ->
    return topic("2009, 2 тур", "2009, 2 тур", [
        problem(1209),
        problem(1210),
        problem(1211),
        problem(1212),
    ])

export default level_reg2009 = () ->
    return level("reg2009", "2009", [
        label("<h2>2009</h2>"),
        topic_894(),
        topic_895(),
    ])