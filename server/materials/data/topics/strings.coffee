import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default strings = () ->
    return {
        topic: topic(
            ruen("Символы и строки", "Characters and strings"),
            ruen("Задачи на символы и строки", "Problems on characters and strings"),
        [label(ruen(
             "<a href=\"https://notes.algoprog.ru/python_basics/4_strings.html\">Питон: теория по символам и строкам</a>",
             "<a href=\"https://notes.algoprog.ru/python_basics/4_strings.html\">Python: theory by symbols and strings</a>")),
            problem({testSystem: "ejudge", contest: "3007", problem: "1", id: "102"}),
            problem({testSystem: "ejudge", contest: "3007", problem: "2", id: "103"}),
            problem({testSystem: "ejudge", contest: "3007", problem: "3", id: "105"}),
            problem({testSystem: "ejudge", contest: "3007", problem: "4", id: "106"}),
            problem({testSystem: "ejudge", contest: "3007", problem: "5", id: "108"}),
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