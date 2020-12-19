import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default events_sort = () ->
    return {
        topic: topic("Сортировка событий", "Задачи на сортировку событий", [
            label("См. <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">видеозаписи лекций ЛКШ параллели B'</a>, раздел «Отрезки на прямой»<br>"),
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
