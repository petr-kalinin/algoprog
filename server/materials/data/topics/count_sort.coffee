import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default count_sort = () ->
    return {
        topic: topic("Сортировка подсчетом", "Задачи на сортировку подсчетом", [
            label("См. <a href=\"https://sis.khashaev.ru/2013/august/c-prime/Prz7x1bkW5Y/\">видеозаписи лекций ЛКШ параллели C'</a><br>\nСм. видеозаписи лекций ЛКШ параллели B' (старой): <a href=\"https://sis.khashaev.ru/2008/august/b-prime/kVcmMxhr-CI/\">раз</a> и <a href=\"https://sis.khashaev.ru/2008/august/b-prime/mkdwnjYkg-g/\">два</a><br>\nСм. <a href=\"https://sis.khashaev.ru/2013/july/b-prime/X27QTFl70lY/\">видеозаписи лекций ЛКШ параллели B' (новой)</a>"),
            label("Набор задач ниже, к сожалению, не очень представителен, но на информатиксе нет больше интересных задач на сортировку подсчетом."),
            problem(111759),
            problem(49),
            problem(1027),
        ], "count_sort"),
        advancedProblems: [
            problem(1216),
        ]
    }