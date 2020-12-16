import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default linked_lists = () ->
    return {
        topic: topic("Связные списки", "Задачи на связные списки", [
            label("См. <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ параллели B' (старой)</a>, раздел «Списки»"),
            label("В задачах этой темы запрещается использовать стандартные реализации связных списков, а также динамических массивов."),
            problem(59),
            problem(2983),
            problem(412),
        ], "linked_lists"),
        advancedProblems: [
            problem(40),
        ]
    }