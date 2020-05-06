import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_1540 = () ->
    return topic("2010, 1 тур", "2010, 1 тур", [
        problem(1922),
        problem(1923),
        problem(1924),
        problem(1925),
    ])

topic_1541 = () ->
    return topic("2010, 2 тур", "2010, 2 тур", [
        problem(1926),
        problem(1927),
        problem(1928),
        problem(1929),
    ])

export default level_reg2010 = () ->
    return level("reg2010", "2010", [
        label("<h2>2010</h2>"),
        topic_1540(),
        topic_1541(),
    ])