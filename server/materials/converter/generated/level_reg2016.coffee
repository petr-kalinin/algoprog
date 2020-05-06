import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_18806 = () ->
    return topic("2016, 2 тур", "2016, 2 тур", [
        problem(113100),
        problem(113101),
        problem(113102),
        problem(113103),
    ])

topic_18805 = () ->
    return topic("2016, 1 тур", "2016, 1 тур", [
        problem(113096),
        problem(113097),
        problem(113098),
        problem(113099),
    ])

export default level_reg2016 = () ->
    return level("reg2016", "2016", [
        label("<h2>2016</h2>"),
        topic_18805(),
        topic_18806(),
    ])