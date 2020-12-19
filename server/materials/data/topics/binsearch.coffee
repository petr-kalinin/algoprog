import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default binsearch = () ->
    return {
        topic: topic("Бинарный поиск (поиск делением пополам)", "Задачи на бинарный поиск", [
            label("<a href=\"https://notes.algoprog.ru/binsearch/07_binsearch_main.html\">Теория по бинарному поиску</a>"),
            label("См. также <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">видеозаписи лекций ЛКШ параллели B'</a>, раздел «Бинарный поиск» (хотя там несколько устаревший подход к поиску элемента в массиве)."),
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