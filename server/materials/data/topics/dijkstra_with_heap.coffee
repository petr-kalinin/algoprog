import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default dijkstra_with_heap = () ->
    return {
        topic: topic("Алгоритм Дейкстры с кучей", "Задачи на алгоритм Дейкстры с кучей", [
            label("См. <a href=\"https://sis.khashaev.ru/2013/july/b-prime/JbeOdEYcQ2Y/\">видеозаписи лекций ЛКШ.2013.B'</a>, раздел \"Алгоритм Дейкстры поиска кратчайших путей. Использование кучи.\""),
            problem(3494),
            problem(1745),
            problem(1087),
        ], "dijkstra_with_heap"),
        advancedProblems: [
            problem(1967),
        ]
    }