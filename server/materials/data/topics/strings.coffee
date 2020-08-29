import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default strings = () ->
    return topic("Символы и строки", "1Б: Задачи на символы и строки", [
        label("<a href=\"https://notes.algoprog.ru/python_basics/4_strings.html\">Питон: теория по символам и строкам</a>"),
        problem(102),
        problem(103),
        problem(105),
        problem(106),
        problem(108),
    ])