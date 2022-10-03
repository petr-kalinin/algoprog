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
             "<a href=\"https://notes.algoprog.ru/python_basics/4_strings.html\">Теория по символам и строкам</a>",
             "<a href=\"https://notes.algoprog.ru/en/python_basics/4_strings.html\">Theory on characters and strings</a>")),
            problem({testSystem: "ejudge", contest: "3007", problem: "1", id: "102"}),
            problem({testSystem: "ejudge", contest: "3007", problem: "2", id: "103"}),
            problem({testSystem: "ejudge", contest: "3007", problem: "3", id: "105"}),
            problem({testSystem: "ejudge", contest: "3007", problem: "4", id: "106"}),
            problem({testSystem: "ejudge", contest: "3007", problem: "5", id: "108"}),
        ], "strings"),
        advancedTopics: [
            contest(ruen(
                "Продвинутые задачи на строки",
                "Advanced problems on strings"), [
                problem({testSystem: "ejudge", contest: "3013", problem: "1", id: "107"}),
                problem({testSystem: "ejudge", contest: "3013", problem: "2", id: "109"}),
                problem({testSystem: "ejudge", contest: "3013", problem: "3", id: "112"}),
                problem({testSystem: "ejudge", contest: "3013", problem: "4", id: "111"}),
                problem({testSystem: "ejudge", contest: "3013", problem: "5", id: "723"}),
                problem({testSystem: "ejudge", contest: "3013", problem: "6", id: "792"}),
                problem({testSystem: "ejudge", contest: "3013", problem: "7", id: "1667"}),
            ])
        ]
    }