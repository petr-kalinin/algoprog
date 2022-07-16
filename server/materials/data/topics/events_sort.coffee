import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default events_sort = () ->
    return {
        topic: topic(
            ruen("Сортировка событий", "Sorting events"),
            ruen("Задачи на сортировку событий", "Problems on sorting events"),
        [label(ruen(
             "См. <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">видеозаписи лекций ЛКШ параллели B'</a>, раздел «Отрезки на прямой»<br>",
             "See video <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">recordings of lectures of the Parallel B'</a> LCS, section \"Straight line segments\"<br>")),
            problem(112542),
            problem(1755),
            problem(3721),
            problem(1338),
            problem(111790),
        ], "events_sort"),
        advancedProblems: [
            problem(1622)
        ]
    }
