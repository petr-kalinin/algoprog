import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default dijkstra = () ->
    return {
        topic: topic("Алгоритм Дейкстры", "Задачи на алгоритм Дейкстры", [
            label("<a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">Лекция про алгоритм Дейкстры в ЛКШ.2008.B'</a>, см. раздел «Алгоритм Дейкстры»<br>\n<a href=\"https://e-maxx.ru/algo/dijkstra\">Теория по алгоритму Дейкстры на e-maxx</a><br>\n<a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">Лекция про особенностям алгоритма Дейкстры в ЛКШ.2013.B'</a>, см. раздел «Кратчашие пути в графах» (частично; использование кучи вам пока не нужно)<br>"),
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