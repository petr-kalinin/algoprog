import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_30793 = () ->
    return topic("2018, 1 тур", "2018, 1 тур", [
        problem(113757),
        problem(113758),
        problem(113759),
        problem(113760),
    ])

topic_30794 = () ->
    return topic("2018, 2 тур", "2018, 2 тур", [
        problem(113761),
        problem(113762),
        problem(113763),
        problem(113764),
    ])

export default level_reg2018 = () ->
    return level("reg2018", "2018", [
        label("<h2>2018</h2>"),
        topic_30793(),
        topic_30794(),
    ])