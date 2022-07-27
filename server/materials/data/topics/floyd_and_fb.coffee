import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default floyd_and_fb = () ->
    return {
        topic: topic(
            ruen("Алгоритмы Флойда и Форда-Беллмана", "Floyd and Ford-Bellman algorithms"),
            ruen("Задачи на алгоритмы Флойда и Форда-Беллмана", "Problems on Floyd and Ford-Bellman algorithms"),
        [label(ruen(
             "<b>Алгоритм Флойда</b><br>\n<a href=\"https://sis.khashaev.ru/2013/july/b-prime/C-y1_dlKRdY/\">Видеозаписи ЛКШ, 2013, B'</a><br>\n<a href=\"https://sis.khashaev.ru/2008/august/b-prime/kXYH8tIsOEQ/\">Видеозаписи ЛКШ, 2008, B'</a><br>\n<b>Алгоритм Форла-Беллмана</b><br>\n<a href=\"https://sis.khashaev.ru/2013/july/b-prime/1fCe1I5ZV64/\">Видеозаписи ЛКШ, 2013, B'</a><br>\n<a href=\"https://sis.khashaev.ru/2008/august/b-prime/YvdwkhFS2_U/\">Видеозаписи ЛКШ, 2008, B'</a>",
             "<b>Floyd 's Algorithm</b><br>\n<a href=\"https://sis.khashaev.ru/2013/july/b-prime/C-y1_dlKRdY/\">SIS videos, 2013, B'</a><br>\n<a href=\"https://sis.khashaev.ru/2008/august/b-prime/kXYH8tIsOEQ/\">SIS videos, 2008, B'</a><br>\n<b>The Forl-Bellman algorithm</b><br>\n<a href=\"https://sis.khashaev.ru/2013/july/b-prime/1fCe1I5ZV64/\">SIS videos, 2013, B'</a><br>\n<a href=\"https://sis.khashaev.ru/2008/august/b-prime/YvdwkhFS2_U/\">SIS videos, 2008, B'</a>")),
            problem(171),
            problem(97),
            problem(172),
            problem(1332),
            problem(3342),
            problem(178),
            problem(179),
            problem(524),
        ], "floyd_and_fb"),
        advancedProblems: [
            problem(173),
            problem(1995),
            problem(2598),
        ]
    }