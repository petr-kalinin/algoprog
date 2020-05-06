import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_2748 = () ->
    return topic("2011, 1 тур", "2011, 1 тур", [
        problem(3181),
        problem(3182),
        problem(3183),
        problem(3184),
    ])

topic_2780 = () ->
    return topic("2011, 2 тур", "2011, 2 тур", [
        problem(3206),
        problem(3207),
        problem(3208),
        problem(3209),
    ])

export default level_reg2011 = () ->
    return level("reg2011", "2011", [
        label("<h2>2011</h2>"),
        topic_2748(),
        topic_2780(),
    ])