import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default linked_lists = () ->
    return {
        topic: topic(
            ruen("Связные списки", "Linked lists"),
            ruen("Задачи на связные списки", "Problems on linked lists"),
        [label(ruen(
             "См. <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ параллели B' (старой)</a>, раздел «Списки»",
             "See video <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">recordings of lectures of the SIS Parallel B' (old)</a>, the \"Lists\" section")),
            label(ruen(
                "В задачах этой темы запрещается использовать стандартные реализации связных списков, а также динамических массивов.",
                "In the tasks of this topic, it is forbidden to use standard implementations of linked lists, as well as dynamic arrays.")),
            problem(59),
            problem(2983),
            problem(412),
        ], "linked_lists"),
        advancedProblems: [
            problem(40),
        ]
    }