import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default count_sort = () ->
    return {
        topic: topic(
            ruen("Сортировка подсчетом", "Counting sort"),
            ruen("Задачи на сортировку подсчетом", "Problems on counting sort"),
        [label(ruen(
             "См. <a href=\"https://sis.khashaev.ru/2013/august/c-prime/Prz7x1bkW5Y/\">видеозаписи лекций ЛКШ параллели C'</a><br>\nСм. видеозаписи лекций ЛКШ параллели B' (старой): <a href=\"https://sis.khashaev.ru/2008/august/b-prime/kVcmMxhr-CI/\">раз</a> и <a href=\"https://sis.khashaev.ru/2008/august/b-prime/mkdwnjYkg-g/\">два</a><br>\nСм. <a href=\"https://sis.khashaev.ru/2013/july/b-prime/X27QTFl70lY/\">видеозаписи лекций ЛКШ параллели B' (новой)</a>",
             "See video <a href=\"https://sis.khashaev.ru/2013/august/c-prime/Prz7x1bkW5Y/\">recordings of lectures of the Parallel C LCS'</a><br>\nSee the videos of lectures of the SIS parallel B' (old): <a href=\"https://sis.khashaev.ru/2008/august/b-prime/kVcmMxhr-CI/\">one</a> and <a href=\"https://sis.khashaev.ru/2008/august/b-prime/mkdwnjYkg-g/\">two</a><br>\nSee video <a href=\"https://sis.khashaev.ru/2013/july/b-prime/X27QTFl70lY/\">recordings of lectures of the SIS Parallel B' (new)</a>")),
            label(ruen(
                "Набор задач ниже, к сожалению, не очень представителен, но на информатиксе нет больше интересных задач на сортировку подсчетом.",
                "Unfortunately, the set of tasks below is not very representative, but there are no more interesting tasks for count sort on informatics.")),
            problem(111759),
            problem(49),
            problem(1027),
        ], "count_sort"),
        advancedProblems: [
            problem(1216),
        ]
    }