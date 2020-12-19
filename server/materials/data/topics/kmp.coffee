import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default kmp = () ->
    return {
        topic: topic("Алгоритм Кнута-Морриса-Пратта (КМП)", "Задачи на КМП", [
            label("<p>\nСм. <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ.2008.B'</a>, раздел \"Алгоритмы на строках\".<br>\n<a href=\"https://e-maxx.ru/algo/prefix_function\">Теория на e-maxx</a><br>\n<a href=\"https://habrahabr.ru/post/191454/\">Теория на хабре</a><br>\nМожете в интернете поискать еще.<br>\nПомимо собственно поиска подстроки в строке, префикс-функция также нередко имеет другие полезные применения. Задачи на это ниже тоже есть.<br>\nКакие-то из задач ниже, наверное, были ранее в задачах на хеши. Решите их повторно с использованием КМП.</p>"),
            problem(1323),
            problem(99),
            problem(100),
            problem(1943),
        ], "kmp"),
        advancedProblems: [
            problem(112567),
        ]
    }