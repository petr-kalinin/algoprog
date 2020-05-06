import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_14483 = () ->
    return topic("2015, 2 тур", "2015, 2 тур", [
        problem(112748),
        problem(112749),
        problem(112750),
        problem(112751),
    ])

topic_14482 = () ->
    return topic("2015, 1 тур", "2015, 1 тур", [
        problem(112744),
        problem(112745),
        problem(112746),
        problem(112747),
    ])

export default level_reg2015 = () ->
    return level("reg2015", "2015", [
        label("<h2>2015</h2>"),
        topic_14482(),
        topic_14483(),
    ])