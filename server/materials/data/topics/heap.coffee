import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default heap = () ->
    return {
        topic: topic(
            ruen("Куча", "Heap"),
            ruen("Задачи на кучу", "Problems on heap"),
        [label(ruen(
             "См. <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">видеозаписи лекций ЛКШ.2013.B'</a>, раздел \"Куча\"<br>\nСм. <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ.2008.B'</a>, раздел \"Куча\"",
             "See the video <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">recordings of lectures of SIS.2013.B'</a>, section \"Heap\"<br>\nSee video <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">recordings of lectures of SIS.2008.B'</a>, section \"Heap\"")),
            problem(755),
            problem(756),
            problem(489),
        ], "heap"),
        advancedProblems: [
            problem(3350),
            problem(1207),
        ]
    }