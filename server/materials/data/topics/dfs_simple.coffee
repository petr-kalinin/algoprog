import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default dfs_simple = () ->
    return {
        topic: topic(
            ruen("Основы поиска в глубину", "Basics of Deep Search"),
            ruen("Задачи на простой поиск в глубину", "Problems on simple depth-first search"),
        [label(ruen(
             "<a href=\"https://notes.algoprog.ru/dfs/index.html\">Теория по поиску в глубину</a> (вплоть до самой продвинутой, пока читайте только основы)<br>\nСм. также <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Поиск в глубину (DFS)» <br>\nСм. также <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">видеозаписи лекций ЛКШ параллели B'</a>, раздел «Алгоритмы на графах»<br>\nСм. также <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ параллели B'.2008</a>, раздел «Поиск в глубину» (здесь есть и продвинутые темы, которые вам пока не нужны)",
             "<a href=\"https://notes.algoprog.ru/dfs/index.html\">The theory of searching in depth</a> (up to the most advanced, so far read only the basics)<br>\nSee also the <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">videos of lectures of the Parallel C'</a> LCS, the section \"Deep Search (DFS)\" <br>\nSee also video <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">recordings of lectures of Parallel B'</a> LCS, section \"Algorithms on graphs\"<br>\nSee also the <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">videos of lectures of the Parallel B'.2008</a> LCS, the section \"Search in depth\" (there are also advanced topics that you don't need yet)")),
            problem(164),
            problem(200),
            problem(165),
            problem(166),
            problem(111541),
        ], "dfs_simple"),
        advancedProblems: [
            problem(1190),
            problem(182),
            problem(413),
            problem(111540),
            problem(1928),
        ]
    }