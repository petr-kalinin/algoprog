import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default dijkstra = () ->
    return {
        topic: topic(
            ruen("Алгоритм Дейкстры", "Dijkstra's algorithm"),
            ruen("Задачи на алгоритм Дейкстры", "Problems on Dijkstra's algorithm"),
        [label(ruen(
             "<a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">Лекция про алгоритм Дейкстры в ЛКШ.2008.B'</a>, см. раздел «Алгоритм Дейкстры»<br>\n<a href=\"https://e-maxx.ru/algo/dijkstra\">Теория по алгоритму Дейкстры на e-maxx</a><br>\n<a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">Лекция про особенностям алгоритма Дейкстры в ЛКШ.2013.B'</a>, см. раздел «Кратчашие пути в графах» (частично; использование кучи вам пока не нужно)<br>",
             "<a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">Lecture about Dijkstra's algorithm in SIS.2008.B'</a>, see the section \"Dijkstra's algorithm\"<br>\n<a href=\"https://e-maxx.ru/algo/dijkstra\">Theory on Dijkstra's algorithm on e-maxx</a><br>\n<a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">A lecture on the features of Dijkstra's algorithm in SIS.2013.B'</a>, see the section \"Short paths in graphs\" (partially; you don't need to use the heap yet)<br>")),
            problem(5),
            problem(6),
            problem(7),
            problem(170),
        ], "dijkstra"),
        advancedProblems: [
            problem(1005),
            problem(2918),
        ]
    }