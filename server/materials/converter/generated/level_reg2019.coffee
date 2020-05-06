import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_40162 = () ->
    return topic("2019, 1 тур", "2019, 1 тур", [
        problem(114038),
        problem(114039),
        problem(114040),
        problem(114041),
    ])

topic_40163 = () ->
    return topic("2019, 2 тур", "2019, 2 тур", [
        problem(114042),
        problem(114043),
        problem(114044),
        problem(114045),
    ])

export default level_reg2019 = () ->
    return level("reg2019", "2019", [
        label("<h2>2019</h2>"),
        topic_40162(),
        topic_40163(),
    ])