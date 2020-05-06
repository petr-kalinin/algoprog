import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_4345 = () ->
    return topic("2012, 1 тур", "2012, 1 тур", [
        problem(3864),
        problem(3865),
        problem(3866),
        problem(3867),
    ])

topic_4361 = () ->
    return topic("2012, 2 тур", "2012, 2 тур", [
        problem(3868),
        problem(3869),
        problem(3870),
        problem(3871),
    ])

export default level_reg2012 = () ->
    return level("reg2012", "2012", [
        label("<h2>2012</h2>"),
        topic_4345(),
        topic_4361(),
    ])