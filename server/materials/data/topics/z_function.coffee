import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default z_function = () ->
    return {
        topic: topic("Z-функция", "Задачи на Z-функцию", [
            label("<p>См. <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ.2008.B'</a>, раздел \"Алгоритмы на строках\".<br>\n<a href=\"https://e-maxx.ru/algo/z_function\">Теория на e-maxx</a><br>\n<a href=\"https://ru.wikipedia.org/wiki/Z-функция\">Теория в википедии (!)</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Z-функция\">Теория на сайте ИТМО</a><br>\n<a href=\"https://habrahabr.ru/post/113266/\">Теория на хабре</a></p>"),
            problem(1324),
            problem(1326),
            problem(3369),
        ], "z_function"),
        advancedProblems: [
            problem(998),
        ]
    }