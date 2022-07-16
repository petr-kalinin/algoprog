import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default binsearch = () ->
    return {
        topic: topic(
            ruen("Бинарный поиск (поиск делением пополам)", "Binary search"),
            ruen("Задачи на бинарный поиск", "Problems on binary search"),
        [label(ruen(
             "<a href=\"https://notes.algoprog.ru/binsearch/07_binsearch_main.html\">Теория по бинарному поиску</a>",
             "<a href=\"https://notes.algoprog.ru/binsearch/07_binsearch_main.html\">Theory on binary search</a>")),
            label(ruen(
                "См. также <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">видеозаписи лекций ЛКШ параллели B'</a>, раздел «Бинарный поиск» (хотя там несколько устаревший подход к поиску элемента в массиве).",
                "See also the <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">videos of the lectures of SIS parallel B'</a>, the section \"Binary search\" (although there is a somewhat outdated approach to searching for an element in an array).")),
            problem(3570),
            problem(4),
            problem(2),
            problem(1923),
        ], "binsearch"),
        advancedProblems: [
            problem(672),
            problem(586),
            problem(1),
            problem(490),
            problem(3334),
            problem(1620),
        ]
    }