import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default arrays = () ->
    return {
        topic: topic(
            ruen("Массивы", "Arrays"),
            ruen("Задачи на массивы", "Problems on arrays"),
        [label(ruen(
             "<a href=\"https://notes.algoprog.ru/python_basics/3_arrays.html\">Теория по массивам</a>",
             "<a href=\"https://notes.algoprog.ru/en/python_basics/3_arrays.html\">Theory on arrays</a>")),
            problem({testSystem: "ejudge", contest: "3006", problem: "1", id: "63"}),
            problem({testSystem: "ejudge", contest: "3006", problem: "2", id: "64"}),
            problem({testSystem: "ejudge", contest: "3006", problem: "3", id: "66"}),
            problem({testSystem: "ejudge", contest: "3006", problem: "4", id: "69"}),
            problem({testSystem: "ejudge", contest: "3006", problem: "5", id: "71"}),
            problem({testSystem: "ejudge", contest: "3006", problem: "6", id: "72"}),
            problem({testSystem: "ejudge", contest: "3006", problem: "7", id: "355"}),
            problem({testSystem: "ejudge", contest: "3006", problem: "8", id: "357"}),
            problem({testSystem: "ejudge", contest: "3006", problem: "9", id: "362"}),
        ], "arrays"),
        advancedTopics: [
            contest(ruen(
                "Продвинутые задачи на массивы",
                "Advanced problems on arrays"), [
                problem({testSystem: "ejudge", contest: "3012", problem: "1", id: "1456"}),
                problem({testSystem: "ejudge", contest: "3012", problem: "2", id: "1228"}),
                problem({testSystem: "ejudge", contest: "3012", problem: "3", id: "201"}),
                problem({testSystem: "ejudge", contest: "3012", problem: "4", id: "1568"}),
            ])
        ]
    }