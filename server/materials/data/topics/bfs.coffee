import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default bfs = () ->
    return {
        topic: topic("Поиск в ширину", "Задачи на поиск в ширину", [
            label("См. <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Поиск в ширину (BFS)»<br>\nСм. <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ параллели B' 2008</a>, раздел «Поиск в ширину» (там есть и довольно продвинутые темы, которые вам пока не нужны)<br>"),
            problem(160),
            problem(161),
            problem(646),
            problem(645),
            problem(1329),
            problem(510),
        ], "bfs"),
        advancedProblems: [
            problem(1030),
            problem(162),
            problem(1472),
            problem(1764),
            problem(608),
            problem(1766),
        ]
    }