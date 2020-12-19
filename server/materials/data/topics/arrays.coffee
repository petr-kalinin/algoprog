import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default arrays = () ->
    return {
        topic: topic("Массивы", "Задачи на массивы", [
            label("<a href=\"https://notes.algoprog.ru/python_basics/3_arrays.html\">Питон: теория по массивам</a>"),
            problem(63),
            problem(64),
            problem(66),
            problem(69),
            problem(71),
            problem(72),
            problem(355),
            problem(357),
            problem(362),
        ], "arrays"),
        advancedTopics: [
            contest("Продвинутые задачи на массивы", [
                problem(1456),
                problem(1228),
                problem(201),
                problem(1568),
            ])
        ]
    }