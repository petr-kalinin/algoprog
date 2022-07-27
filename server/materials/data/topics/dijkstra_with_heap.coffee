import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default dijkstra_with_heap = () ->
    return {
        topic: topic(
            ruen("Алгоритм Дейкстры с кучей", "Dijkstra's algorithm with heap"),
            ruen("Задачи на алгоритм Дейкстры с кучей", "Problems on Dijkstra's algorithm with heap"),
        [label(ruen(
             "См. <a href=\"https://sis.khashaev.ru/2013/july/b-prime/JbeOdEYcQ2Y/\">видеозаписи лекций ЛКШ.2013.B'</a>, раздел \"Алгоритм Дейкстры поиска кратчайших путей. Использование кучи.\"",
             "See the video <a href=\"https://sis.khashaev.ru/2013/july/b-prime/JbeOdEYcQ2Y/\">recordings of lectures SIS.2013.B'</a>, section \"Dijkstra algorithm for finding shortest paths. Using the heap.\"")),
            problem(3494),
            problem(1745),
            problem(1087),
        ], "dijkstra_with_heap"),
        advancedProblems: [
            problem(1967),
        ]
    }