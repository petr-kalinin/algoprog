import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_10372 = () ->
    return topic("2014, 1 тур", "2014, 1 тур", [
        problem(112036),
        problem(112037),
        problem(112038),
        problem(112039),
    ])

topic_10376 = () ->
    return topic("2014, 2 тур", "2014, 2 тур", [
        problem(112040),
        problem(112041),
        problem(112042),
        problem(112043),
    ])

export default level_reg2014 = () ->
    return level("reg2014", "2014", [
        label("<h2>2014</h2>"),
        topic_10372(),
        topic_10376(),
    ])