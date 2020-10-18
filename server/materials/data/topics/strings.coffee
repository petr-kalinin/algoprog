import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default strings = () ->
    return {
        topic: topic("Символы и строки", "Задачи на символы и строки", [
            label("<a href=\"https://notes.algoprog.ru/python_basics/4_strings.html\">Питон: теория по символам и строкам</a>"),
            problem(102),
            problem(103),
            problem(105),
            problem(106),
            problem(108),
        ], "strings"),
        advancedTopics: [
            contest("Продвинутые задачи на строки", [
                problem(107),
                problem(109),
                problem(112),
                problem(111),
                problem(723),
                problem(792),
                problem(1667),
            ])
        ]
    }