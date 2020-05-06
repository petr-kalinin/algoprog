import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_7334 = () ->
    return topic("2013, 1 тур", "2013, 1 тур", [
        problem(111633),
        problem(111634),
        problem(111635),
        problem(111636),
    ])

topic_7513 = () ->
    return topic("2013, 2 тур", "2013, 2 тур", [
        problem(111637),
        problem(111644),
        problem(111645),
        problem(111646),
    ])

export default level_roi2013 = () ->
    return level("roi2013", "2013", [
        label("<h2>2013</h2>"),
        topic_7334(),
        topic_7513(),
    ])