import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default sparse_tables = () ->
    return {
        topic: topic(
            ruen("Sparse tables, двоичный подъем", "Sparse tables, binary ascent"),
            ruen("Задачи на sparse tables", "Problems on sparse tables"),
        [   label(ruen(
             "<p><a href=\"https://habr.com/ru/post/114980/\">Теория на хабре</a><br>\n<a href=\"https://algorithmica.org/ru/sparse-table\">Еще теория</a><br>\nБолее продвинутая структура, нужна не так часто: <a href=\"https://www.youtube.com/watch?v=NbAtm1j5gVA\">Disjoint sparse tables</a></p>",
             "")),
            problem(113919),
            problem(752), 
        ], "sparse_tables"),
        advancedProblems: [
            problem(113550),
        ]
    }
