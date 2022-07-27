import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default bfs = () ->
    return {
        topic: topic(
            ruen("Поиск в ширину", "Breadth-first search (BFS)"),
            ruen("Задачи на поиск в ширину", "Problems on BFS"),
        [label(ruen(
             "См. <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Поиск в ширину (BFS)»<br>\nСм. <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ параллели B' 2008</a>, раздел «Поиск в ширину» (там есть и довольно продвинутые темы, которые вам пока не нужны)<br>",
             "See the <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">videos of lectures of SIS Parallel C'</a>, section \"Breadth Search (BFS)\"<br>\nSee the <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">videos of the lectures of SIS Parallel B' 2008</a>, the section \"Breadth search\" (there are also quite advanced topics that you don't need yet)<br>")),
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